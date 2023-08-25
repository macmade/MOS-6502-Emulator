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

class Test_Instruction_ROL: Test_Instruction
{
    func testAbsolute() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( PS: Flags( C: 0 ) ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x33, at: 0x1000 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x1000 ), 0x66 )
    }

    func testAbsolute_WithCarry() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( PS: Flags( C: 1 ) ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x33, at: 0x1000 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x1000 ), 0x67 )
    }

    func testAbsolute_Carry() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( PS: Flags( C: 0 ) ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0xAA, at: 0x1000 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x1000 ), 0x54 )
    }

    func testAbsolute_WithCarry_Carry() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( PS: Flags( C: 1 ) ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0xAA, at: 0x1000 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x1000 ), 0x55 )
    }

    func testAbsolute_Zero() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( PS: Flags( C: 0 ) ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x1000 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x1000 ), 0x00 )
    }

    func testAbsolute_Negative() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( PS: Flags( C: 0 ) ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x55, at: 0x1000 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x1000 ), 0xAA )
    }

    func testAbsolute_WithCarry_Negative() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( PS: Flags( C: 1 ) ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x55, at: 0x1000 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x1000 ), 0xAB )
    }

    func testAbsolute_Carry_Zero() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( PS: Flags( C: 0 ) ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x80, at: 0x1000 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x1000 ), 0x00 )
    }

    func testAbsolute_Carry_Negative() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( PS: Flags( C: 0 ) ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0xC0, at: 0x1000 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x1000 ), 0x80 )
    }

    func testAbsolute_WithCarry_Carry_Negative() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( PS: Flags( C: 1 ) ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0xC0, at: 0x1000 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x1000 ), 0x81 )
    }

    func testAbsoluteX() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( X: 0x10, PS: Flags( C: 0 ) ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x33, at: 0x1010 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x1010 ), 0x66 )
    }

    func testAbsoluteX_WithCarry() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( X: 0x10, PS: Flags( C: 1 ) ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x33, at: 0x1010 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x1010 ), 0x67 )
    }

    func testAbsoluteX_Carry() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( X: 0x10, PS: Flags( C: 0 ) ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0xAA, at: 0x1010 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x1010 ), 0x54 )
    }

    func testAbsoluteX_WithCarry_Carry() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( X: 0x10, PS: Flags( C: 1 ) ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0xAA, at: 0x1010 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x1010 ), 0x55 )
    }

    func testAbsoluteX_Zero() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( X: 0x10, PS: Flags( C: 0 ) ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x1010 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x1010 ), 0x00 )
    }

    func testAbsoluteX_Negative() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( X: 0x10, PS: Flags( C: 0 ) ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x55, at: 0x1010 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x1010 ), 0xAA )
    }

    func testAbsoluteX_WithCarry_Negative() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( X: 0x10, PS: Flags( C: 1 ) ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x55, at: 0x1010 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x1010 ), 0xAB )
    }

    func testAbsoluteX_Carry_Zero() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( X: 0x10, PS: Flags( C: 0 ) ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x80, at: 0x1010 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x1010 ), 0x00 )
    }

    func testAbsoluteX_Carry_Negative() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( X: 0x10, PS: Flags( C: 0 ) ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0xC0, at: 0x1010 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x1010 ), 0x80 )
    }

    func testAbsoluteX_WithCarry_Carry_Negative() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( X: 0x10, PS: Flags( C: 1 ) ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0xC0, at: 0x1010 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x1010 ), 0x81 )
    }

    func testAccumulator() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .accumulator,
            operands:        [],
            inputRegisters:  Registers( A: 0x33, PS: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x66, PS: Flags( C: 0, Z: 0, N: 0 ) )
        )
    }

    func testAccumulator_WithCarry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .accumulator,
            operands:        [],
            inputRegisters:  Registers( A: 0x33, PS: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x67, PS: Flags( C: 0, Z: 0, N: 0 ) )
        )
    }

    func testAccumulator_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .accumulator,
            operands:        [],
            inputRegisters:  Registers( A: 0xAA, PS: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x54, PS: Flags( C: 1, Z: 0, N: 0 ) )
        )
    }

    func testAccumulator_WithCarry_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .accumulator,
            operands:        [],
            inputRegisters:  Registers( A: 0xAA, PS: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x55, PS: Flags( C: 1, Z: 0, N: 0 ) )
        )
    }

    func testAccumulator_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .accumulator,
            operands:        [],
            inputRegisters:  Registers( A: 0x00, PS: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x00, PS: Flags( C: 0, Z: 1, N: 0 ) )
        )
    }

    func testAccumulator_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .accumulator,
            operands:        [],
            inputRegisters:  Registers( A: 0x55, PS: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0xAA, PS: Flags( C: 0, Z: 0, N: 1 ) )
        )
    }

    func testAccumulator_WithCarry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .accumulator,
            operands:        [],
            inputRegisters:  Registers( A: 0x55, PS: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0xAB, PS: Flags( C: 0, Z: 0, N: 1 ) )
        )
    }

    func testAccumulator_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .accumulator,
            operands:        [],
            inputRegisters:  Registers( A: 0x80, PS: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x00, PS: Flags( C: 1, Z: 1, N: 0 ) )
        )
    }

    func testAccumulator_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .accumulator,
            operands:        [],
            inputRegisters:  Registers( A: 0xC0, PS: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x80, PS: Flags( C: 1, Z: 0, N: 1 ) )
        )
    }

    func testAccumulator_WithCarry_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .accumulator,
            operands:        [],
            inputRegisters:  Registers( A: 0xC0, PS: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x81, PS: Flags( C: 1, Z: 0, N: 1 ) )
        )
    }

    func testZeroPage() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( PS: Flags( C: 0 ) ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x33, at: 0x10 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x10 ), 0x66 )
    }

    func testZeroPage_WithCarry() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( PS: Flags( C: 1 ) ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x33, at: 0x10 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x10 ), 0x67 )
    }

    func testZeroPage_Carry() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( PS: Flags( C: 0 ) ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0xAA, at: 0x10 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x10 ), 0x54 )
    }

    func testZeroPage_WithCarry_Carry() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( PS: Flags( C: 1 ) ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0xAA, at: 0x10 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x10 ), 0x55 )
    }

    func testZeroPage_Zero() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( PS: Flags( C: 0 ) ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x10 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x10 ), 0x00 )
    }

    func testZeroPage_Negative() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( PS: Flags( C: 0 ) ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x55, at: 0x10 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x10 ), 0xAA )
    }

    func testZeroPage_WithCarry_Negative() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( PS: Flags( C: 1 ) ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x55, at: 0x10 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x10 ), 0xAB )
    }

    func testZeroPage_Carry_Zero() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( PS: Flags( C: 0 ) ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x80, at: 0x10 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x10 ), 0x00 )
    }

    func testZeroPage_Carry_Negative() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( PS: Flags( C: 0 ) ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0xC0, at: 0x10 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x10 ), 0x80 )
    }

    func testZeroPage_WithCarry_Carry_Negative() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( PS: Flags( C: 1 ) ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0xC0, at: 0x10 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x10 ), 0x81 )
    }

    func testZeroPageX() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( X: 0x10, PS: Flags( C: 0 ) ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x33, at: 0x20 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x20 ), 0x66 )
    }

    func testZeroPageX_WithCarry() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( X: 0x10, PS: Flags( C: 1 ) ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x33, at: 0x20 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x20 ), 0x67 )
    }

    func testZeroPageX_Carry() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( X: 0x10, PS: Flags( C: 0 ) ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0xAA, at: 0x20 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x20 ), 0x54 )
    }

    func testZeroPageX_WithCarry_Carry() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( X: 0x10, PS: Flags( C: 1 ) ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0xAA, at: 0x20 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x20 ), 0x55 )
    }

    func testZeroPageX_Zero() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( X: 0x10, PS: Flags( C: 0 ) ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x20 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x20 ), 0x00 )
    }

    func testZeroPageX_Negative() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( X: 0x10, PS: Flags( C: 0 ) ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x55, at: 0x20 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x20 ), 0xAA )
    }

    func testZeroPageX_WithCarry_Negative() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( X: 0x10, PS: Flags( C: 1 ) ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x55, at: 0x20 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x20 ), 0xAB )
    }

    func testZeroPageX_Carry_Zero() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( X: 0x10, PS: Flags( C: 0 ) ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x80, at: 0x20 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x20 ), 0x00 )
    }

    func testZeroPageX_Carry_Negative() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( X: 0x10, PS: Flags( C: 0 ) ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0xC0, at: 0x20 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x20 ), 0x80 )
    }

    func testZeroPageX_WithCarry_Carry_Negative() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( X: 0x10, PS: Flags( C: 1 ) ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0xC0, at: 0x20 )
        }

        XCTAssertEqual( try result.bus.read( at: 0x20 ), 0x81 )
    }

    func testZeroPageX_Wrap() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( X: 0x20, PS: Flags( C: 0 ) ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x33, at: 0x0F )
        }

        XCTAssertEqual( try result.bus.read( at: 0x0F ), 0x66 )
    }

    func testZeroPageX_Wrap_WithCarry() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( X: 0x20, PS: Flags( C: 1 ) ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x33, at: 0x0F )
        }

        XCTAssertEqual( try result.bus.read( at: 0x0F ), 0x67 )
    }

    func testZeroPageX_Wrap_Carry() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( X: 0x20, PS: Flags( C: 0 ) ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0xAA, at: 0x0F )
        }

        XCTAssertEqual( try result.bus.read( at: 0x0F ), 0x54 )
    }

    func testZeroPageX_Wrap_WithCarry_Carry() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( X: 0x20, PS: Flags( C: 1 ) ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0xAA, at: 0x0F )
        }

        XCTAssertEqual( try result.bus.read( at: 0x0F ), 0x55 )
    }

    func testZeroPageX_Wrap_Zero() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( X: 0x20, PS: Flags( C: 0 ) ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x0F )
        }

        XCTAssertEqual( try result.bus.read( at: 0x0F ), 0x00 )
    }

    func testZeroPageX_Wrap_Negative() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( X: 0x20, PS: Flags( C: 0 ) ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x55, at: 0x0F )
        }

        XCTAssertEqual( try result.bus.read( at: 0x0F ), 0xAA )
    }

    func testZeroPageX_Wrap_WithCarry_Negative() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( X: 0x20, PS: Flags( C: 1 ) ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x55, at: 0x0F )
        }

        XCTAssertEqual( try result.bus.read( at: 0x0F ), 0xAB )
    }

    func testZeroPageX_Wrap_Carry_Zero() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( X: 0x20, PS: Flags( C: 0 ) ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x80, at: 0x0F )
        }

        XCTAssertEqual( try result.bus.read( at: 0x0F ), 0x00 )
    }

    func testZeroPageX_Wrap_Carry_Negative() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( X: 0x20, PS: Flags( C: 0 ) ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0xC0, at: 0x0F )
        }

        XCTAssertEqual( try result.bus.read( at: 0x0F ), 0x80 )
    }

    func testZeroPageX_Wrap_WithCarry_Carry_Negative() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "ROL",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( X: 0x20, PS: Flags( C: 1 ) ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0xC0, at: 0x0F )
        }

        XCTAssertEqual( try result.bus.read( at: 0x0F ), 0x81 )
    }
}
