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

public class MC6820: WriteableMemoryDevice, LogSource, Resettable, CustomStringConvertible
{
    public var DDRA:   UInt8 = 0 // Data direction register A
    public var DDRB:   UInt8 = 0 // Data direction register B
    public var CRA:    UInt8 = 0 // Control register A
    public var CRB:    UInt8 = 0 // Control register B
    public var ORA:    UInt8 = 0 // Output register A
    public var ORB:    UInt8 = 0 // Output register B
    public var logger: Logger?

    public private( set ) var peripheral1: MC6820Peripheral
    public private( set ) var peripheral2: MC6820Peripheral

    private var ready1Observer: Any?
    private var ready2Observer: Any?

    public init( peripheral1: MC6820Peripheral, peripheral2: MC6820Peripheral )
    {
        self.peripheral1 = peripheral1
        self.peripheral2 = peripheral2

        peripheral1.readyChanged =
        {
            [ weak self ] in self?.ready( on: $0, cr: \.CRA, or: \.ORA, ddr: \.DDRA )
        }

        peripheral2.readyChanged =
        {
            [ weak self ] in self?.ready( on: $0, cr: \.CRB, or: \.ORB, ddr: \.DDRB )
        }
    }

    public func reset() throws
    {
        self.DDRA = 0
        self.DDRB = 0
        self.CRA  = 0
        self.CRB  = 0
        self.ORA  = 0
        self.ORB  = 0
    }

    public func register( for address: UInt16 ) throws -> ReferenceWritableKeyPath< MC6820, UInt8 >
    {
        switch address
        {
            case 0: return ( self.CRA & 0x4 ) == 0 ? \.DDRA : \.ORA
            case 1: return                           \.CRA
            case 2: return ( self.CRB & 0x4 ) == 0 ? \.DDRB : \.ORB
            case 3: return                           \.CRB

            default: throw RuntimeError( message: "Invalid MC6820 PIA register address: \( address.asHex )" )
        }
    }

    public func read( at address: UInt16 ) throws -> UInt8
    {
        let register = try self.register( for: address )
        let value    = self[ keyPath: register ]

        if register == \.ORA
        {
            self.CRA &= 0x3F // Clear IRQ bits with a MPU read

            return value & ( ~( self.DDRA ) )
        }
        else if register == \.ORB
        {
            self.CRB &= 0x3F // Clear IRQ bits with a MPU read

            return value & ( ~( self.DDRB ) )
        }

        return value
    }

    public func write( _ value: UInt8, at address: UInt16 ) throws
    {
        let register = try self.register( for: address )

        if register == \.CRA || register == \.CRB
        {
            self[ keyPath: register ] = value & 0x3F // IRQ bits are read-only
        }
        else if register == \.ORA
        {
            self[ keyPath: register ] = value & self.DDRA
        }
        else if register == \.ORB
        {
            self[ keyPath: register ] = value & self.DDRB
        }
        else
        {
            self[ keyPath: register ] = value
        }
    }

    public var description: String
    {
        "MC6820 PIA"
    }

    private func ready( on peripheral: MC6820Peripheral, cr: ReferenceWritableKeyPath< MC6820, UInt8 >, or: ReferenceWritableKeyPath< MC6820, UInt8 >, ddr: KeyPath< MC6820, UInt8 > )
    {
        if peripheral.ready
        {
            self[ keyPath: or ]    = peripheral.data
            self[ keyPath: cr ]   |= 0x80
            peripheral.acknowledge = true
        }
    }
}
