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

class Test_Instruction_STA: Test_Instruction
{
    func testAbsolute() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "STA",
            addressingMode:  .absolute,
            operand:         0x1000,
            inputRegisters:  Registers( A: 0x42 ),
            outputRegisters: Registers()
        )

        XCTAssertEqual( try result.bus.read( at: 0x1000 ), 0x42 )
    }

    func testAbsoluteX() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "STA",
            addressingMode:  .absoluteX,
            operand:         0x1000,
            inputRegisters:  Registers( A: 0x42, X: 0x20 ),
            outputRegisters: Registers()
        )

        XCTAssertEqual( try result.bus.read( at: 0x1020 ), 0x42 )
    }

    func testAbsoluteY() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "STA",
            addressingMode:  .absoluteY,
            operand:         0x1000,
            inputRegisters:  Registers( A: 0x42, Y: 0x20 ),
            outputRegisters: Registers()
        )

        XCTAssertEqual( try result.bus.read( at: 0x1020 ), 0x42 )
    }

    func testIndirectX() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "STA",
            addressingMode:  .indirectX,
            operand:         0x10,
            inputRegisters:  Registers( A: 0x42, X: 0x20 ),
            outputRegisters: Registers()
        )
        {
            cpu, bus, ram in try bus.writeUInt16( 0x1000, at: 0x30 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x1000 ), 0x42 )
    }

    func testIndirectX_Wrap() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "STA",
            addressingMode:  .indirectX,
            operand:         0xEF,
            inputRegisters:  Registers( A: 0x42, X: 0x20 ),
            outputRegisters: Registers()
        )
        {
            cpu, bus, ram in try bus.writeUInt16( 0x1000, at: 0x0F )
        }

        XCTAssertEqual( try result.bus.read( at: 0x1000 ), 0x42 )
    }

    func testIndirectY() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "STA",
            addressingMode:  .indirectY,
            operand:         0x10,
            inputRegisters:  Registers( A: 0x42, Y: 0x20 ),
            outputRegisters: Registers()
        )
        {
            cpu, bus, ram in try bus.writeUInt16( 0x1000, at: 0x10 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x1020 ), 0x42 )
    }

    func testZeroPage() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "STA",
            addressingMode:  .zeroPage,
            operands:        [ 0x10 ],
            inputRegisters:  Registers( A: 0x42 ),
            outputRegisters: Registers()
        )

        XCTAssertEqual( try result.bus.read( at: 0x10 ), 0x42 )
    }

    func testZeroPageX() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "STA",
            addressingMode:  .zeroPageX,
            operands:        [ 0x10 ],
            inputRegisters:  Registers( A: 0x42, X: 0x10 ),
            outputRegisters: Registers()
        )

        XCTAssertEqual( try result.bus.read( at: 0x20 ), 0x42 )
    }

    func testZeroPageX_Wrap() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "STA",
            addressingMode:  .zeroPageX,
            operands:        [ 0xEF ],
            inputRegisters:  Registers( A: 0x42, X: 0x20 ),
            outputRegisters: Registers()
        )

        XCTAssertEqual( try result.bus.read( at: 0x0F ), 0x42 )
    }
}
