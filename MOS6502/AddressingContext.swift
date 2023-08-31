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

public class AddressingContext
{
    private var readValue:        ( ()        throws -> UInt8 )
    private var writeValue:       ( ( UInt8 ) throws -> Void )
    private var readAddressLSB:   ( () throws -> UInt8 )?
    private var readAddressMSB:   ( () throws -> UInt8 )?
    private var addressTransform: ( ( UInt16 ) throws -> ( address: UInt16, extraCycles: UInt ) )?
    private var address:          UInt16?

    public var extraCycles: UInt = 0

    public convenience init( cpu: CPU, readAddressLSB: @escaping () throws -> UInt8, readAddressMSB: @escaping () throws -> UInt8, addressTransform: @escaping ( UInt16 ) throws -> ( address: UInt16, extraCycles: UInt ) )
    {
        self.init( read: { 0 }, write: { _ in } )

        self.readValue =
        {
            [ weak cpu ] in guard let cpu = cpu
            else
            {
                throw RuntimeError( message: "Invalid CPU" )
            }

            return try cpu.readUInt8FromMemory( at: self.readAddress() )
        }

        self.writeValue =
        {
            [ weak cpu ] in guard let cpu = cpu
            else
            {
                throw RuntimeError( message: "Invalid CPU" )
            }

            return try cpu.writeUInt8ToMemory( $0, at: self.readAddress() )
        }

        self.readAddressLSB   = readAddressLSB
        self.readAddressMSB   = readAddressMSB
        self.addressTransform = addressTransform
    }

    public init( read: @escaping () throws -> UInt8, write: @escaping ( UInt8 ) throws -> Void )
    {
        self.readValue  = read
        self.writeValue = write
    }

    public func readAddress( _ betweenReads: ( () throws -> Void )? = nil ) throws -> UInt16
    {
        if let address = self.address
        {
            return address
        }

        guard let readLSB = self.readAddressLSB, let readMSB = self.readAddressMSB, let transform = self.addressTransform
        else
        {
            throw RuntimeError( message: "Invalid addressing context" )
        }

        let lsb = try readLSB()

        try betweenReads?()

        let msb    = try readMSB()
        let result = try transform( ( UInt16( msb ) << 8 ) | UInt16( lsb ) )

        self.address      = result.address
        self.extraCycles += result.extraCycles

        return result.address
    }

    public func read() throws -> UInt8
    {
        try self.readValue()
    }

    public func write( _ value: UInt8 ) throws
    {
        try self.writeValue( value )
    }

    public class func context( for instruction: Instruction, cpu: CPU ) throws -> AddressingContext
    {
        switch instruction.addressingMode
        {
            case .implied:     return try AddressingContext.implied(     cpu: cpu, instruction: instruction )
            case .accumulator: return try AddressingContext.accumulator( cpu: cpu, instruction: instruction )
            case .immediate:   return try AddressingContext.immediate(   cpu: cpu, instruction: instruction )
            case .zeroPage:    return try AddressingContext.zeroPage(    cpu: cpu, instruction: instruction )
            case .zeroPageX:   return try AddressingContext.zeroPageX(   cpu: cpu, instruction: instruction )
            case .zeroPageY:   return try AddressingContext.zeroPageY(   cpu: cpu, instruction: instruction )
            case .relative:    return try AddressingContext.relative(    cpu: cpu, instruction: instruction )
            case .absolute:    return try AddressingContext.absolute(    cpu: cpu, instruction: instruction )
            case .absoluteX:   return try AddressingContext.absoluteX(   cpu: cpu, instruction: instruction )
            case .absoluteY:   return try AddressingContext.absoluteY(   cpu: cpu, instruction: instruction )
            case .indirect:    return try AddressingContext.indirect(    cpu: cpu, instruction: instruction )
            case .indirectX:   return try AddressingContext.indirectX(   cpu: cpu, instruction: instruction )
            case .indirectY:   return try AddressingContext.indirectY(   cpu: cpu, instruction: instruction )
        }
    }

    public class func implied( cpu: CPU, instruction: Instruction ) throws -> AddressingContext
    {
        AddressingContext
        {
            throw RuntimeError( message: "Reading not supported for implied addressing mode" )
        }
        write:
        {
            _  in throw RuntimeError( message: "Writing not supported for implied addressing mode" )
        }
    }

    public class func accumulator( cpu: CPU, instruction: Instruction ) throws -> AddressingContext
    {
        AddressingContext
        {
            [ weak cpu ] in guard let cpu = cpu
            else
            {
                throw RuntimeError( message: "Invalid CPU" )
            }

            return cpu.registers.A
        }
        write:
        {
            [ weak cpu ] in guard let cpu = cpu
            else
            {
                throw RuntimeError( message: "Invalid CPU" )
            }

            return cpu.registers.A = $0
        }
    }

    public class func immediate( cpu: CPU, instruction: Instruction ) throws -> AddressingContext
    {
        let value = try cpu.readUInt8FromMemoryAtPC()

        return AddressingContext
        {
            value
        }
        write:
        {
            _  in throw RuntimeError( message: "Writing not supported for immediate addressing mode" )
        }
    }

    public class func zeroPage( cpu: CPU, instruction: Instruction ) throws -> AddressingContext
    {
        AddressingContext( cpu: cpu, readAddressLSB: { try cpu.readUInt8FromMemoryAtPC() }, readAddressMSB: { 0 }, addressTransform: { ( $0, 0 ) } )
    }

    public class func zeroPageX( cpu: CPU, instruction: Instruction ) throws -> AddressingContext
    {
        AddressingContext( cpu: cpu, readAddressLSB: { try cpu.readUInt8FromMemoryAtPC() &+ cpu.registers.X }, readAddressMSB: { 0 }, addressTransform: { ( $0, 0 ) } )
    }

    public class func zeroPageY( cpu: CPU, instruction: Instruction ) throws -> AddressingContext
    {
        AddressingContext( cpu: cpu, readAddressLSB: { try cpu.readUInt8FromMemoryAtPC() &+ cpu.registers.Y }, readAddressMSB: { 0 }, addressTransform: { ( $0, 0 ) } )
    }

    public class func relative( cpu: CPU, instruction: Instruction ) throws -> AddressingContext
    {
        let value = try cpu.readUInt8FromMemoryAtPC()

        return AddressingContext
        {
            value
        }
        write:
        {
            _  in throw RuntimeError( message: "Writing not supported for relative addressing mode" )
        }
    }

    public class func absolute( cpu: CPU, instruction: Instruction ) throws -> AddressingContext
    {
        AddressingContext( cpu: cpu, readAddressLSB: { try cpu.readUInt8FromMemoryAtPC() }, readAddressMSB: { try cpu.readUInt8FromMemoryAtPC() }, addressTransform: { ( $0, 0 ) } )
    }

    public class func absoluteX( cpu: CPU, instruction: Instruction ) throws -> AddressingContext
    {
        AddressingContext( cpu: cpu, readAddressLSB: { try cpu.readUInt8FromMemoryAtPC() }, readAddressMSB: { try cpu.readUInt8FromMemoryAtPC() } )
        {
            ( $0 &+ UInt16( cpu.registers.X ), instruction.extraCycles == .ifPageCrossed && AddressingContext.pageCrossed( base: $0, offset: cpu.registers.X ) ? 1 : 0  )
        }
    }

    public class func absoluteY( cpu: CPU, instruction: Instruction ) throws -> AddressingContext
    {
        AddressingContext( cpu: cpu, readAddressLSB: { try cpu.readUInt8FromMemoryAtPC() }, readAddressMSB: { try cpu.readUInt8FromMemoryAtPC() } )
        {
            ( $0 &+ UInt16( cpu.registers.Y ), instruction.extraCycles == .ifPageCrossed && AddressingContext.pageCrossed( base: $0, offset: cpu.registers.Y ) ? 1 : 0  )
        }
    }

    public class func indirect( cpu: CPU, instruction: Instruction ) throws -> AddressingContext
    {
        AddressingContext( cpu: cpu, readAddressLSB: { try cpu.readUInt8FromMemoryAtPC() }, readAddressMSB: { try cpu.readUInt8FromMemoryAtPC() } )
        {
            [ weak cpu ] in guard let cpu = cpu
            else
            {
                throw RuntimeError( message: "Invalid CPU" )
            }

            return ( try cpu.readUInt16FromMemory( at: $0 ), 0 )
        }
    }

    public class func indirectX( cpu: CPU, instruction: Instruction ) throws -> AddressingContext
    {
        AddressingContext( cpu: cpu, readAddressLSB: { try cpu.readUInt8FromMemoryAtPC() }, readAddressMSB: { 0 } )
        {
            [ weak cpu ] in guard let cpu = cpu
            else
            {
                throw RuntimeError( message: "Invalid CPU" )
            }

            return ( try cpu.readUInt16FromMemory( at: UInt16( UInt8( $0 ) &+ cpu.registers.X ) ), 0 )
        }
    }

    public class func indirectY( cpu: CPU, instruction: Instruction ) throws -> AddressingContext
    {
        AddressingContext( cpu: cpu, readAddressLSB: { try cpu.readUInt8FromMemoryAtPC() }, readAddressMSB: { 0 } )
        {
            [ weak cpu ] in guard let cpu = cpu
            else
            {
                throw RuntimeError( message: "Invalid CPU" )
            }

            let address = try cpu.readUInt16FromMemory( at: $0 )

            return ( address &+ UInt16( cpu.registers.Y ), instruction.extraCycles == .ifPageCrossed && AddressingContext.pageCrossed( base: address, offset: cpu.registers.Y ) ? 1 : 0 )
        }
    }

    public class func pageCrossed( base: UInt16, offset: UInt8 ) -> Bool
    {
        let address = UInt64( base ) + UInt64( offset )

        return UInt64( base & 0xFF00 ) != ( address & 0xFF00 )
    }

    public class func pageCrossed( from address1: UInt16, to address2: UInt16 ) -> Bool
    {
        return UInt64( address1 & 0xFF00 ) != ( address2 & 0xFF00 )
    }
}
