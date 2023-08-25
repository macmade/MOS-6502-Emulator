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

class Test_Instruction_LSR: Test_Instruction
{
    func testAbsolute() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "LSR",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers(),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0xAA, at: 0x1000 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x1000 ), 0x55 )
    }

    func testAbsolute_Carry() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "LSR",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers(),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x55, at: 0x1000 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x1000 ), 0x2A )
    }

    func testAbsolute_Zero() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "LSR",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers(),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x1000 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x1000 ), 0x00 )
    }

    func testAbsolute_Carry_Zero() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "LSR",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers(),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x1000 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x1000 ), 0x00 )
    }

    func testAbsoluteX() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "LSR",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( X: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0xAA, at: 0x1010 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x1010 ), 0x55 )
    }

    func testAbsoluteX_Carry() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "LSR",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( X: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x55, at: 0x1010 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x1010 ), 0x2A )
    }

    func testAbsoluteX_Zero() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "LSR",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( X: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x1010 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x1010 ), 0x00 )
    }

    func testAbsoluteX_Carry_Zero() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "LSR",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( X: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x1010 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x1010 ), 0x00 )
    }

    func testAccumulator() throws
    {
        try self.executeSingleInstruction(
            instruction:     "LSR",
            addressingMode:  .accumulator,
            operands:        [],
            inputRegisters:  Registers( A: 0xAA ),
            outputRegisters: Registers( A: 0x55, PS: Flags( C: 0, Z: 0, N: 0 ) )
        )
    }

    func testAccumulator_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "LSR",
            addressingMode:  .accumulator,
            operands:        [],
            inputRegisters:  Registers( A: 0x55 ),
            outputRegisters: Registers( A: 0x2A, PS: Flags( C: 1, Z: 0, N: 0 ) )
        )
    }

    func testAccumulator_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "LSR",
            addressingMode:  .accumulator,
            operands:        [],
            inputRegisters:  Registers( A: 0x00 ),
            outputRegisters: Registers( A: 0x00, PS: Flags( C: 0, Z: 1, N: 0 ) )
        )
    }

    func testAccumulator_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "LSR",
            addressingMode:  .accumulator,
            operands:        [],
            inputRegisters:  Registers( A: 0x01 ),
            outputRegisters: Registers( A: 0x00, PS: Flags( C: 1, Z: 1, N: 0 ) )
        )
    }

    func testZeroPage() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "LSR",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers(),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0xAA, at: 0x10 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x10 ), 0x55 )
    }

    func testZeroPage_Carry() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "LSR",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers(),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x55, at: 0x10 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x10 ), 0x2A )
    }

    func testZeroPage_Zero() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "LSR",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers(),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x10 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x10 ), 0x00 )
    }

    func testZeroPage_Carry_Zero() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "LSR",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers(),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x10 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x10 ), 0x00 )
    }

    func testZeroPageX() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "LSR",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( X: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0xAA, at: 0x20 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x20 ), 0x55 )
    }

    func testZeroPageX_Carry() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "LSR",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( X: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x55, at: 0x20 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x20 ), 0x2A )
    }

    func testZeroPageX_Zero() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "LSR",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( X: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x20 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x20 ), 0x00 )
    }

    func testZeroPageX_Carry_Zero() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "LSR",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( X: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x20 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x20 ), 0x00 )
    }

    func testZeroPageX_Wrap() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "LSR",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( X: 0x20 ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0xAA, at: 0x0F )
        }

        XCTAssertEqual( try result.bus.read( at: 0x0F ), 0x55 )
    }

    func testZeroPageX_Wrap_Carry() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "LSR",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( X: 0x20 ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x55, at: 0x0F )
        }

        XCTAssertEqual( try result.bus.read( at: 0x0F ), 0x2A )
    }

    func testZeroPageX_Wrap_Zero() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "LSR",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( X: 0x20 ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x0F )
        }

        XCTAssertEqual( try result.bus.read( at: 0x0F ), 0x00 )
    }

    func testZeroPageX_Wrap_Carry_Zero() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "LSR",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( X: 0x20 ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x0F )
        }

        XCTAssertEqual( try result.bus.read( at: 0x0F ), 0x00 )
    }
}
