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

class Test_Instruction_ORA: Test_Instruction
{
    func testAbsolute() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ORA",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x32 ),
            outputRegisters: Registers( A: 0x7E, PS: Flags( Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x4C, at: 0x1000 )
        }
    }

    func testAbsolute_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ORA",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x00 ),
            outputRegisters: Registers( A: 0x00, PS: Flags( Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x1000 )
        }
    }

    func testAbsolute_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ORA",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xAA ),
            outputRegisters: Registers( A: 0xFE, PS: Flags( Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x54, at: 0x1000 )
        }
    }

    func testAbsoluteX() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ORA",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x32, X: 0x10 ),
            outputRegisters: Registers( A: 0x7E, PS: Flags( Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x4C, at: 0x1010 )
        }
    }

    func testAbsoluteX_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ORA",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x00, X: 0x10 ),
            outputRegisters: Registers( A: 0x00, PS: Flags( Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x1010 )
        }
    }

    func testAbsoluteX_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ORA",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xAA, X: 0x10 ),
            outputRegisters: Registers( A: 0xFE, PS: Flags( Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x54, at: 0x1010 )
        }
    }

    func testAbsoluteY() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ORA",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x32, Y: 0x10 ),
            outputRegisters: Registers( A: 0x7E, PS: Flags( Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x4C, at: 0x1010 )
        }
    }

    func testAbsoluteY_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ORA",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x00, Y: 0x10 ),
            outputRegisters: Registers( A: 0x00, PS: Flags( Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x1010 )
        }
    }

    func testAbsoluteY_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ORA",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0xAA, Y: 0x10 ),
            outputRegisters: Registers( A: 0xFE, PS: Flags( Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x54, at: 0x1010 )
        }
    }

    func testImmediate() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ORA",
            addressingMode:  .immediate,
            operand8:        0x4C,
            inputRegisters:  Registers( A: 0x32 ),
            outputRegisters: Registers( A: 0x7E, PS: Flags( Z: 0, N: 0 ) )
        )
    }

    func testImmediate_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ORA",
            addressingMode:  .immediate,
            operand8:        0x00,
            inputRegisters:  Registers( A: 0x00 ),
            outputRegisters: Registers( A: 0x00, PS: Flags( Z: 1, N: 0 ) )
        )
    }

    func testImmediate_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ORA",
            addressingMode:  .immediate,
            operand8:        0x54,
            inputRegisters:  Registers( A: 0xAA ),
            outputRegisters: Registers( A: 0xFE, PS: Flags( Z: 0, N: 1 ) )
        )
    }

    func testIndirectX() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ORA",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x32, X: 0x10 ),
            outputRegisters: Registers( A: 0x7E, PS: Flags( Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x4C, at: 0x1000 )
        }
    }

    func testIndirectX_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ORA",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x00, X: 0x10 ),
            outputRegisters: Registers( A: 0x00, PS: Flags( Z: 1, N: 0 ) )
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
            instruction:     "ORA",
            addressingMode:  .indirectX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xAA, X: 0x10 ),
            outputRegisters: Registers( A: 0xFE, PS: Flags( Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x54, at: 0x1000 )
        }
    }

    func testIndirectX_Wrap() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ORA",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x32, X: 0x20 ),
            outputRegisters: Registers( A: 0x7E, PS: Flags( Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x4C, at: 0x1000 )
        }
    }

    func testIndirectX_Wrap_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ORA",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x00, X: 0x20 ),
            outputRegisters: Registers( A: 0x00, PS: Flags( Z: 1, N: 0 ) )
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
            instruction:     "ORA",
            addressingMode:  .indirectX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xAA, X: 0x20 ),
            outputRegisters: Registers( A: 0xFE, PS: Flags( Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x54, at: 0x1000 )
        }
    }

    func testIndirectY() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ORA",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x32, Y: 0x10 ),
            outputRegisters: Registers( A: 0x7E, PS: Flags( Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x4C, at: 0x1010 )
        }
    }

    func testIndirectY_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ORA",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x00, Y: 0x10 ),
            outputRegisters: Registers( A: 0x00, PS: Flags( Z: 1, N: 0 ) )
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
            instruction:     "ORA",
            addressingMode:  .indirectY,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xAA, Y: 0x10 ),
            outputRegisters: Registers( A: 0xFE, PS: Flags( Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x54, at: 0x1010 )
        }
    }

    func testZeroPage() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ORA",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x32 ),
            outputRegisters: Registers( A: 0x7E, PS: Flags( Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x4C, at: 0x10 )
        }
    }

    func testZeroPage_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ORA",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x00 ),
            outputRegisters: Registers( A: 0x00, PS: Flags( Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x10 )
        }
    }

    func testZeroPage_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ORA",
            addressingMode:  .zeroPage,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xAA ),
            outputRegisters: Registers( A: 0xFE, PS: Flags( Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x54, at: 0x10 )
        }
    }

    func testZeroPageX() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ORA",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x32, X: 0x10 ),
            outputRegisters: Registers( A: 0x7E, PS: Flags( Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x4C, at: 0x20 )
        }
    }

    func testZeroPageX_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ORA",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0x00, X: 0x10 ),
            outputRegisters: Registers( A: 0x00, PS: Flags( Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x20 )
        }
    }

    func testZeroPageX_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ORA",
            addressingMode:  .zeroPageX,
            operand8:        0x10,
            inputRegisters:  Registers( A: 0xAA, X: 0x10 ),
            outputRegisters: Registers( A: 0xFE, PS: Flags( Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x54, at: 0x20 )
        }
    }

    func testZeroPageX_Wrap() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ORA",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x32, X: 0x20 ),
            outputRegisters: Registers( A: 0x7E, PS: Flags( Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x4C, at: 0x0F )
        }
    }

    func testZeroPageX_Wrap_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ORA",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0x00, X: 0x20 ),
            outputRegisters: Registers( A: 0x00, PS: Flags( Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: 0x0F )
        }
    }

    func testZeroPageX_Wrap_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "ORA",
            addressingMode:  .zeroPageX,
            operand8:        0xEF,
            inputRegisters:  Registers( A: 0xAA, X: 0x20 ),
            outputRegisters: Registers( A: 0xFE, PS: Flags( Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x54, at: 0x0F )
        }
    }
}
