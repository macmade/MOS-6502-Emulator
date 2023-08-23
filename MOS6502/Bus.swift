/*******************************************************************************
 * The MIT License (MIT)
 *
 * Copyright (c) 2023, Jean-David Gadina - www.xs-labs.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the Software), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 ******************************************************************************/

import Foundation
import XSLabsSwift

public class Bus: WritableMemoryDevice, LogSource, Resettable, IRQSource
{
    public var sendIRQ: ( ( @escaping () -> Void ) -> Void )?

    public private( set ) var devices: [ ( address: UInt16, size: UInt64, device: MemoryDevice ) ] = []

    public var logger: Logger?
    {
        didSet
        {
            self.devices.forEach
            {
                if var source = $0 as? LogSource
                {
                    source.logger = self.logger
                }
            }
        }
    }

    public init()
    {}

    public func reset() throws
    {
        try self.devices.forEach
        {
            try ( $0.device as? Resettable )?.reset()
        }
    }

    public func mapDevice( _ device: MemoryDevice, at address: UInt16, size: UInt64 ) throws
    {
        try self.devices.forEach
        {
            let existing = ( UInt64( $0.address ) ..< UInt64( $0.address ) + $0.size )
            let new      = ( UInt64( address )    ..< UInt64( address )    + size )

            if new.overlaps( existing )
            {
                throw RuntimeError( message: "Cannot map device at address: \( address.asHex ): would overlap an existing device" )
            }
        }

        if var irqSource = device as? IRQSource
        {
            irqSource.sendIRQ = self.sendIRQ
        }

        self.devices.append( ( address: address, size: size, device: device ) )
    }

    public func read( at address: UInt16 ) throws -> UInt8
    {
        try self.readUInt8( at: address )
    }

    public func write( _ value: UInt8, at address: UInt16 ) throws
    {
        try self.writeUInt8( value,  at: address )
    }

    public func readUInt8( at address: UInt16 ) throws -> UInt8
    {
        let mapped = try self.deviceForAddress( address )

        return try mapped.device.read( at: mapped.address )
    }

    public func readUInt16( at address: UInt16 ) throws -> UInt16
    {
        let mapped = try self.deviceForAddress( address )
        let u1     = UInt16( try mapped.device.read( at: mapped.address ) )
        let u2     = UInt16( try mapped.device.read( at: mapped.address + 1 ) )

        return ( u2 << 8 ) | u1
    }

    public func writeUInt8( _ value: UInt8, at address: UInt16 ) throws
    {
        let mapped = try self.writableDeviceForAddress( address )

        try mapped.device.write( value, at: mapped.address )
    }

    public func writeUInt16( _ value: UInt16, at address: UInt16 ) throws
    {
        let mapped = try self.writableDeviceForAddress( address )
        let u1     = UInt8( value & 0xFF )
        let u2     = UInt8( ( value >> 8 ) & 0xFF )

        try mapped.device.write( u1, at: mapped.address )
        try mapped.device.write( u2, at: mapped.address + 1 )
    }

    public func deviceForAddress( _ address: UInt16 ) throws -> ( address: UInt16, device: MemoryDevice )
    {
        for mapped in self.devices
        {
            if address >= mapped.address, UInt64( address ) < UInt64( mapped.address ) + mapped.size
            {
                return ( address: address - mapped.address, device: mapped.device )
            }
        }

        throw RuntimeError( message: "No mapped device for address \( address.asHex )" )
    }

    public func writableDeviceForAddress( _ address: UInt16 ) throws -> ( address: UInt16, device: WritableMemoryDevice )
    {
        let mapped = try self.deviceForAddress( address )

        guard let device = mapped.device as? WritableMemoryDevice
        else
        {
            throw RuntimeError( message: "Invalid device for memory address \( address.asHex ): not writable" )
        }

        return ( address: mapped.address, device: device )
    }
}
