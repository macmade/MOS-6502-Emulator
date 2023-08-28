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
    private var readValue:     ()        throws -> UInt8
    private var writeValue:    ( UInt8 ) throws -> Void
    private var sourceAddress: UInt16?

    public var additionalCycles: UInt = 0

    public var address: UInt16
    {
        get throws
        {
            guard let address = self.sourceAddress
            else
            {
                throw RuntimeError( message: "No address available for the current addressing mode" )
            }

            return address
        }
    }

    public convenience init( address: UInt16, cpu: CPU )
    {
        self.init( address: address, cpu: cpu, additionalCycles: 0 )
    }

    public convenience init( address: UInt16, cpu: CPU, additionalCycles: UInt )
    {
        self.init
        {
            try cpu.readUInt8FromMemory( at: address )
        }
        write:
        {
            try cpu.writeUInt8ToMemory( $0, at: address )
        }

        self.sourceAddress    = address
        self.additionalCycles = additionalCycles
    }

    public init( read: @escaping () throws -> UInt8, write: @escaping ( UInt8 ) throws -> Void )
    {
        self.readValue  = read
        self.writeValue = write
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
            cpu.registers.A
        }
        write:
        {
            cpu.registers.A = $0
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
        AddressingContext( address: UInt16( try cpu.readUInt8FromMemoryAtPC() ), cpu: cpu )
    }

    public class func zeroPageX( cpu: CPU, instruction: Instruction ) throws -> AddressingContext
    {
        AddressingContext( address: UInt16( try cpu.readUInt8FromMemoryAtPC() &+ cpu.registers.X ), cpu: cpu )
    }

    public class func zeroPageY( cpu: CPU, instruction: Instruction ) throws -> AddressingContext
    {
        AddressingContext( address: UInt16( try cpu.readUInt8FromMemoryAtPC() &+ cpu.registers.Y ), cpu: cpu )
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
        AddressingContext( address: try cpu.readUInt16FromMemoryAtPC(), cpu: cpu )
    }

    public class func absoluteX( cpu: CPU, instruction: Instruction ) throws -> AddressingContext
    {
        let base   = try cpu.readUInt16FromMemoryAtPC()
        let offset = cpu.registers.X

        if UInt64( base ) + UInt64( offset ) > UInt16.max
        {
            throw RuntimeError( message: "Invalid Absolute,X memory address: \( base.asHex ),\( offset.asHex )" )
        }

        return AddressingContext( address: base + UInt16( offset ), cpu: cpu, additionalCycles: instruction.extraCycles == .ifPageCrossed && AddressingContext.pageCrossed( base: base, offset: offset ) ? 1 : 0 )
    }

    public class func absoluteY( cpu: CPU, instruction: Instruction ) throws -> AddressingContext
    {
        let base   = try cpu.readUInt16FromMemoryAtPC()
        let offset = cpu.registers.Y

        if UInt64( base ) + UInt64( offset ) > UInt16.max
        {
            throw RuntimeError( message: "Invalid Absolute,Y memory address: \( base.asHex ),\( offset.asHex )" )
        }

        return AddressingContext( address: base + UInt16( offset ), cpu: cpu, additionalCycles: instruction.extraCycles == .ifPageCrossed && AddressingContext.pageCrossed( base: base, offset: offset ) ? 1 : 0 )
    }

    public class func indirect( cpu: CPU, instruction: Instruction ) throws -> AddressingContext
    {
        AddressingContext( address: try cpu.readUInt16FromMemory( at: try cpu.readUInt16FromMemoryAtPC() ), cpu: cpu )
    }

    public class func indirectX( cpu: CPU, instruction: Instruction ) throws -> AddressingContext
    {
        let zp = UInt16( try cpu.readUInt8FromMemoryAtPC() &+ cpu.registers.X )

        return AddressingContext( address: try cpu.readUInt16FromMemory( at: zp ), cpu: cpu )
    }

    public class func indirectY( cpu: CPU, instruction: Instruction ) throws -> AddressingContext
    {
        let zp     = try cpu.readUInt8FromMemoryAtPC()
        let base   = try cpu.readUInt16FromMemory( at: UInt16( zp ) )
        let offset = cpu.registers.Y

        if UInt64( base ) + UInt64( offset ) > UInt16.max
        {
            throw RuntimeError( message: "Invalid (Indirect),Y memory address: (\( zp.asHex )),\( offset.asHex ) = \( base.asHex ) + \( offset.asHex )" )
        }

        return AddressingContext( address: base + UInt16( offset ), cpu: cpu, additionalCycles: instruction.extraCycles == .ifPageCrossed && AddressingContext.pageCrossed( base: base, offset: offset ) ? 1 : 0 )
    }

    private class func pageCrossed( base: UInt16, offset: UInt8 ) -> Bool
    {
        let address = UInt64( base ) + UInt64( offset )

        return UInt64( base & 0xFF00 ) != ( address & 0xFF00 )
    }
}
