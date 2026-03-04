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

/*
 * SBC - Subtract with Carry
 *
 *    A,Z,C,N = A-M-(1-C)
 *
 * This instruction subtracts the contents of a memory location to the
 * accumulator together with the not of the carry bit.
 * If overflow occurs the carry bit is clear, this enables multiple byte
 * subtraction to be performed.
 *
 * Flags:
 *     - Carry Flag:           Clear if overflow in bit 7
 *     - Zero Flag:            Set if A = 0
 *     - Interrupt Disable:    N/A
 *     - Decimal Mode:         N/A
 *     - Break Command:        N/A
 *     - Overflow Flag:        Set if sign bit is incorrect
 *     - Negative Flag:        Set if bit 7 set
 *
 * Reference: https://github.com/macmade/MOS-6502-Emulator/blob/main/Reference/7-Reference.md#SBC
 */
public func SBC( cpu: CPU, context: AddressingContext ) throws
{
    if cpu.registers.P.contains( .decimalMode )
    {
        try SBCDecimal( cpu: cpu, context: context )
    }
    else
    {
        try SBCBinary( cpu: cpu, context: context )
    }
}

public func SBCBinary( cpu: CPU, context: AddressingContext ) throws
{
    let base        = cpu.registers.A
    let sub         = try context.read()
    let carry       = cpu.registers.P.contains( .carryFlag ) ? UInt8( 1 ) : UInt8( 0 )
    let result      = UInt16( base ) &- UInt16( sub ) &- UInt16( 1 - carry )
    cpu.registers.A = UInt8( result & 0xFF )

    cpu.setFlag( ( ( base ^ cpu.registers.A ) & ( base ^ sub ) & 0x80 ) != 0, for: .overflowFlag )
    cpu.setFlag( UInt16( base ) >= ( UInt16( sub ) + UInt16( 1 - carry ) ), for: .carryFlag )
    cpu.setZeroAndNegativeFlags( for: cpu.registers.A )
}

public func SBCDecimal( cpu: CPU, context: AddressingContext ) throws
{
    let base              = cpu.registers.A
    let sub               = try context.read()
    let carry             = cpu.registers.P.contains( .carryFlag ) ? UInt8( 1 ) : UInt8( 0 )
    let borrow            = UInt8( 1 - carry )
    let binaryResult      = UInt16( base ) &- UInt16( sub ) &- UInt16( borrow )
    let binaryAccumulator = UInt8( binaryResult & 0xFF )

    var low  = Int( base & 0x0F ) - Int( sub & 0x0F ) - Int( borrow )
    var high = Int( base >> 4 )   - Int( sub >> 4 )

    if low < 0
    {
        low  -= 0x06
        high -= 1
    }

    if high < 0
    {
        high -= 0x06
    }

    cpu.registers.A = UInt8( ( ( high << 4 ) & 0xF0 ) | ( low & 0x0F ) )

    cpu.setFlag( ( ( base ^ binaryAccumulator ) & ( base ^ sub ) & 0x80 ) != 0, for: .overflowFlag )
    cpu.setFlag( binaryResult < 0x100, for: .carryFlag )
    cpu.setZeroAndNegativeFlags( for: binaryAccumulator )
}
