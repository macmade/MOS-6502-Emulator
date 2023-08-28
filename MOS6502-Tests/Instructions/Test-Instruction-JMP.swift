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

class Test_Instruction_JMP: Test_Instruction
{
    func testAbsolute() throws
    {
        try self.executeSingleInstruction(
            instruction:     "JMP",
            addressingMode:  .absolute,
            operand16:       0x0000,
            origin:          0xFF00,
            inputRegisters:  Registers(),
            outputRegisters: Registers( PC: 0x0000 ),
            extraCycles:     0
        )
    }

    func testAbsolute_Loop() throws
    {
        try self.executeSingleInstruction(
            instruction:     "JMP",
            addressingMode:  .absolute,
            operand16:       0xFF00,
            origin:          0xFF00,
            inputRegisters:  Registers(),
            outputRegisters: Registers( PC: 0xFF00 ),
            extraCycles:     0
        )
    }

    func testIndirect() throws
    {
        try self.executeSingleInstruction(
            instruction:     "JMP",
            addressingMode:  .indirect,
            operand16:       0x0000,
            origin:          0xFF00,
            inputRegisters:  Registers(),
            outputRegisters: Registers( PC: 0x1000 ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.writeUInt16( 0x1000, at: 0x0000 )
        }
    }

    func testIndirect_Loop() throws
    {
        try self.executeSingleInstruction(
            instruction:     "JMP",
            addressingMode:  .indirect,
            operand16:       0x0000,
            origin:          0xFF00,
            inputRegisters:  Registers(),
            outputRegisters: Registers( PC: 0xFF00 ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.writeUInt16( 0xFF00, at: 0x0000 )
        }
    }
}
