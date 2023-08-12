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

class Test_Instruction_CLI: Test_Instruction
{
    func testImplicit0() throws
    {
        let cpu = try self.executeSingleInstruction( instruction: Instructions.CLI_Implicit, operands: [] )
        {
            $0.registers.PS.remove( .interruptDisable )
        }

        XCTAssertFalse( cpu.registers.PS.contains( .interruptDisable ) )
    }

    func testImplicit1() throws
    {
        let cpu = try self.executeSingleInstruction( instruction: Instructions.CLI_Implicit, operands: [] )
        {
            $0.registers.PS.insert( .interruptDisable )
        }

        XCTAssertFalse( cpu.registers.PS.contains( .interruptDisable ) )
    }
}
