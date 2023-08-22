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
 * BIT - Bit Test
 *
 * This instructions is used to test if one or more bits are set in a target
 * memory location. The mask pattern in A is ANDed with the value in memory
 * to set or clear the zero flag, but the result is not kept.
 * Bits 7 and 6 of the value from memory are copied into the N and V flags.
 *
 * Flags:
 *     - Carry Flag:           N/A
 *     - Zero Flag:            Set if the result if the AND is zero
 *     - Interrupt Disable:    N/A
 *     - Decimal Mode:         N/A
 *     - Break Command:        N/A
 *     - Overflow Flag:        Set to bit 6 of the memory value
 *     - Negative Flag:        Set to bit 7 of the memory value
 *
 * Reference: https://github.com/macmade/MOS-6502-Emulator/blob/main/Reference/7-Reference.md#BIT
 */
public func BIT( cpu: CPU, context: AddressingContext ) throws
{
    let value = try context.read()
    let mask  = cpu.registers.A

    cpu.setFlag( value & ( 1 << 6 ) != 0, for: .overflowFlag )
    cpu.setZeroAndNegativeFlags( for: value & mask )
}
