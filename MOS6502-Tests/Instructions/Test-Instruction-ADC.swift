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

class Test_Instruction_ADC: Test_Instruction
{
    func testAbsolute() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x1000 )
        }
    }

    func testAbsolute_WithCarry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x31, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x1000 )
        }
    }

    func testAbsolute_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x0F, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testAbsolute_WithCarry_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x10, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testAbsolute_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x00, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 0, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x1000 )
        }
    }

    func testAbsolute_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x80, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x90, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testAbsolute_WithCarry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x80, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x91, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testAbsolute_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x1000 )
        }
    }

    func testAbsolute_WithCarry_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x1000 )
        }
    }

    func testAbsolute_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x1000 )
        }
    }

    func testAbsolute_WithCarry_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x1000 )
        }
    }

    func testAbsolute_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x7F, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x1000 )
        }
    }

    func testAbsolute_WithCarry_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x7F, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x1000 )
        }
    }

    func testAbsolute_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x90, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x20, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x1000 )
        }
    }

    func testAbsolute_WithCarry_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x90, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x21, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x1000 )
        }
    }

    func testAbsoluteX() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x10, X: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x1010 )
        }
    }

    func testAbsoluteX_PageCross() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x10FF,
            inputRegisters:  Registers( A: 0x10, X: 0x01, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     1
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x1100 )
        }
    }

    func testAbsoluteX_WithCarry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x10, X: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x31, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x1010 )
        }
    }

    func testAbsoluteX_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x0F, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testAbsoluteX_WithCarry_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x10, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testAbsoluteX_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x00, X: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 0, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x1010 )
        }
    }

    func testAbsoluteX_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x80, X: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x90, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testAbsoluteX_WithCarry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x80, X: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x91, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testAbsoluteX_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x1010 )
        }
    }

    func testAbsoluteX_WithCarry_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x1010 )
        }
    }

    func testAbsoluteX_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x1010 )
        }
    }

    func testAbsoluteX_WithCarry_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x1010 )
        }
    }

    func testAbsoluteX_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x7F, X: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x1010 )
        }
    }

    func testAbsoluteX_WithCarry_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x7F, X: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x1010 )
        }
    }

    func testAbsoluteX_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x90, X: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x20, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x1010 )
        }
    }

    func testAbsoluteX_WithCarry_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x90, X: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x21, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x1010 )
        }
    }

    func testAbsoluteY() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x10, Y: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x1010 )
        }
    }

    func testAbsoluteY_PageCross() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x10FF,
            inputRegisters:  Registers( A: 0x10, Y: 0x01, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     1
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x1100 )
        }
    }

    func testAbsoluteY_WithCarry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x10, Y: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x31, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x1010 )
        }
    }

    func testAbsoluteY_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x0F, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testAbsoluteY_WithCarry_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x10, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testAbsoluteY_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x00, Y: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 0, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x1010 )
        }
    }

    func testAbsoluteY_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x80, Y: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x90, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testAbsoluteY_WithCarry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x80, Y: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x91, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testAbsoluteY_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x1010 )
        }
    }

    func testAbsoluteY_WithCarry_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x1010 )
        }
    }

    func testAbsoluteY_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x1010 )
        }
    }

    func testAbsoluteY_WithCarry_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x1010 )
        }
    }

    func testAbsoluteY_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x7F, Y: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x1010 )
        }
    }

    func testAbsoluteY_WithCarry_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x7F, Y: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x1010 )
        }
    }

    func testAbsoluteY_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x90, Y: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x20, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x1010 )
        }
    }

    func testAbsoluteY_WithCarry_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x90, Y: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x21, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x1010 )
        }
    }

    func testImmediate() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x20,
            inputRegisters:  Registers( A: 0x10, Y: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
    }

    func testImmediate_WithCarry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x20,
            inputRegisters:  Registers( A: 0x10, Y: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x31, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
    }

    func testImmediate_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x0F, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
    }

    func testImmediate_WithCarry_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x10, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
    }

    func testImmediate_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x00,
            inputRegisters:  Registers( A: 0x00, Y: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 0, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
    }

    func testImmediate_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x80, Y: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x90, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
    }

    func testImmediate_WithCarry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x80, Y: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x91, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
    }

    func testImmediate_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x01,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
    }

    func testImmediate_WithCarry_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x00,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
    }

    func testImmediate_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x81,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
    }

    func testImmediate_WithCarry_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x81,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
    }

    func testImmediate_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x01,
            inputRegisters:  Registers( A: 0x7F, Y: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
    }

    func testImmediate_WithCarry_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x01,
            inputRegisters:  Registers( A: 0x7F, Y: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
    }

    func testImmediate_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x90,
            inputRegisters:  Registers( A: 0x90, Y: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x20, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
    }

    func testImmediate_WithCarry_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x90,
            inputRegisters:  Registers( A: 0x90, Y: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x21, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
    }

    func testIndirectX() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x10, X: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x20, at: 0x1000 )
        }
    }

    func testIndirectX_WithCarry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x10, X: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x31, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x20, at: 0x1000 )
        }
    }

    func testIndirectX_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x0F, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testIndirectX_WithCarry_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x10, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testIndirectX_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x00, X: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 0, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x00, at: 0x1000 )
        }
    }

    func testIndirectX_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x80, X: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x90, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testIndirectX_WithCarry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x80, X: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x91, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testIndirectX_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x01, at: 0x1000 )
        }
    }

    func testIndirectX_WithCarry_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x00, at: 0x1000 )
        }
    }

    func testIndirectX_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x81, at: 0x1000 )
        }
    }

    func testIndirectX_WithCarry_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x81, at: 0x1000 )
        }
    }

    func testIndirectX_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x7F, X: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x01, at: 0x1000 )
        }
    }

    func testIndirectX_WithCarry_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x7F, X: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x01, at: 0x1000 )
        }
    }

    func testIndirectX_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x90, X: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x20, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x90, at: 0x1000 )
        }
    }

    func testIndirectX_WithCarry_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x90, X: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x21, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x90, at: 0x1000 )
        }
    }

    func testIndirectX_Wrap() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x10, X: 0x20, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x20, at: 0x1000 )
        }
    }

    func testIndirectX_Wrap_WithCarry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x10, X: 0x20, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x31, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x20, at: 0x1000 )
        }
    }

    func testIndirectX_Wrap_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x0F, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testIndirectX_Wrap_WithCarry_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x10, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testIndirectX_Wrap_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x00, X: 0x20, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 0, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x00, at: 0x1000 )
        }
    }

    func testIndirectX_Wrap_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x80, X: 0x20, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x90, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testIndirectX_Wrap_WithCarry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x80, X: 0x20, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x91, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testIndirectX_Wrap_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x01, at: 0x1000 )
        }
    }

    func testIndirectX_Wrap_WithCarry_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x00, at: 0x1000 )
        }
    }

    func testIndirectX_Wrap_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x81, at: 0x1000 )
        }
    }

    func testIndirectX_Wrap_WithCarry_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x81, at: 0x1000 )
        }
    }

    func testIndirectX_Wrap_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x7F, X: 0x20, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x01, at: 0x1000 )
        }
    }

    func testIndirectX_Wrap_WithCarry_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x7F, X: 0x20, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x01, at: 0x1000 )
        }
    }

    func testIndirectX_Wrap_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x90, X: 0x20, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x20, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x90, at: 0x1000 )
        }
    }

    func testIndirectX_Wrap_WithCarry_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x90, X: 0x20, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x21, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x90, at: 0x1000 )
        }
    }

    func testIndirectY() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x10, Y: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x20, at: 0x1010 )
        }
    }

    func testIndirectY_PageCross() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x10, Y: 0x01, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     1
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x10FF, at: 0x10 )
            try bus.write( 0x20, at: 0x1100 )
        }
    }

    func testIndirectY_WithCarry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x10, Y: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x31, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x20, at: 0x1010 )
        }
    }

    func testIndirectY_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x0F, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testIndirectY_WithCarry_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x10, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testIndirectY_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x00, Y: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 0, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x00, at: 0x1010 )
        }
    }

    func testIndirectY_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x80, Y: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x90, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testIndirectY_WithCarry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x80, Y: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x91, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testIndirectY_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x01, at: 0x1010 )
        }
    }

    func testIndirectY_WithCarry_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x00, at: 0x1010 )
        }
    }

    func testIndirectY_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x81, at: 0x1010 )
        }
    }

    func testIndirectY_WithCarry_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x81, at: 0x1010 )
        }
    }

    func testIndirectY_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x7F, Y: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x01, at: 0x1010 )
        }
    }

    func testIndirectY_WithCarry_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x7F, Y: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x01, at: 0x1010 )
        }
    }

    func testIndirectY_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x90, Y: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x20, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x90, at: 0x1010 )
        }
    }

    func testIndirectY_WithCarry_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x90, Y: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x21, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x90, at: 0x1010 )
        }
    }

    func testZeroPage() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x10 )
        }
    }

    func testZeroPage_WithCarry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x31, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x10 )
        }
    }

    func testZeroPage_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x0F, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x10 )
        }
    }

    func testZeroPage_WithCarry_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x10, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x10 )
        }
    }

    func testZeroPage_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x00, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 0, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x10 )
        }
    }

    func testZeroPage_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x80, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x90, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x10 )
        }
    }

    func testZeroPage_WithCarry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x80, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x91, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x10 )
        }
    }

    func testZeroPage_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x10 )
        }
    }

    func testZeroPage_WithCarry_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x10 )
        }
    }

    func testZeroPage_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x10 )
        }
    }

    func testZeroPage_WithCarry_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x10 )
        }
    }

    func testZeroPage_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x7F, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x10 )
        }
    }

    func testZeroPage_WithCarry_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x7F, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x10 )
        }
    }

    func testZeroPage_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x90, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x20, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x10 )
        }
    }

    func testZeroPage_WithCarry_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x90, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x21, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x10 )
        }
    }

    func testZeroPageX() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x10, X: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x20 )
        }
    }

    func testZeroPageX_WithCarry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x10, X: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x31, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x20 )
        }
    }

    func testZeroPageX_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x0F, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x20 )
        }
    }

    func testZeroPageX_WithCarry_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x10, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x20 )
        }
    }

    func testZeroPageX_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x00, X: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 0, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x20 )
        }
    }

    func testZeroPageX_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x80, X: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x90, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x20 )
        }
    }

    func testZeroPageX_WithCarry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x80, X: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x91, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x20 )
        }
    }

    func testZeroPageX_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x20 )
        }
    }

    func testZeroPageX_WithCarry_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x20 )
        }
    }

    func testZeroPageX_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x20 )
        }
    }

    func testZeroPageX_WithCarry_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x20 )
        }
    }

    func testZeroPageX_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x7F, X: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x20 )
        }
    }

    func testZeroPageX_WithCarry_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x7F, X: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x20 )
        }
    }

    func testZeroPageX_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x90, X: 0x10, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x20, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x20 )
        }
    }

    func testZeroPageX_WithCarry_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x90, X: 0x10, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x21, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x20 )
        }
    }

    func testZeroPageX_Wrap() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x10, X: 0x20, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x0F )
        }
    }

    func testZeroPageX_Wrap_WithCarry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x10, X: 0x20, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x31, P: Flags( C: 0, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x0F )
        }
    }

    func testZeroPageX_Wrap_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x0F, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x0F )
        }
    }

    func testZeroPageX_Wrap_WithCarry_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x10, P: Flags( C: 1, Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x0F )
        }
    }

    func testZeroPageX_Wrap_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x00, X: 0x20, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 0, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x0F )
        }
    }

    func testZeroPageX_Wrap_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x80, X: 0x20, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x90, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x0F )
        }
    }

    func testZeroPageX_Wrap_WithCarry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x80, X: 0x20, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x91, P: Flags( C: 0, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x0F )
        }
    }

    func testZeroPageX_Wrap_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x0F )
        }
    }

    func testZeroPageX_Wrap_WithCarry_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 1, Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x0F )
        }
    }

    func testZeroPageX_Wrap_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x0F )
        }
    }

    func testZeroPageX_Wrap_WithCarry_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 1, Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x0F )
        }
    }

    func testZeroPageX_Wrap_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x7F, X: 0x20, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x0F )
        }
    }

    func testZeroPageX_Wrap_WithCarry_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x7F, X: 0x20, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 0, Z: 0, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x0F )
        }
    }

    func testZeroPageX_Wrap_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x90, X: 0x20, P: Flags( C: 0 ) ),
            outputRegisters: Registers( A: 0x20, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x0F )
        }
    }

    func testZeroPageX_Wrap_WithCarry_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x90, X: 0x20, P: Flags( C: 1 ) ),
            outputRegisters: Registers( A: 0x21, P: Flags( C: 1, Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x0F )
        }
    }
}
