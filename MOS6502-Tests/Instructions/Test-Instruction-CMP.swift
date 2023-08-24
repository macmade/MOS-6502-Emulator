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

class Test_Instruction_CMP: Test_Instruction
{
    func testAbsolute() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0xFF, at: 0x1000 )
        }
    }

    func testAbsolute_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testAbsolute_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x20 ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testAbsolute_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .absolute,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x1000 )
        }
    }

    func testAbsoluteX() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x10, X: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0xFF, at: 0x1010 )
        }
    }

    func testAbsoluteX_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x10, X: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testAbsoluteX_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x20, X: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testAbsoluteX_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .absoluteX,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x10, X: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x1010 )
        }
    }

    func testAbsoluteY() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x10, Y: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0xFF, at: 0x1010 )
        }
    }

    func testAbsoluteY_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x10, Y: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testAbsoluteY_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x20, Y: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testAbsoluteY_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .absoluteY,
            operand16:       0x1000,
            inputRegisters:  Registers( A: 0x10, Y: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x1010 )
        }
    }

    func testImmediate() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .immediate,
            operands:        [ 0xFF ],
            inputRegisters:  Registers( A: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 0 ) )
        )
    }

    func testImmediate_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .immediate,
            operands:        [ 0x10 ],
            inputRegisters:  Registers( A: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 1, N: 0 ) )
        )
    }

    func testImmediate_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .immediate,
            operands:        [ 0x10 ],
            inputRegisters:  Registers( A: 0x20 ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 0 ) )
        )
    }

    func testImmediate_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .immediate,
            operands:        [ 0x20 ],
            inputRegisters:  Registers( A: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 1 ) )
        )
    }

    func testIndirectX() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .indirectX,
            operands:        [ 0x10 ],
            inputRegisters:  Registers( A: 0x10, X: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0xFF, at: 0x1000 )
        }
    }

    func testIndirectX_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .indirectX,
            operands:        [ 0x10 ],
            inputRegisters:  Registers( A: 0x10, X: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testIndirectX_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .indirectX,
            operands:        [ 0x10 ],
            inputRegisters:  Registers( A: 0x20, X: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testIndirectX_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .indirectX,
            operands:        [ 0x10 ],
            inputRegisters:  Registers( A: 0x10, X: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x20 )
            try bus.write( 0x20, at: 0x1000 )
        }
    }

    func testIndirectX_Wrap() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .indirectX,
            operands:        [ 0xEF ],
            inputRegisters:  Registers( A: 0x10, X: 0x20 ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0xFF, at: 0x1000 )
        }
    }

    func testIndirectX_Wrap_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .indirectX,
            operands:        [ 0xEF ],
            inputRegisters:  Registers( A: 0x10, X: 0x20 ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testIndirectX_Wrap_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .indirectX,
            operands:        [ 0xEF ],
            inputRegisters:  Registers( A: 0x20, X: 0x20 ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x10, at: 0x1000 )
        }
    }

    func testIndirectX_Wrap_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .indirectX,
            operands:        [ 0xEF ],
            inputRegisters:  Registers( A: 0x10, X: 0x20 ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x0F )
            try bus.write( 0x20, at: 0x1000 )
        }
    }

    func testIndirectY() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .indirectY,
            operands:        [ 0x10 ],
            inputRegisters:  Registers( A: 0x10, Y: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0xFF, at: 0x1010 )
        }
    }

    func testIndirectY_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .indirectY,
            operands:        [ 0x10 ],
            inputRegisters:  Registers( A: 0x10, Y: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testIndirectY_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .indirectY,
            operands:        [ 0x10 ],
            inputRegisters:  Registers( A: 0x20, Y: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x10, at: 0x1010 )
        }
    }

    func testIndirectY_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .indirectY,
            operands:        [ 0x10 ],
            inputRegisters:  Registers( A: 0x10, Y: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in

            try bus.writeUInt16( 0x1000, at: 0x10 )
            try bus.write( 0x20, at: 0x1010 )
        }
    }

    func testZeroPage() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .zeroPage,
            operands:        [ 0x10 ],
            inputRegisters:  Registers( A: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0xFF, at: 0x10 )
        }
    }

    func testZeroPage_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .zeroPage,
            operands:        [ 0x10 ],
            inputRegisters:  Registers( A: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x10 )
        }
    }

    func testZeroPage_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .zeroPage,
            operands:        [ 0x10 ],
            inputRegisters:  Registers( A: 0x20 ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x10 )
        }
    }

    func testZeroPage_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .zeroPage,
            operands:        [ 0x10 ],
            inputRegisters:  Registers( A: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x10 )
        }
    }

    func testZeroPageX() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .zeroPageX,
            operands:        [ 0x10 ],
            inputRegisters:  Registers( A: 0x10, X: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0xFF, at: 0x20 )
        }
    }

    func testZeroPageX_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .zeroPageX,
            operands:        [ 0x10 ],
            inputRegisters:  Registers( A: 0x10, X: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x20 )
        }
    }

    func testZeroPageX_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .zeroPageX,
            operands:        [ 0x10 ],
            inputRegisters:  Registers( A: 0x20, X: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x20 )
        }
    }

    func testZeroPageX_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .zeroPageX,
            operands:        [ 0x10 ],
            inputRegisters:  Registers( A: 0x10, X: 0x10 ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x20 )
        }
    }

    func testZeroPageX_Wrap() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .zeroPageX,
            operands:        [ 0xEF ],
            inputRegisters:  Registers( A: 0x10, X: 0x20 ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0xFF, at: 0x0F )
        }
    }

    func testZeroPageX_Wrap_Zero() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .zeroPageX,
            operands:        [ 0xEF ],
            inputRegisters:  Registers( A: 0x10, X: 0x20 ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 1, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x0F )
        }
    }

    func testZeroPageX_Wrap_Carry() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .zeroPageX,
            operands:        [ 0xEF ],
            inputRegisters:  Registers( A: 0x20, X: 0x20 ),
            outputRegisters: Registers( PS: Flags( C: 1, Z: 0, N: 0 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x10, at: 0x0F )
        }
    }

    func testZeroPageX_Wrap_Negative() throws
    {
        try self.executeSingleInstruction(
            instruction:     "CMP",
            addressingMode:  .zeroPageX,
            operands:        [ 0xEF ],
            inputRegisters:  Registers( A: 0x10, X: 0x20 ),
            outputRegisters: Registers( PS: Flags( C: 0, Z: 0, N: 1 ) )
        )
        {
            cpu, bus, ram in try bus.write( 0x20, at: 0x0F )
        }
    }
}
