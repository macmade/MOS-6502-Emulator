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

class Test_Instruction_BIT: Test_Instruction
{
    func testAbsolute() throws
    {
        try self.executeSingleInstruction(
            instruction:     "BIT",
            addressingMode:  .absolute,
            operand16:       0x0200,
            inputRegisters:  Registers( A: 0xFE ),
            outputRegisters: Registers( PS: Flags( Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x02, at: 0x0200 )
        }
    }

    func testAbsolute_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "BIT",
            addressingMode:  .absolute,
            operand16:       0x0200,
            inputRegisters:  Registers( A: 0xFE ),
            outputRegisters: Registers( PS: Flags( Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x0200 )
        }
    }

    func testAbsolute_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "BIT",
            addressingMode:  .absolute,
            operand16:       0x0200,
            inputRegisters:  Registers( A: 0xFF ),
            outputRegisters: Registers( PS: Flags( Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x40, at: 0x0200 )
        }
    }

    func testAbsolute_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "BIT",
            addressingMode:  .absolute,
            operand16:       0x0200,
            inputRegisters:  Registers( A: 0xFF ),
            outputRegisters: Registers( PS: Flags( Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x80, at: 0x0200 )
        }
    }

    func testAbsolute_Zero_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "BIT",
            addressingMode:  .absolute,
            operand16:       0x0200,
            inputRegisters:  Registers( A: 0xBF ),
            outputRegisters: Registers( PS: Flags( Z: 1, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x40, at: 0x0200 )
        }
    }

    func testAbsolute_Zero_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "BIT",
            addressingMode:  .absolute,
            operand16:       0x0200,
            inputRegisters:  Registers( A: 0x7F ),
            outputRegisters: Registers( PS: Flags( Z: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x80, at: 0x0200 )
        }
    }

    func testAbsolute_Zero_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "BIT",
            addressingMode:  .absolute,
            operand16:       0x0200,
            inputRegisters:  Registers( A: 0x3F ),
            outputRegisters: Registers( PS: Flags( Z: 1, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0xC0, at: 0x0200 )
        }
    }

    func testZeroPage() throws
    {
        try self.executeSingleInstruction(
            instruction:     "BIT",
            addressingMode:  .absolute,
            operands:        [ 0x20 ],
            inputRegisters:  Registers( A: 0xFE ),
            outputRegisters: Registers( PS: Flags( Z: 0, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x02, at: 0x0020 )
        }
    }

    func testZeroPage_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "BIT",
            addressingMode:  .absolute,
            operands:        [ 0x20 ],
            inputRegisters:  Registers( A: 0xFE ),
            outputRegisters: Registers( PS: Flags( Z: 1, V: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x01, at: 0x0020 )
        }
    }

    func testZeroPage_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "BIT",
            addressingMode:  .absolute,
            operands:        [ 0x20 ],
            inputRegisters:  Registers( A: 0xFF ),
            outputRegisters: Registers( PS: Flags( Z: 0, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x40, at: 0x0020 )
        }
    }

    func testZeroPage_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "BIT",
            addressingMode:  .absolute,
            operands:        [ 0x20 ],
            inputRegisters:  Registers( A: 0xFF ),
            outputRegisters: Registers( PS: Flags( Z: 0, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x80, at: 0x0020 )
        }
    }

    func testZeroPage_Zero_Overflow() throws
    {
        try self.executeSingleInstruction(
            instruction:     "BIT",
            addressingMode:  .absolute,
            operands:        [ 0x20 ],
            inputRegisters:  Registers( A: 0xBF ),
            outputRegisters: Registers( PS: Flags( Z: 1, V: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x40, at: 0x0020 )
        }
    }

    func testZeroPage_Zero_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "BIT",
            addressingMode:  .absolute,
            operands:        [ 0x20 ],
            inputRegisters:  Registers( A: 0x7F ),
            outputRegisters: Registers( PS: Flags( Z: 1, V: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x80, at: 0x0020 )
        }
    }

    func testZeroPage_Zero_Overflow_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "BIT",
            addressingMode:  .absolute,
            operands:        [ 0x20 ],
            inputRegisters:  Registers( A: 0x3F ),
            outputRegisters: Registers( PS: Flags( Z: 1, V: 1, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0xC0, at: 0x0020 )
        }
    }
}
