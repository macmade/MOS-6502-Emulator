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

final class Test_Instruction_CLD: Test_Instruction
{
    func test0() throws
    {
        let cpu    = try self.setup( bytes: [ 0xD8 ] )
        let cycles = cpu.cycles

        cpu.registers.PS.remove( .decimalMode )
        XCTAssertFalse( cpu.registers.PS.contains( .decimalMode ) )

        try cpu.run( instructions: 1 )

        XCTAssertFalse( cpu.registers.PS.contains( .decimalMode ) )
        XCTAssertEqual( cpu.cycles, cycles + UInt64( Instructions.CLD.cycles ) )
    }

    func test1() throws
    {
        let cpu    = try self.setup( bytes: [ 0xD8 ] )
        let cycles = cpu.cycles

        cpu.registers.PS.insert( .decimalMode )
        XCTAssertTrue( cpu.registers.PS.contains( .decimalMode ) )

        try cpu.run( instructions: 1 )

        XCTAssertFalse( cpu.registers.PS.contains( .decimalMode ) )
        XCTAssertEqual( cpu.cycles, cycles + UInt64( Instructions.CLD.cycles ) )
    }
}
