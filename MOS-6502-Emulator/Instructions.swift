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
}
