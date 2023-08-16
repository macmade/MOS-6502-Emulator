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

import MOS6502
import XCTest

class Test_Instruction_DEX: Test_Instruction
{
    func testImplied() throws
    {
        try self.executeSingleInstruction(
            instruction:     "DEX",
            addressingMode:  .implied,
            operands:        [],
            inputRegisters:  Registers( A: 0, X: 42, Y: 0, PS: Flags( C: 0, Z: 0, I: 0, D: 0, B: 0, V: 0, N: 0 ) ),
            outputRegisters: Registers( A: 0, X: 41, Y: 0, PS: Flags( C: 0, Z: 0, I: 0, D: 0, B: 0, V: 0, N: 0 ) )
        )

        try self.executeSingleInstruction(
            instruction:     "DEX",
            addressingMode:  .implied,
            operands:        [],
            inputRegisters:  Registers( A: 42, X: 42, Y: 42, PS: Flags( C: 1, Z: 1, I: 1, D: 1, B: 1, V: 1, N: 1 ) ),
            outputRegisters: Registers( A: 42, X: 41, Y: 42, PS: Flags( C: 1, Z: 0, I: 1, D: 1, B: 1, V: 1, N: 0 ) )
        )

        try self.executeSingleInstruction(
            instruction:     "DEX",
            addressingMode:  .implied,
            operands:        [],
            inputRegisters:  Registers( A: 0, X: 1, Y: 0, PS: Flags( C: 0, Z: 0, I: 0, D: 0, B: 0, V: 0, N: 0 ) ),
            outputRegisters: Registers( A: 0, X: 0, Y: 0, PS: Flags( C: 0, Z: 1, I: 0, D: 0, B: 0, V: 0, N: 0 ) )
        )

        try self.executeSingleInstruction(
            instruction:     "DEX",
            addressingMode:  .implied,
            operands:        [],
            inputRegisters:  Registers( A: 0, X: 0x00, Y: 0, PS: Flags( C: 0, Z: 0, I: 0, D: 0, B: 0, V: 0, N: 0 ) ),
            outputRegisters: Registers( A: 0, X: 0xFF, Y: 0, PS: Flags( C: 0, Z: 0, I: 0, D: 0, B: 0, V: 0, N: 1 ) )
        )

        try self.executeSingleInstruction(
            instruction:     "DEX",
            addressingMode:  .implied,
            operands:        [],
            inputRegisters:  Registers( A: 0, X: 0xFF, Y: 0, PS: Flags( C: 0, Z: 0, I: 0, D: 0, B: 0, V: 0, N: 0 ) ),
            outputRegisters: Registers( A: 0, X: 0xFE, Y: 0, PS: Flags( C: 0, Z: 0, I: 0, D: 0, B: 0, V: 0, N: 1 ) )
        )

        try self.executeSingleInstruction(
            instruction:     "DEX",
            addressingMode:  .implied,
            operands:        [],
            inputRegisters:  Registers( A: 0, X: 0x81, Y: 0, PS: Flags( C: 0, Z: 0, I: 0, D: 0, B: 0, V: 0, N: 0 ) ),
            outputRegisters: Registers( A: 0, X: 0x80, Y: 0, PS: Flags( C: 0, Z: 0, I: 0, D: 0, B: 0, V: 0, N: 1 ) )
        )

        try self.executeSingleInstruction(
            instruction:     "DEX",
            addressingMode:  .implied,
            operands:        [],
            inputRegisters:  Registers( A: 0, X: 0x80, Y: 0, PS: Flags( C: 0, Z: 0, I: 0, D: 0, B: 0, V: 0, N: 0 ) ),
            outputRegisters: Registers( A: 0, X: 0x7F, Y: 0, PS: Flags( C: 0, Z: 0, I: 0, D: 0, B: 0, V: 0, N: 0 ) )
        )
    }
}
