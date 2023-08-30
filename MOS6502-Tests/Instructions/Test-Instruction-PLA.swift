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

class Test_Instruction_PLA: Test_Instruction
{
    func testImplied_Wrap() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "PLA",
            addressingMode:  .implied,
            operands:        [],
            inputRegisters:  Registers( SP: 0xFF ),
            outputRegisters: Registers( SP: 0x00, A: 0x42, P: Flags( Z: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x42, at: CPU.stackStart + UInt16( 0x00 ) )
        }

        XCTAssertEqual( try result.ram.read( at: CPU.stackStart + UInt16( 0x00 ) ), 0x42 )
    }

    func testImplied() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "PLA",
            addressingMode:  .implied,
            operands:        [],
            inputRegisters:  Registers( SP: 0x00 ),
            outputRegisters: Registers( SP: 0x01, A: 0x42, P: Flags( Z: 0, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x42, at: CPU.stackStart + UInt16( 0x01 ) )
        }

        XCTAssertEqual( try result.ram.read( at: CPU.stackStart + UInt16( 0x01 ) ), 0x42 )
    }

    func testImplied_Zero() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "PLA",
            addressingMode:  .implied,
            operands:        [],
            inputRegisters:  Registers( SP: 0x00 ),
            outputRegisters: Registers( SP: 0x01, A: 0x00, P: Flags( Z: 1, N: 0 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0x00, at: CPU.stackStart + UInt16( 0x01 ) )
        }

        XCTAssertEqual( try result.ram.read( at: CPU.stackStart + UInt16( 0x01 ) ), 0x00 )
    }

    func testImplied_Negative() throws
    {
        let result = try self.executeSingleInstruction(
            instruction:     "PLA",
            addressingMode:  .implied,
            operands:        [],
            inputRegisters:  Registers( SP: 0x00 ),
            outputRegisters: Registers( SP: 0x01, A: 0xFF, P: Flags( Z: 0, N: 1 ) ),
            extraCycles:     0
        )
        {
            cpu, bus, ram in try bus.write( 0xFF, at: CPU.stackStart + UInt16( 0x01 ) )
        }

        XCTAssertEqual( try result.ram.read( at: CPU.stackStart + UInt16( 0x01 ) ), 0xFF )
    }
}
