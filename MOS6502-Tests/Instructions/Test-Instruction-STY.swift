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

class Test_Instruction_STY: Test_Instruction
{
    func testAbsolute() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "STY",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( Y: 0x42 ),
            outputRegisters: Registers(),
            extraCycles:     0
        )

        XCTAssertEqual( try result.bus.read( at: 0x1000 ), 0x42 )
    }

    func testZeroPage() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "STY",
            addressingMode:  .zeroPage,
            operands:        [ 0x10 ],
            inputRegisters:  Registers( Y: 0x42 ),
            outputRegisters: Registers(),
            extraCycles:     0
        )

        XCTAssertEqual( try result.bus.read( at: 0x10 ), 0x42 )
    }

    func testZeroPageX() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "STY",
            addressingMode:  .zeroPageX,
            operands:        [ 0x10 ],
            inputRegisters:  Registers( X: 0x10, Y: 0x42 ),
            outputRegisters: Registers(),
            extraCycles:     0
        )

        XCTAssertEqual( try result.bus.read( at: 0x20 ), 0x42 )
    }

    func testZeroPageX_Wrap() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "STY",
            addressingMode:  .zeroPageX,
            operands:        [ 0xEF ],
            inputRegisters:  Registers( X: 0x20, Y: 0x42 ),
            outputRegisters: Registers(),
            extraCycles:     0
        )

        XCTAssertEqual( try result.bus.read( at: 0x0F ), 0x42 )
    }
}
