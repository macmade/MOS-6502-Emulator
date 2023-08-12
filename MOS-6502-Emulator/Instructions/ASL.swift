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
 * ASL - Arithmetic Shift Left
 *
 * This operation shifts all the bits of the accumulator or memory contents
 * one bit left. Bit 0 is set to 0 and bit 7 is placed in the carry flag.
 * The effect of this operation is to multiply the memory contents by 2
 * (ignoring 2's complement considerations), setting the carry if the result
 * will not fit in 8 bits.
 *
 * Flags:
 *     - Carry Flag:           Set to contents of old bit 7
 *     - Zero Flag:            Set if A = 0
 *     - Interrupt Disable:    N/A
 *     - Decimal Mode:         N/A
 *     - Break Command:        N/A
 *     - Overflow Flag:        N/A
 *     - Negative Flag:        Set if bit 7 of the result is set
 *
 * Source: https://www.nesdev.org/obelisk-6502-guide/reference.html#ASL
 */
public class ASL
{
    private init()
    {}

    public class func absolute( cpu: CPU ) throws
    {
        throw RuntimeError( message: "Instruction not implemented" )
    }

    public class func absoluteX( cpu: CPU ) throws
    {
        throw RuntimeError( message: "Instruction not implemented" )
    }

    public class func accumulator( cpu: CPU ) throws
    {
        throw RuntimeError( message: "Instruction not implemented" )
    }

    public class func zeroPage( cpu: CPU ) throws
    {
        throw RuntimeError( message: "Instruction not implemented" )
    }

    public class func zeroPageX( cpu: CPU ) throws
    {
        throw RuntimeError( message: "Instruction not implemented" )
    }
}
