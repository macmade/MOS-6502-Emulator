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

final class Test_Registers_Flags: XCTestCase
{
    func testDescriptionEmpty() throws
    {
        let flags = Registers.Flags( rawValue: 0 )

        XCTAssertEqual( flags.description, "--" )
    }

    func testDescriptionAll() throws
    {
        let flags = Registers.Flags( rawValue: 0xFF )

        XCTAssertEqual( flags.description, "CZIDBON" )
    }

    func testDescriptionSome() throws
    {
        let flags = Registers.Flags( [ .carryFlag, .interruptDisable, .overflowFlag, .negativeFlag ] )

        XCTAssertEqual( flags.description, "CION" )
    }

    func testDescriptionCarryFlag() throws
    {
        let flags = Registers.Flags( [ .carryFlag ] )

        XCTAssertEqual( flags.description, "C" )
    }

    func testDescriptionZeroFlag() throws
    {
        let flags = Registers.Flags( [ .zeroFlag ] )

        XCTAssertEqual( flags.description, "Z" )
    }

    func testDescriptionInterruptDisable() throws
    {
        let flags = Registers.Flags( [ .interruptDisable ] )

        XCTAssertEqual( flags.description, "I" )
    }

    func testDescriptionDecimalMode() throws
    {
        let flags = Registers.Flags( [ .decimalMode ] )

        XCTAssertEqual( flags.description, "D" )
    }

    func testDescriptionBreakCommand() throws
    {
        let flags = Registers.Flags( [ .breakCommand ] )

        XCTAssertEqual( flags.description, "B" )
    }

    func testDescriptionOverflowFlag() throws
    {
        let flags = Registers.Flags( [ .overflowFlag ] )

        XCTAssertEqual( flags.description, "O" )
    }

    func testDescriptionNegativeFlag() throws
    {
        let flags = Registers.Flags( [ .negativeFlag ] )

        XCTAssertEqual( flags.description, "N" )
    }
}
