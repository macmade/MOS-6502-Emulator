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

class Test_Instruction_ADC_Decimal: Test_Instruction
{
    func testDecimalAbsolute() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x1000 )
        }
    }

    func testDecimalAbsolute_WithCarry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x31, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x1000 )
        }
    }

    func testDecimalAbsolute_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x75, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testDecimalAbsolute_WithCarry_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x76, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testDecimalAbsolute_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x00, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 0, Z: 1, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x1000 )
        }
    }

    func testDecimalAbsolute_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x80, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x90, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testDecimalAbsolute_WithCarry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x80, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x91, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testDecimalAbsolute_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x66, P: Flags( C: 1, Z: 1, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x1000 )
        }
    }

    func testDecimalAbsolute_WithCarry_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x66, P: Flags( C: 1, Z: 1, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x1000 )
        }
    }

    func testDecimalAbsolute_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0xE6, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x1000 )
        }
    }

    func testDecimalAbsolute_WithCarry_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0xE7, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x1000 )
        }
    }

    func testDecimalAbsolute_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x7F, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x86, P: Flags( C: 0, Z: 0, D: 1, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x1000 )
        }
    }

    func testDecimalAbsolute_WithCarry_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x7F, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x87, P: Flags( C: 0, Z: 0, D: 1, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x1000 )
        }
    }

    func testDecimalAbsolute_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x90, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 1, Z: 0, D: 1, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x1000 )
        }
    }

    func testDecimalAbsolute_WithCarry_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x90, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 1, Z: 0, D: 1, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x1000 )
        }
    }

    func testDecimalAbsoluteX() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x10, X: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x1010 )
        }
    }

    func testDecimalAbsoluteX_PageCross() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x10FF,
            inputRegisters:  Registers( A: 0x10, X: 0x01, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     1
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x1100 )
        }
    }

    func testDecimalAbsoluteX_WithCarry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x10, X: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x31, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x1010 )
        }
    }

    func testDecimalAbsoluteX_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x75, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testDecimalAbsoluteX_WithCarry_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x76, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testDecimalAbsoluteX_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x00, X: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 0, Z: 1, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x1010 )
        }
    }

    func testDecimalAbsoluteX_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x80, X: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x90, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testDecimalAbsoluteX_WithCarry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x80, X: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x91, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testDecimalAbsoluteX_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x66, P: Flags( C: 1, Z: 1, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x1010 )
        }
    }

    func testDecimalAbsoluteX_WithCarry_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x66, P: Flags( C: 1, Z: 1, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x1010 )
        }
    }

    func testDecimalAbsoluteX_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0xE6, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x1010 )
        }
    }

    func testDecimalAbsoluteX_WithCarry_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0xE7, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x1010 )
        }
    }

    func testDecimalAbsoluteX_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x7F, X: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x86, P: Flags( C: 0, Z: 0, D: 1, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x1010 )
        }
    }

    func testDecimalAbsoluteX_WithCarry_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x7F, X: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x87, P: Flags( C: 0, Z: 0, D: 1, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x1010 )
        }
    }

    func testDecimalAbsoluteX_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x90, X: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 1, Z: 0, D: 1, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x1010 )
        }
    }

    func testDecimalAbsoluteX_WithCarry_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x90, X: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 1, Z: 0, D: 1, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x1010 )
        }
    }

    func testDecimalAbsoluteY() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x10, Y: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x1010 )
        }
    }

    func testDecimalAbsoluteY_PageCross() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x10FF,
            inputRegisters:  Registers( A: 0x10, Y: 0x01, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     1
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x1100 )
        }
    }

    func testDecimalAbsoluteY_WithCarry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x10, Y: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x31, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x1010 )
        }
    }

    func testDecimalAbsoluteY_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x75, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testDecimalAbsoluteY_WithCarry_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x76, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testDecimalAbsoluteY_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x00, Y: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 0, Z: 1, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x1010 )
        }
    }

    func testDecimalAbsoluteY_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x80, Y: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x90, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testDecimalAbsoluteY_WithCarry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x80, Y: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x91, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testDecimalAbsoluteY_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x66, P: Flags( C: 1, Z: 1, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x1010 )
        }
    }

    func testDecimalAbsoluteY_WithCarry_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x66, P: Flags( C: 1, Z: 1, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x1010 )
        }
    }

    func testDecimalAbsoluteY_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0xE6, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x1010 )
        }
    }

    func testDecimalAbsoluteY_WithCarry_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0xE7, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x1010 )
        }
    }

    func testDecimalAbsoluteY_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x7F, Y: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x86, P: Flags( C: 0, Z: 0, D: 1, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x1010 )
        }
    }

    func testDecimalAbsoluteY_WithCarry_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x7F, Y: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x87, P: Flags( C: 0, Z: 0, D: 1, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x1010 )
        }
    }

    func testDecimalAbsoluteY_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x90, Y: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 1, Z: 0, D: 1, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x1010 )
        }
    }

    func testDecimalAbsoluteY_WithCarry_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x90, Y: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 1, Z: 0, D: 1, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x1010 )
        }
    }

    func testDecimalImmediate() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x20,
            inputRegisters:  Registers( A: 0x10, Y: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
    }

    func testDecimalImmediate_WithCarry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x20,
            inputRegisters:  Registers( A: 0x10, Y: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x31, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
    }

    func testDecimalImmediate_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x75, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
    }

    func testDecimalImmediate_WithCarry_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x76, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
    }

    func testDecimalImmediate_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x00,
            inputRegisters:  Registers( A: 0x00, Y: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 0, Z: 1, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
    }

    func testDecimalImmediate_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x80, Y: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x90, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
    }

    func testDecimalImmediate_WithCarry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x80, Y: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x91, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
    }

    func testDecimalImmediate_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x01,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x66, P: Flags( C: 1, Z: 1, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
    }

    func testDecimalImmediate_WithCarry_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x00,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x66, P: Flags( C: 1, Z: 1, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
    }

    func testDecimalImmediate_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x81,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0xE6, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
    }

    func testDecimalImmediate_WithCarry_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x81,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0xE7, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
    }

    func testDecimalImmediate_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x01,
            inputRegisters:  Registers( A: 0x7F, Y: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x86, P: Flags( C: 0, Z: 0, D: 1, V: 1, N: 1 ) ),
            extraCycles:     0
        )
    }

    func testDecimalImmediate_WithCarry_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x01,
            inputRegisters:  Registers( A: 0x7F, Y: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x87, P: Flags( C: 0, Z: 0, D: 1, V: 1, N: 1 ) ),
            extraCycles:     0
        )
    }

    func testDecimalImmediate_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x90,
            inputRegisters:  Registers( A: 0x90, Y: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 1, Z: 0, D: 1, V: 1, N: 0 ) ),
            extraCycles:     0
        )
    }

    func testDecimalImmediate_WithCarry_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .immediate,
            operand8:        0x90,
            inputRegisters:  Registers( A: 0x90, Y: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 1, Z: 0, D: 1, V: 1, N: 0 ) ),
            extraCycles:     0
        )
    }

    func testDecimalIndirectX() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x10, X: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x20, at: 0x1000 )
        }
    }

    func testDecimalIndirectX_WithCarry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x10, X: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x31, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x20, at: 0x1000 )
        }
    }

    func testDecimalIndirectX_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x75, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testDecimalIndirectX_WithCarry_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x76, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testDecimalIndirectX_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x00, X: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 0, Z: 1, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x00, at: 0x1000 )
        }
    }

    func testDecimalIndirectX_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x80, X: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x90, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testDecimalIndirectX_WithCarry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x80, X: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x91, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testDecimalIndirectX_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x66, P: Flags( C: 1, Z: 1, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x01, at: 0x1000 )
        }
    }

    func testDecimalIndirectX_WithCarry_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x66, P: Flags( C: 1, Z: 1, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x00, at: 0x1000 )
        }
    }

    func testDecimalIndirectX_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0xE6, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x81, at: 0x1000 )
        }
    }

    func testDecimalIndirectX_WithCarry_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0xE7, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x81, at: 0x1000 )
        }
    }

    func testDecimalIndirectX_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x7F, X: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x86, P: Flags( C: 0, Z: 0, D: 1, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x01, at: 0x1000 )
        }
    }

    func testDecimalIndirectX_WithCarry_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x7F, X: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x87, P: Flags( C: 0, Z: 0, D: 1, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x01, at: 0x1000 )
        }
    }

    func testDecimalIndirectX_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x90, X: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 1, Z: 0, D: 1, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x90, at: 0x1000 )
        }
    }

    func testDecimalIndirectX_WithCarry_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x90, X: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 1, Z: 0, D: 1, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x90, at: 0x1000 )
        }
    }

    func testDecimalIndirectX_Wrap() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x10, X: 0x20, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x20, at: 0x1000 )
        }
    }

    func testDecimalIndirectX_Wrap_WithCarry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x10, X: 0x20, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x31, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x20, at: 0x1000 )
        }
    }

    func testDecimalIndirectX_Wrap_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x75, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testDecimalIndirectX_Wrap_WithCarry_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x76, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testDecimalIndirectX_Wrap_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x00, X: 0x20, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 0, Z: 1, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x00, at: 0x1000 )
        }
    }

    func testDecimalIndirectX_Wrap_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x80, X: 0x20, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x90, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testDecimalIndirectX_Wrap_WithCarry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x80, X: 0x20, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x91, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testDecimalIndirectX_Wrap_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x66, P: Flags( C: 1, Z: 1, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x01, at: 0x1000 )
        }
    }

    func testDecimalIndirectX_Wrap_WithCarry_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x66, P: Flags( C: 1, Z: 1, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x00, at: 0x1000 )
        }
    }

    func testDecimalIndirectX_Wrap_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0xE6, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x81, at: 0x1000 )
        }
    }

    func testDecimalIndirectX_Wrap_WithCarry_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0xE7, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x81, at: 0x1000 )
        }
    }

    func testDecimalIndirectX_Wrap_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x7F, X: 0x20, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x86, P: Flags( C: 0, Z: 0, D: 1, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x01, at: 0x1000 )
        }
    }

    func testDecimalIndirectX_Wrap_WithCarry_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x7F, X: 0x20, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x87, P: Flags( C: 0, Z: 0, D: 1, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x01, at: 0x1000 )
        }
    }

    func testDecimalIndirectX_Wrap_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x90, X: 0x20, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 1, Z: 0, D: 1, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x90, at: 0x1000 )
        }
    }

    func testDecimalIndirectX_Wrap_WithCarry_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x90, X: 0x20, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 1, Z: 0, D: 1, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x90, at: 0x1000 )
        }
    }

    func testDecimalIndirectY() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x10, Y: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x20, at: 0x1010 )
        }
    }

    func testDecimalIndirectY_PageCross() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x10, Y: 0x01, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     1
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x10FF, at: 0x10 )
            try bus.write( 0x20, at: 0x1100 )
        }
    }

    func testDecimalIndirectY_WithCarry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x10, Y: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x31, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x20, at: 0x1010 )
        }
    }

    func testDecimalIndirectY_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x75, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testDecimalIndirectY_WithCarry_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x76, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testDecimalIndirectY_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x00, Y: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 0, Z: 1, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x00, at: 0x1010 )
        }
    }

    func testDecimalIndirectY_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x80, Y: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x90, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testDecimalIndirectY_WithCarry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x80, Y: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x91, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testDecimalIndirectY_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x66, P: Flags( C: 1, Z: 1, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x01, at: 0x1010 )
        }
    }

    func testDecimalIndirectY_WithCarry_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x66, P: Flags( C: 1, Z: 1, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x00, at: 0x1010 )
        }
    }

    func testDecimalIndirectY_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0xE6, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x81, at: 0x1010 )
        }
    }

    func testDecimalIndirectY_WithCarry_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, Y: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0xE7, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x81, at: 0x1010 )
        }
    }

    func testDecimalIndirectY_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x7F, Y: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x86, P: Flags( C: 0, Z: 0, D: 1, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x01, at: 0x1010 )
        }
    }

    func testDecimalIndirectY_WithCarry_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x7F, Y: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x87, P: Flags( C: 0, Z: 0, D: 1, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x01, at: 0x1010 )
        }
    }

    func testDecimalIndirectY_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x90, Y: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 1, Z: 0, D: 1, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x90, at: 0x1010 )
        }
    }

    func testDecimalIndirectY_WithCarry_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x90, Y: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 1, Z: 0, D: 1, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x90, at: 0x1010 )
        }
    }

    func testDecimalZeroPage() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x10 )
        }
    }

    func testDecimalZeroPage_WithCarry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x31, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x10 )
        }
    }

    func testDecimalZeroPage_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x75, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x10 )
        }
    }

    func testDecimalZeroPage_WithCarry_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x76, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x10 )
        }
    }

    func testDecimalZeroPage_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x00, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 0, Z: 1, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x10 )
        }
    }

    func testDecimalZeroPage_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x80, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x90, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x10 )
        }
    }

    func testDecimalZeroPage_WithCarry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x80, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x91, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x10 )
        }
    }

    func testDecimalZeroPage_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x66, P: Flags( C: 1, Z: 1, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x10 )
        }
    }

    func testDecimalZeroPage_WithCarry_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x66, P: Flags( C: 1, Z: 1, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x10 )
        }
    }

    func testDecimalZeroPage_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0xE6, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x10 )
        }
    }

    func testDecimalZeroPage_WithCarry_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0xE7, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x10 )
        }
    }

    func testDecimalZeroPage_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x7F, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x86, P: Flags( C: 0, Z: 0, D: 1, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x10 )
        }
    }

    func testDecimalZeroPage_WithCarry_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x7F, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x87, P: Flags( C: 0, Z: 0, D: 1, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x10 )
        }
    }

    func testDecimalZeroPage_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x90, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 1, Z: 0, D: 1, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x10 )
        }
    }

    func testDecimalZeroPage_WithCarry_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x90, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 1, Z: 0, D: 1, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x10 )
        }
    }

    func testDecimalZeroPageX() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x10, X: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x20 )
        }
    }

    func testDecimalZeroPageX_WithCarry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x10, X: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x31, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x20 )
        }
    }

    func testDecimalZeroPageX_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x75, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x20 )
        }
    }

    func testDecimalZeroPageX_WithCarry_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x76, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x20 )
        }
    }

    func testDecimalZeroPageX_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x00, X: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 0, Z: 1, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x20 )
        }
    }

    func testDecimalZeroPageX_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x80, X: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x90, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x20 )
        }
    }

    func testDecimalZeroPageX_WithCarry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x80, X: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x91, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x20 )
        }
    }

    func testDecimalZeroPageX_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x66, P: Flags( C: 1, Z: 1, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x20 )
        }
    }

    func testDecimalZeroPageX_WithCarry_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x66, P: Flags( C: 1, Z: 1, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x20 )
        }
    }

    func testDecimalZeroPageX_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0xE6, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x20 )
        }
    }

    func testDecimalZeroPageX_WithCarry_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xFF, X: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0xE7, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x20 )
        }
    }

    func testDecimalZeroPageX_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x7F, X: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x86, P: Flags( C: 0, Z: 0, D: 1, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x20 )
        }
    }

    func testDecimalZeroPageX_WithCarry_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x7F, X: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x87, P: Flags( C: 0, Z: 0, D: 1, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x20 )
        }
    }

    func testDecimalZeroPageX_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x90, X: 0x10, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 1, Z: 0, D: 1, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x20 )
        }
    }

    func testDecimalZeroPageX_WithCarry_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x90, X: 0x10, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 1, Z: 0, D: 1, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x20 )
        }
    }

    func testDecimalZeroPageX_Wrap() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x10, X: 0x20, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x30, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x0F )
        }
    }

    func testDecimalZeroPageX_Wrap_WithCarry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x10, X: 0x20, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x31, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x0F )
        }
    }

    func testDecimalZeroPageX_Wrap_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x75, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x0F )
        }
    }

    func testDecimalZeroPageX_Wrap_WithCarry_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x76, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x0F )
        }
    }

    func testDecimalZeroPageX_Wrap_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x00, X: 0x20, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x00, P: Flags( C: 0, Z: 1, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x0F )
        }
    }

    func testDecimalZeroPageX_Wrap_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x80, X: 0x20, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x90, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x0F )
        }
    }

    func testDecimalZeroPageX_Wrap_WithCarry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x80, X: 0x20, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x91, P: Flags( C: 0, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x0F )
        }
    }

    func testDecimalZeroPageX_Wrap_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x66, P: Flags( C: 1, Z: 1, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x0F )
        }
    }

    func testDecimalZeroPageX_Wrap_WithCarry_Carry_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x66, P: Flags( C: 1, Z: 1, D: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x0F )
        }
    }

    func testDecimalZeroPageX_Wrap_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0xE6, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x0F )
        }
    }

    func testDecimalZeroPageX_Wrap_WithCarry_Carry_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xFF, X: 0x20, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0xE7, P: Flags( C: 1, Z: 0, D: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x81, at: 0x0F )
        }
    }

    func testDecimalZeroPageX_Wrap_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x7F, X: 0x20, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x86, P: Flags( C: 0, Z: 0, D: 1, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x0F )
        }
    }

    func testDecimalZeroPageX_Wrap_WithCarry_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x7F, X: 0x20, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x87, P: Flags( C: 0, Z: 0, D: 1, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x0F )
        }
    }

    func testDecimalZeroPageX_Wrap_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x90, X: 0x20, P: Flags( C: 0, D: 1 ) ),
            outputRegisters: Registers( A: 0x80, P: Flags( C: 1, Z: 0, D: 1, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x0F )
        }
    }

    func testDecimalZeroPageX_Wrap_WithCarry_Carry_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ADC",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x90, X: 0x20, P: Flags( C: 1, D: 1 ) ),
            outputRegisters: Registers( A: 0x81, P: Flags( C: 1, Z: 0, D: 1, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x90, at: 0x0F )
        }
    }
}
