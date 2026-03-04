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

class Test_Instruction_ADC_Binary: Test_Instruction
{
    func testBinaryAbsolute() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x1000 )
        }
    }

    func testBinaryAbsolute_WithCarry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x31, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x1000 )
        }
    }

    func testBinaryAbsolute_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x0F, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testBinaryAbsolute_WithCarry_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x10, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testBinaryAbsolute_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x00, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 0, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x1000 )
        }
    }

    func testBinaryAbsolute_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x80, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x90, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testBinaryAbsolute_WithCarry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x80, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x91, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testBinaryAbsolute_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x1000 )
        }
    }

    func testBinaryAbsolute_WithCarry_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x1000 )
        }
    }

    func testBinaryAbsolute_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x1000 )
        }
    }

    func testBinaryAbsolute_WithCarry_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x1000 )
        }
    }

    func testBinaryAbsolute_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x7F, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x1000 )
        }
    }

    func testBinaryAbsolute_WithCarry_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x7F, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x1000 )
        }
    }

    func testBinaryAbsolute_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x90, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x20, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x1000 )
        }
    }

    func testBinaryAbsolute_WithCarry_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x90, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x21, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x1000 )
        }
    }

    func testBinaryAbsoluteX() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x10, X: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x1010 )
        }
    }

    func testBinaryAbsoluteX_PageCross() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x10FF,
            inputRegisters:  Registers( A: 0x10, X: 0x01, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     1
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x1100 )
        }
    }

    func testBinaryAbsoluteX_WithCarry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x10, X: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x31, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x1010 )
        }
    }

    func testBinaryAbsoluteX_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x0F, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testBinaryAbsoluteX_WithCarry_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x10, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testBinaryAbsoluteX_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x00, X: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 0, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x1010 )
        }
    }

    func testBinaryAbsoluteX_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x80, X: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x90, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testBinaryAbsoluteX_WithCarry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x80, X: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x91, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testBinaryAbsoluteX_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x1010 )
        }
    }

    func testBinaryAbsoluteX_WithCarry_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x1010 )
        }
    }

    func testBinaryAbsoluteX_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x1010 )
        }
    }

    func testBinaryAbsoluteX_WithCarry_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x1010 )
        }
    }

    func testBinaryAbsoluteX_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x7F, X: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x1010 )
        }
    }

    func testBinaryAbsoluteX_WithCarry_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x7F, X: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x1010 )
        }
    }

    func testBinaryAbsoluteX_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x90, X: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x20, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x1010 )
        }
    }

    func testBinaryAbsoluteX_WithCarry_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x90, X: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x21, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x1010 )
        }
    }

    func testBinaryAbsoluteY() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x10, Y: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x1010 )
        }
    }

    func testBinaryAbsoluteY_PageCross() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x10FF,
            inputRegisters:  Registers( A: 0x10, Y: 0x01, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     1
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x1100 )
        }
    }

    func testBinaryAbsoluteY_WithCarry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x10, Y: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x31, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x1010 )
        }
    }

    func testBinaryAbsoluteY_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x0F, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testBinaryAbsoluteY_WithCarry_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x10, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testBinaryAbsoluteY_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x00, Y: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 0, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x1010 )
        }
    }

    func testBinaryAbsoluteY_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x80, Y: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x90, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testBinaryAbsoluteY_WithCarry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x80, Y: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x91, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testBinaryAbsoluteY_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x1010 )
        }
    }

    func testBinaryAbsoluteY_WithCarry_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x1010 )
        }
    }

    func testBinaryAbsoluteY_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x1010 )
        }
    }

    func testBinaryAbsoluteY_WithCarry_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x1010 )
        }
    }

    func testBinaryAbsoluteY_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x7F, Y: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x1010 )
        }
    }

    func testBinaryAbsoluteY_WithCarry_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x7F, Y: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x1010 )
        }
    }

    func testBinaryAbsoluteY_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x90, Y: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x20, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x1010 )
        }
    }

    func testBinaryAbsoluteY_WithCarry_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x90, Y: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x21, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x1010 )
        }
    }

    func testBinaryImmediate() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x20,
            inputRegisters:  Registers( A: 0x10, Y: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
    }

    func testBinaryImmediate_WithCarry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x20,
            inputRegisters:  Registers( A: 0x10, Y: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x31, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
    }

    func testBinaryImmediate_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x0F, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
    }

    func testBinaryImmediate_WithCarry_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x10, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
    }

    func testBinaryImmediate_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x00,
            inputRegisters:  Registers( A: 0x00, Y: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 0, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
    }

    func testBinaryImmediate_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x80, Y: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x90, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
    }

    func testBinaryImmediate_WithCarry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x80, Y: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x91, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
    }

    func testBinaryImmediate_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x01,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
    }

    func testBinaryImmediate_WithCarry_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x00,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
    }

    func testBinaryImmediate_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x81,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
    }

    func testBinaryImmediate_WithCarry_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x81,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
    }

    func testBinaryImmediate_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x01,
            inputRegisters:  Registers( A: 0x7F, Y: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
    }

    func testBinaryImmediate_WithCarry_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x01,
            inputRegisters:  Registers( A: 0x7F, Y: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
    }

    func testBinaryImmediate_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x90,
            inputRegisters:  Registers( A: 0x90, Y: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x20, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
    }

    func testBinaryImmediate_WithCarry_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x90,
            inputRegisters:  Registers( A: 0x90, Y: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x21, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
    }

    func testBinaryIndirectX() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x10, X: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x20, at: 0x1000 )
        }
    }

    func testBinaryIndirectX_WithCarry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x10, X: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x31, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x20, at: 0x1000 )
        }
    }

    func testBinaryIndirectX_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x0F, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testBinaryIndirectX_WithCarry_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x10, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testBinaryIndirectX_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x00, X: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 0, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x00, at: 0x1000 )
        }
    }

    func testBinaryIndirectX_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x80, X: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x90, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testBinaryIndirectX_WithCarry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x80, X: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x91, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testBinaryIndirectX_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x01, at: 0x1000 )
        }
    }

    func testBinaryIndirectX_WithCarry_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x00, at: 0x1000 )
        }
    }

    func testBinaryIndirectX_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x81, at: 0x1000 )
        }
    }

    func testBinaryIndirectX_WithCarry_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x81, at: 0x1000 )
        }
    }

    func testBinaryIndirectX_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x7F, X: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x01, at: 0x1000 )
        }
    }

    func testBinaryIndirectX_WithCarry_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x7F, X: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x01, at: 0x1000 )
        }
    }

    func testBinaryIndirectX_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x90, X: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x20, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x90, at: 0x1000 )
        }
    }

    func testBinaryIndirectX_WithCarry_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x90, X: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x21, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x90, at: 0x1000 )
        }
    }

    func testBinaryIndirectX_Wrap() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x10, X: 0x20, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x20, at: 0x1000 )
        }
    }

    func testBinaryIndirectX_Wrap_WithCarry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x10, X: 0x20, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x31, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x20, at: 0x1000 )
        }
    }

    func testBinaryIndirectX_Wrap_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x0F, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testBinaryIndirectX_Wrap_WithCarry_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x10, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testBinaryIndirectX_Wrap_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x00, X: 0x20, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 0, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x00, at: 0x1000 )
        }
    }

    func testBinaryIndirectX_Wrap_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x80, X: 0x20, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x90, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testBinaryIndirectX_Wrap_WithCarry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x80, X: 0x20, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x91, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testBinaryIndirectX_Wrap_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x01, at: 0x1000 )
        }
    }

    func testBinaryIndirectX_Wrap_WithCarry_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x00, at: 0x1000 )
        }
    }

    func testBinaryIndirectX_Wrap_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x81, at: 0x1000 )
        }
    }

    func testBinaryIndirectX_Wrap_WithCarry_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x81, at: 0x1000 )
        }
    }

    func testBinaryIndirectX_Wrap_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x7F, X: 0x20, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x01, at: 0x1000 )
        }
    }

    func testBinaryIndirectX_Wrap_WithCarry_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x7F, X: 0x20, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x01, at: 0x1000 )
        }
    }

    func testBinaryIndirectX_Wrap_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x90, X: 0x20, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x20, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x90, at: 0x1000 )
        }
    }

    func testBinaryIndirectX_Wrap_WithCarry_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x90, X: 0x20, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x21, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x90, at: 0x1000 )
        }
    }

    func testBinaryIndirectY() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x10, Y: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x20, at: 0x1010 )
        }
    }

    func testBinaryIndirectY_PageCross() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x10, Y: 0x01, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     1
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x10FF, at: 0x10 )
            try bus.write( 0x20, at: 0x1100 )
        }
    }

    func testBinaryIndirectY_WithCarry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x10, Y: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x31, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x20, at: 0x1010 )
        }
    }

    func testBinaryIndirectY_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x0F, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testBinaryIndirectY_WithCarry_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x10, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testBinaryIndirectY_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x00, Y: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 0, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x00, at: 0x1010 )
        }
    }

    func testBinaryIndirectY_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x80, Y: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x90, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testBinaryIndirectY_WithCarry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x80, Y: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x91, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testBinaryIndirectY_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x01, at: 0x1010 )
        }
    }

    func testBinaryIndirectY_WithCarry_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x00, at: 0x1010 )
        }
    }

    func testBinaryIndirectY_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x81, at: 0x1010 )
        }
    }

    func testBinaryIndirectY_WithCarry_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x81, at: 0x1010 )
        }
    }

    func testBinaryIndirectY_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x7F, Y: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x01, at: 0x1010 )
        }
    }

    func testBinaryIndirectY_WithCarry_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x7F, Y: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x01, at: 0x1010 )
        }
    }

    func testBinaryIndirectY_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x90, Y: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x20, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x90, at: 0x1010 )
        }
    }

    func testBinaryIndirectY_WithCarry_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x90, Y: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x21, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x90, at: 0x1010 )
        }
    }

    func testBinaryZeroPage() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x10 )
        }
    }

    func testBinaryZeroPage_WithCarry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x31, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x10 )
        }
    }

    func testBinaryZeroPage_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x0F, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x10 )
        }
    }

    func testBinaryZeroPage_WithCarry_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x10, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x10 )
        }
    }

    func testBinaryZeroPage_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x00, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 0, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x10 )
        }
    }

    func testBinaryZeroPage_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x80, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x90, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x10 )
        }
    }

    func testBinaryZeroPage_WithCarry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x80, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x91, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x10 )
        }
    }

    func testBinaryZeroPage_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x10 )
        }
    }

    func testBinaryZeroPage_WithCarry_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x10 )
        }
    }

    func testBinaryZeroPage_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x10 )
        }
    }

    func testBinaryZeroPage_WithCarry_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x10 )
        }
    }

    func testBinaryZeroPage_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x7F, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x10 )
        }
    }

    func testBinaryZeroPage_WithCarry_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x7F, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x10 )
        }
    }

    func testBinaryZeroPage_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x90, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x20, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x10 )
        }
    }

    func testBinaryZeroPage_WithCarry_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x90, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x21, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x10 )
        }
    }

    func testBinaryZeroPageX() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x10, X: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x20 )
        }
    }

    func testBinaryZeroPageX_WithCarry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x10, X: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x31, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x20 )
        }
    }

    func testBinaryZeroPageX_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x0F, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x20 )
        }
    }

    func testBinaryZeroPageX_WithCarry_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x10, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x20 )
        }
    }

    func testBinaryZeroPageX_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x00, X: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 0, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x20 )
        }
    }

    func testBinaryZeroPageX_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x80, X: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x90, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x20 )
        }
    }

    func testBinaryZeroPageX_WithCarry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x80, X: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x91, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x20 )
        }
    }

    func testBinaryZeroPageX_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x20 )
        }
    }

    func testBinaryZeroPageX_WithCarry_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x20 )
        }
    }

    func testBinaryZeroPageX_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x20 )
        }
    }

    func testBinaryZeroPageX_WithCarry_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x20 )
        }
    }

    func testBinaryZeroPageX_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x7F, X: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x20 )
        }
    }

    func testBinaryZeroPageX_WithCarry_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x7F, X: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x20 )
        }
    }

    func testBinaryZeroPageX_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x90, X: 0x10, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x20, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x20 )
        }
    }

    func testBinaryZeroPageX_WithCarry_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x90, X: 0x10, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x21, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x20 )
        }
    }

    func testBinaryZeroPageX_Wrap() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x10, X: 0x20, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x0F )
        }
    }

    func testBinaryZeroPageX_Wrap_WithCarry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x10, X: 0x20, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x31, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x0F )
        }
    }

    func testBinaryZeroPageX_Wrap_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x0F, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x0F )
        }
    }

    func testBinaryZeroPageX_Wrap_WithCarry_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x10, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x0F )
        }
    }

    func testBinaryZeroPageX_Wrap_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x00, X: 0x20, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 0, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x0F )
        }
    }

    func testBinaryZeroPageX_Wrap_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x80, X: 0x20, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x90, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x0F )
        }
    }

    func testBinaryZeroPageX_Wrap_WithCarry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x80, X: 0x20, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x91, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x0F )
        }
    }

    func testBinaryZeroPageX_Wrap_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x0F )
        }
    }

    func testBinaryZeroPageX_Wrap_WithCarry_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x0F )
        }
    }

    func testBinaryZeroPageX_Wrap_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x0F )
        }
    }

    func testBinaryZeroPageX_Wrap_WithCarry_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x0F )
        }
    }

    func testBinaryZeroPageX_Wrap_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x7F, X: 0x20, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x0F )
        }
    }

    func testBinaryZeroPageX_Wrap_WithCarry_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x7F, X: 0x20, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x0F )
        }
    }

    func testBinaryZeroPageX_Wrap_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x90, X: 0x20, P: Flags( C: 0, D: 0 ) ),
            outputRegisters: Registers( A: 0x20, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x0F )
        }
    }

    func testBinaryZeroPageX_Wrap_WithCarry_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x90, X: 0x20, P: Flags( C: 1, D: 0 ) ),
            outputRegisters: Registers( A: 0x21, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x0F )
        }
    }
}
