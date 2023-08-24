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

class Test_Instruction_PLP: Test_Instruction
{
    func testImplied() throws
    {
        try [ 0x00, 0x55, 0xAA, 0xFF ].map
        {
            UInt8( $0 )
        }
        .forEach
        {
            byte in

            let result = try self.executeSingleInstruction(
                instruction:     "PLP",
                addressingMode:  .implied,
                operands:        [],
                inputRegisters:  Registers( SP: 0x00 ),
                outputRegisters: Registers( SP: 0x01, PS: Flags( rawValue: byte ) )
            )
            {
                cpu, bus, ram in try bus.write( byte, at: CPU.stackStart + UInt16( 0x01 ) )
            }

            XCTAssertEqual( try result.ram.read( at: CPU.stackStart + UInt16( 0x01 ) ), byte )
        }
    }

    func testImplied_Wrap() throws
    {
        try [ 0x00, 0x55, 0xAA, 0xFF ].map
        {
            UInt8( $0 )
        }
        .forEach
        {
            byte in

            let result = try self.executeSingleInstruction(
                instruction:     "PLP",
                addressingMode:  .implied,
                operands:        [],
                inputRegisters:  Registers( SP: 0xFF ),
                outputRegisters: Registers( SP: 0x00, PS: Flags( rawValue: byte ) )
            )
            {
                cpu, bus, ram in try bus.write( byte, at: CPU.stackStart + UInt16( 0x00 ) )
            }

            XCTAssertEqual( try result.ram.read( at: CPU.stackStart + UInt16( 0x00 ) ), byte )
        }
    }
}
