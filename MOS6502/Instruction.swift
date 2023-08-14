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

public class Instruction
{
    public enum AddressingMode
    {
        case implied
        case accumulator
        case immediate
        case zeroPage
        case zeroPageX
        case zeroPageY
        case relative
        case absolute
        case absoluteX
        case absoluteY
        case indirect
        case indirectX
        case indirectY
    }

    public var mnemonic:       String
    public var opcode:         UInt8
    public var size:           UInt
    public var cycles:         UInt
    public var addressingMode: AddressingMode
    public var execute:        ( CPU, AddressingContext ) throws -> Void

    public init( mnemonic: String, opcode: UInt8, size: UInt, cycles: UInt, addressingMode: AddressingMode, execute: @escaping ( CPU, AddressingContext ) throws -> Void )
    {
        self.mnemonic       = mnemonic
        self.opcode         = opcode
        self.size           = size
        self.cycles         = cycles
        self.addressingMode = addressingMode
        self.execute        = execute
    }
}
