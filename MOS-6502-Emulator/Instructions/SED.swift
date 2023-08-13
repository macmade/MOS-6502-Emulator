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
 * SED - Set Decimal Flag
 *
 * Set the decimal mode flag to one.
 *
 * Flags:
 *     - Carry Flag:           N/A
 *     - Zero Flag:            N/A
 *     - Interrupt Disable:    N/A
 *     - Decimal Mode:         Set to 1
 *     - Break Command:        N/A
 *     - Overflow Flag:        N/A
 *     - Negative Flag:        N/A
 *
 * Reference: https://github.com/macmade/MOS-6502-Emulator/blob/main/Reference/7-Reference.md#SED
 */
public func SED( cpu: CPU ) throws
{
    throw RuntimeError( message: "Instruction not implemented" )
}
