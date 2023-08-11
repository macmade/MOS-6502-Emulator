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

public class Instructions
{
    public typealias Instruction = ( opcode: UInt8, size: UInt, cycles: UInt )

    private init()
    {}

    /*
     * CLD - Clear Decimal Mode
     *
     * Sets the decimal mode flag to zero.
     *
     * Flags:
     *     - Carry Flag:           N/A
     *     - Zero Flag:            N/A
     *     - Interrupt Disable:    N/A
     *     - Decimal Mode:         Set to 0
     *     - Break Command:        N/A
     *     - Overflow Flag:        N/A
     *     - Negative Flag:        N/A
     */
    public static let CLD: Instruction = ( opcode: 0xD8, size: 1, cycles: 2 )

    /*
     * CLI - Clear Interrupt Disable
     *
     * Clears the interrupt disable flag allowing normal interrupt requests to be serviced.
     *
     * Flags:
     *     - Carry Flag:           N/A
     *     - Zero Flag:            N/A
     *     - Interrupt Disable:    Set to 0
     *     - Decimal Mode:         N/A
     *     - Break Command:        N/A
     *     - Overflow Flag:        N/A
     *     - Negative Flag:        N/A
     */
    public static let CLI: Instruction = ( opcode: 0x58, size: 1, cycles: 2 )

    /*
     * LDA - Load Accumulator
     *
     * Loads a byte of memory into the accumulator setting the zero and negative flags as appropriate.
     *
     * Flags:
     *     - Carry Flag:           N/A
     *     - Zero Flag:            Set if A = 0
     *     - Interrupt Disable:    N/A
     *     - Decimal Mode:         N/A
     *     - Break Command:        N/A
     *     - Overflow Flag:        N/A
     *     - Negative Flag:        Set if bit 7 of A is set
     */
    public static let LDA_Immediate: Instruction = ( opcode: 0xA9, size: 2, cycles: 2 )
    public static let LDA_ZeroPage:  Instruction = ( opcode: 0xA5, size: 2, cycles: 3 )
    public static let LDA_ZeroPageX: Instruction = ( opcode: 0xB5, size: 2, cycles: 4 )
    public static let LDA_Absolute:  Instruction = ( opcode: 0xAD, size: 3, cycles: 4 )
    public static let LDA_AbsoluteX: Instruction = ( opcode: 0xBD, size: 3, cycles: 4 ) // +1 if page crossed
    public static let LDA_AbsoluteY: Instruction = ( opcode: 0xB9, size: 3, cycles: 4 ) // +1 if page crossed
    public static let LDA_IndirectX: Instruction = ( opcode: 0xA1, size: 2, cycles: 6 )
    public static let LDA_IndirectY: Instruction = ( opcode: 0xB1, size: 2, cycles: 5 ) // +1 if page crossed

    /*
     * LDX - Load X Register
     *
     * Loads a byte of memory into the X register setting the zero and negative flags as appropriate.
     *
     * Flags:
     *     - Carry Flag:           N/A
     *     - Zero Flag:            Set if X = 0
     *     - Interrupt Disable:    N/A
     *     - Decimal Mode:         N/A
     *     - Break Command:        N/A
     *     - Overflow Flag:        N/A
     *     - Negative Flag:        Set if bit 7 of X is set
     */
    public static let LDX_Immediate: Instruction = ( opcode: 0xA2, size: 2, cycles: 2 )
    public static let LDX_ZeroPage:  Instruction = ( opcode: 0xA6, size: 2, cycles: 3 )
    public static let LDX_ZeroPageY: Instruction = ( opcode: 0xB6, size: 2, cycles: 4 )
    public static let LDX_Absolute:  Instruction = ( opcode: 0xAE, size: 3, cycles: 4 )
    public static let LDX_AbsoluteY: Instruction = ( opcode: 0xBE, size: 3, cycles: 4 ) // +1 if page crossed

    /*
     * LDX - Load Y Register
     *
     * Loads a byte of memory into the Y register setting the zero and negative flags as appropriate.
     *
     * Flags:
     *     - Carry Flag:           N/A
     *     - Zero Flag:            Set if Y = 0
     *     - Interrupt Disable:    N/A
     *     - Decimal Mode:         N/A
     *     - Break Command:        N/A
     *     - Overflow Flag:        N/A
     *     - Negative Flag:        Set if bit 7 of Y is set
     */
    public static let LDY_Immediate: Instruction = ( opcode: 0xA0, size: 2, cycles: 2 )
    public static let LDY_ZeroPage:  Instruction = ( opcode: 0xA4, size: 2, cycles: 3 )
    public static let LDY_ZeroPageX: Instruction = ( opcode: 0xB4, size: 2, cycles: 4 )
    public static let LDY_Absolute:  Instruction = ( opcode: 0xAC, size: 3, cycles: 4 )
    public static let LDY_AbsoluteX: Instruction = ( opcode: 0xBC, size: 3, cycles: 4 ) // +1 if page crossed

    /*
     * STA - Store Accumulator
     *
     * Stores the contents of the accumulator into memory.
     *
     * Flags:
     *     - Carry Flag:           N/A
     *     - Zero Flag:            N/A
     *     - Interrupt Disable:    N/A
     *     - Decimal Mode:         N/A
     *     - Break Command:        N/A
     *     - Overflow Flag:        N/A
     *     - Negative Flag:        N/A
     */
    public static let STA_ZeroPage:  Instruction = ( opcode: 0x85, size: 2, cycles: 3 )
    public static let STA_ZeroPageY: Instruction = ( opcode: 0x95, size: 2, cycles: 4 )
    public static let STA_Absolute:  Instruction = ( opcode: 0x8D, size: 3, cycles: 4 )
    public static let STA_AbsoluteX: Instruction = ( opcode: 0x9D, size: 3, cycles: 5 )
    public static let STA_AbsoluteY: Instruction = ( opcode: 0x99, size: 3, cycles: 5 )
    public static let STA_IndirectX: Instruction = ( opcode: 0x81, size: 2, cycles: 6 )
    public static let STA_IndirectY: Instruction = ( opcode: 0x91, size: 2, cycles: 6 )

    /*
     * STY - Store X Register
     *
     * Stores the contents of the X register into memory.
     *
     * Flags:
     *     - Carry Flag:           N/A
     *     - Zero Flag:            N/A
     *     - Interrupt Disable:    N/A
     *     - Decimal Mode:         N/A
     *     - Break Command:        N/A
     *     - Overflow Flag:        N/A
     *     - Negative Flag:        N/A
     */
    public static let STX_ZeroPage:  Instruction = ( opcode: 0x86, size: 2, cycles: 2 )
    public static let STX_ZeroPageY: Instruction = ( opcode: 0x96, size: 2, cycles: 4 )
    public static let STX_Absolute:  Instruction = ( opcode: 0x8E, size: 3, cycles: 4 )

    /*
     * STY - Store Y Register
     *
     * Stores the contents of the Y register into memory.
     *
     * Flags:
     *     - Carry Flag:           N/A
     *     - Zero Flag:            N/A
     *     - Interrupt Disable:    N/A
     *     - Decimal Mode:         N/A
     *     - Break Command:        N/A
     *     - Overflow Flag:        N/A
     *     - Negative Flag:        N/A
     */
    public static let STY_ZeroPage:  Instruction = ( opcode: 0x84, size: 2, cycles: 2 )
    public static let STY_ZeroPageX: Instruction = ( opcode: 0x94, size: 2, cycles: 4 )
    public static let STY_Absolute:  Instruction = ( opcode: 0x8C, size: 3, cycles: 4 )
}
