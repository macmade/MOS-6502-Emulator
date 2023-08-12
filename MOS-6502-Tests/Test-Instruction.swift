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

class Test_Instruction: XCTestCase
{
    func executeSingleInstruction( instruction: Instruction, operands: [ UInt8 ], setup: ( CPU ) throws -> Void ) throws -> CPU
    {
        let memory = try Memory< UInt16 >( size: CPU.requiredMemory, options: [ .wrapAround ], initializeTo: 0 )
        let origin = UInt16( 0xFF00 )

        XCTAssertNoThrow( try memory.writeUInt8( instruction.opcode, at: origin ) )

        try operands.enumerated().forEach
        {
            XCTAssertNoThrow( try memory.writeUInt8( $0.element, at: origin + UInt16( $0.offset ) + 1 ) )
        }

        XCTAssertNoThrow( try memory.writeUInt16( origin, at: CPU.resetVector ) )

        let cpu = try CPU( memory: memory )

        XCTAssertNoThrow( try cpu.reset() )

        XCTAssertNoThrow( try setup( cpu ) )

        let cycles = cpu.cycles

        XCTAssertNoThrow( try cpu.run( instructions: 1 ) )
        XCTAssertEqual( cpu.cycles, cycles + UInt64( instruction.cycles ), "Incorrect CPU cycles for instruction \( instruction.mnemonic )" )

        return cpu
    }
}
