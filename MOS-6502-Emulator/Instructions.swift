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
    public static let CLD: UInt8 = 0xD8 // 1 byte, 2 cycles

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
    public static let CLI: UInt8 = 0x58 // 1 byte, 2 cycles

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
    public static let LDA_Immediate: UInt8 = 0xA9 // 2 bytes, 2 cycles
    public static let LDA_ZeroPage:  UInt8 = 0xA5 // 2 bytes, 3 cycles
    public static let LDA_ZeroPageX: UInt8 = 0xB5 // 2 bytes, 4 cycles
    public static let LDA_Absolute:  UInt8 = 0xAD // 3 bytes, 4 cycles
    public static let LDA_AbsoluteX: UInt8 = 0xBD // 3 bytes, 4 cycles (+1 if page crossed)
    public static let LDA_AbsoluteY: UInt8 = 0xB9 // 3 bytes, 4 cycles (+1 if page crossed)
    public static let LDA_IndirectX: UInt8 = 0xA1 // 2 bytes, 6 cycles
    public static let LDA_IndirectY: UInt8 = 0xB1 // 2 bytes, 5 cycles (+1 if page crossed)

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
    public static let LDX_Immediate: UInt8 = 0xA2 // 2 bytes, 2 cycles
    public static let LDX_ZeroPage:  UInt8 = 0xA6 // 2 bytes, 3 cycles
    public static let LDX_ZeroPageY: UInt8 = 0xB6 // 2 bytes, 4 cycles
    public static let LDX_Absolute:  UInt8 = 0xAE // 3 bytes, 4 cycles
    public static let LDX_AbsoluteY: UInt8 = 0xBE // 3 bytes, 4 cycles (+1 if page crossed)

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
    public static let LDY_Immediate: UInt8 = 0xA0 // 2 bytes, 2 cycles
    public static let LDY_ZeroPage:  UInt8 = 0xA4 // 2 bytes, 3 cycles
    public static let LDY_ZeroPageX: UInt8 = 0xB4 // 2 bytes, 4 cycles
    public static let LDY_Absolute:  UInt8 = 0xAC // 3 bytes, 4 cycles
    public static let LDY_AbsoluteX: UInt8 = 0xBC // 3 bytes, 4 cycles (+1 if page crossed)

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
    public static let STA_ZeroPage:  UInt8 = 0x85 // 2 bytes, 3 cycles
    public static let STA_ZeroPageY: UInt8 = 0x95 // 2 bytes, 4 cycles
    public static let STA_Absolute:  UInt8 = 0x8D // 3 bytes, 4 cycles
    public static let STA_AbsoluteX: UInt8 = 0x9D // 3 bytes, 5 cycles
    public static let STA_AbsoluteY: UInt8 = 0x99 // 3 bytes, 5 cycles
    public static let STA_IndirectX: UInt8 = 0x81 // 2 bytes, 6 cycles
    public static let STA_IndirectY: UInt8 = 0x91 // 2 bytes, 6 cycles

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
    public static let STX_ZeroPage:  UInt8 = 0x86 // 2 bytes, 2 cycles
    public static let STX_ZeroPageY: UInt8 = 0x96 // 2 bytes, 4 cycles
    public static let STX_Absolute:  UInt8 = 0x8E // 3 bytes, 4 cycles

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
    public static let STY_ZeroPage:  UInt8 = 0x84 // 2 bytes, 2 cycles
    public static let STY_ZeroPageX: UInt8 = 0x94 // 2 bytes, 4 cycles
    public static let STY_Absolute:  UInt8 = 0x8C // 3 bytes, 4 cycles
}
