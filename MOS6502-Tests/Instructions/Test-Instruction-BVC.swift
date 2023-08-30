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

class Test_Instruction_BVC: Test_Instruction
{
    func testRelative_NotTaken() throws
    {
        try self.executeSingleInstruction(
            instruction:     "BVC",
            addressingMode:  .relative,
            operands:        [ 10 ],
            origin:          0xFF10,
            inputRegisters:  Registers( P: Flags( V: 1 ) ),
            outputRegisters: Registers( PC: 0xFF12 ),
            extraCycles:     0
        )
    }

    func testRelative_Taken_Forward() throws
    {
        try self.executeSingleInstruction(
            instruction:     "BVC",
            addressingMode:  .relative,
            operands:        [ 10 ],
            origin:          0xFF10,
            inputRegisters:  Registers( P: Flags( V: 0 ) ),
            outputRegisters: Registers( PC: 0xFF12 + 10 ),
            extraCycles:     1
        )
    }

    func testRelative_Taken_Forward_PageCross() throws
    {
        try self.executeSingleInstruction(
            instruction:     "BVC",
            addressingMode:  .relative,
            operands:        [ 1 ],
            origin:          0x02FD,
            inputRegisters:  Registers( P: Flags( V: 0 ) ),
            outputRegisters: Registers( PC: 0x02FF + 1 ),
            extraCycles:     2
        )
    }

    func testRelative_Taken_Backward() throws
    {
        try self.executeSingleInstruction(
            instruction:     "BVC",
            addressingMode:  .relative,
            operands:        [ UInt8( bitPattern: -10 ) ],
            origin:          0xFF10,
            inputRegisters:  Registers( P: Flags( V: 0 ) ),
            outputRegisters: Registers( PC: 0xFF12 - 10 ),
            extraCycles:     1
        )
    }

    func testRelative_Taken_Backward_PageCross() throws
    {
        try self.executeSingleInstruction(
            instruction:     "BVC",
            addressingMode:  .relative,
            operands:        [ UInt8( bitPattern: -10 ) ],
            origin:          0xFF00,
            inputRegisters:  Registers( P: Flags( V: 0 ) ),
            outputRegisters: Registers( PC: 0xFF02 - 10 ),
            extraCycles:     2
        )
    }

    func testRelative_Taken_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "BVC",
            addressingMode:  .relative,
            operands:        [ 0x00 ],
            origin:          0xFF10,
            inputRegisters:  Registers( P: Flags( V: 0 ) ),
            outputRegisters: Registers( PC: 0xFF12 ),
            extraCycles:     1
        )
    }
}
