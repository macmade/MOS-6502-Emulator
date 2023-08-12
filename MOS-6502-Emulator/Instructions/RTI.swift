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
 * RTI - Return from Interrupt
 *
 * The RTI instruction is used at the end of an interrupt processing routine.
 * It pulls the processor flags from the stack followed by the program counter.
 *
 * https://www.nesdev.org/obelisk-6502-guide/reference.html#RTI
 *
 * Flags:
 *     - Carry Flag:           Set from stack
 *     - Zero Flag:            Set from stack
 *     - Interrupt Disable:    Set from stack
 *     - Decimal Mode:         Set from stack
 *     - Break Command:        Set from stack
 *     - Overflow Flag:        Set from stack
 *     - Negative Flag:        Set from stack
 */
public class RTI
{
    private init()
    {}

    public class func implicit( cpu: CPU ) throws
    {
        throw RuntimeError( message: "Instruction not implemented" )
    }
}
