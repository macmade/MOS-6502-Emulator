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

import MOS_6502_Emulator
import XCTest

final class Test_Instruction_LDA: Test_Instruction
{
    func testImmediate0x42() throws
    {
        let cpu    = try self.setup( bytes: [ 0xA9, 0x42 ] )
        let cycles = cpu.cycles

        try cpu.run( instructions: 1 )

        XCTAssertEqual( cpu.registers.A, 0x42 )
        XCTAssertEqual( cpu.cycles, cycles + UInt64( Instructions.LDA_Immediate.cycles ) )
    }

    func testImmediate0xFF() throws
    {
        let cpu    = try self.setup( bytes: [ 0xA9, 0xFF ] )
        let cycles = cpu.cycles

        try cpu.run( instructions: 1 )

        XCTAssertEqual( cpu.registers.A, 0xFF )
        XCTAssertEqual( cpu.cycles, cycles + UInt64( Instructions.LDA_Immediate.cycles ) )
    }
}
