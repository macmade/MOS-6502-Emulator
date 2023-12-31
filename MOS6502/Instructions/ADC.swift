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
 * ADC - Add with Carry
 *
 *     A,Z,C,N = A+M+C
 *
 * This instruction adds the contents of a memory location to the accumulator
 * together with the carry bit.
 * If overflow occurs the carry bit is set, this enables multiple byte addition
 * to be performed.
 *
 * Flags:
 *     - Carry Flag:           Set if overflow in bit 7
 *     - Zero Flag:            Set if A = 0
 *     - Interrupt Disable:    N/A
 *     - Decimal Mode:         N/A
 *     - Break Command:        N/A
 *     - Overflow Flag:        Set if sign bit is incorrect
 *     - Negative Flag:        Set if bit 7 set
 *
 * Reference: https://github.com/macmade/MOS-6502-Emulator/blob/main/Reference/7-Reference.md#ADC
 */
public func ADC( cpu: CPU, context: AddressingContext ) throws
{
    let base        = cpu.registers.A
    let add         = try context.read()
    let carry       = cpu.registers.P.contains( .carryFlag ) ? UInt8( 1 ) : UInt8( 0 )
    let result      = UInt16( cpu.registers.A ) + UInt16( add ) + UInt16( carry )
    cpu.registers.A = UInt8( result & 0xFF )

    if base & ( 1 << 7 ) == 0, add & ( 1 << 7 ) == 0, cpu.registers.A & ( 1 << 7 ) != 0
    {
        cpu.setFlag( .overflowFlag )
    }
    else if base & ( 1 << 7 ) != 0, add & ( 1 << 7 ) != 0, cpu.registers.A & ( 1 << 7 ) == 0
    {
        cpu.setFlag( .overflowFlag )
    }
    else
    {
        cpu.clearFlag( .overflowFlag )
    }

    cpu.setFlag( result > 0xFF, for: .carryFlag )
    cpu.setZeroAndNegativeFlags( for: cpu.registers.A )
}
