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

final class Test_BinaryInteger: XCTestCase
{
    let bitsAllZero   = [ false, false, false, false, false, false, false, false ]
    let bitsAllOne    = [ true,  true,  true,  true,  true,  true,  true,  true  ]
    let bitsAlternate = [ true,  false, true,  false, true,  false, true,  false ]

    func testBits8() throws
    {
        XCTAssertEqual( UInt8( 0x00 ).bits, self.bitsAllZero )
        XCTAssertEqual( UInt8( 0xFF ).bits, self.bitsAllOne )
        XCTAssertEqual( UInt8( 0x55 ).bits, self.bitsAlternate )
    }

    func testBits16() throws
    {
        XCTAssertEqual( UInt16( 0x0000 ).bits, [ self.bitsAllZero,   self.bitsAllZero   ].flatMap { $0 } )
        XCTAssertEqual( UInt16( 0xFFFF ).bits, [ self.bitsAllOne,    self.bitsAllOne    ].flatMap { $0 } )
        XCTAssertEqual( UInt16( 0x5555 ).bits, [ self.bitsAlternate, self.bitsAlternate ].flatMap { $0 } )
    }

    func testBits32() throws
    {
        XCTAssertEqual( UInt32( 0x00000000 ).bits, [ self.bitsAllZero,   self.bitsAllZero,   self.bitsAllZero,   self.bitsAllZero   ].flatMap { $0 } )
        XCTAssertEqual( UInt32( 0xFFFFFFFF ).bits, [ self.bitsAllOne,    self.bitsAllOne,    self.bitsAllOne,    self.bitsAllOne    ].flatMap { $0 } )
        XCTAssertEqual( UInt32( 0x55555555 ).bits, [ self.bitsAlternate, self.bitsAlternate, self.bitsAlternate, self.bitsAlternate ].flatMap { $0 } )
    }

    func testBits64() throws
    {
        XCTAssertEqual( UInt64( 0x0000000000000000 ).bits, [ self.bitsAllZero,   self.bitsAllZero,   self.bitsAllZero,   self.bitsAllZero,   self.bitsAllZero,   self.bitsAllZero,   self.bitsAllZero,   self.bitsAllZero   ].flatMap { $0 } )
        XCTAssertEqual( UInt64( 0xFFFFFFFFFFFFFFFF ).bits, [ self.bitsAllOne,    self.bitsAllOne,    self.bitsAllOne,    self.bitsAllOne,    self.bitsAllOne,    self.bitsAllOne,    self.bitsAllOne,    self.bitsAllOne    ].flatMap { $0 } )
        XCTAssertEqual( UInt64( 0x5555555555555555 ).bits, [ self.bitsAlternate, self.bitsAlternate, self.bitsAlternate, self.bitsAlternate, self.bitsAlternate, self.bitsAlternate, self.bitsAlternate, self.bitsAlternate ].flatMap { $0 } )
    }

    func testBytes8() throws
    {
        XCTAssertEqual( UInt8( 0x00 ).bytes, [ 0x00 ] )
        XCTAssertEqual( UInt8( 0xFF ).bytes, [ 0xFF ] )
        XCTAssertEqual( UInt8( 0xAB ).bytes, [ 0xAB ] )
    }

    func testBytes16() throws
    {
        XCTAssertEqual( UInt16( 0x0000 ).bytes, [ 0x00, 0x00 ] )
        XCTAssertEqual( UInt16( 0xFFFF ).bytes, [ 0xFF, 0xFF ] )
        XCTAssertEqual( UInt16( 0xABCD ).bytes, [ 0xCD, 0xAB ] )
    }

    func testBytes32() throws
    {
        XCTAssertEqual( UInt32( 0x00000000 ).bytes, [ 0x00, 0x00, 0x00, 0x00 ] )
        XCTAssertEqual( UInt32( 0xFFFFFFFF ).bytes, [ 0xFF, 0xFF, 0xFF, 0xFF ] )
        XCTAssertEqual( UInt32( 0xABCDEF12 ).bytes, [ 0x12, 0xEF, 0xCD, 0xAB ] )
    }

    func testBytes64() throws
    {
        XCTAssertEqual( UInt64( 0x0000000000000000 ).bytes, [ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ] )
        XCTAssertEqual( UInt64( 0xFFFFFFFFFFFFFFFF ).bytes, [ 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF ] )
        XCTAssertEqual( UInt64( 0xABCDEF1234567890 ).bytes, [ 0x90, 0x78, 0x56, 0x34, 0x12, 0xEF, 0xCD, 0xAB ] )
    }

    func testAsHex8()
    {
        XCTAssertEqual( UInt8( 0x00 ).asHex, "0x00" )
        XCTAssertEqual( UInt8( 0x0F ).asHex, "0x0F" )
        XCTAssertEqual( UInt8( 0xF0 ).asHex, "0xF0" )
        XCTAssertEqual( UInt8( 0xFF ).asHex, "0xFF" )
        XCTAssertEqual( UInt8( 0xAB ).asHex, "0xAB" )
    }

    func testAsHex16()
    {
        XCTAssertEqual( UInt16( 0x0000 ).asHex, "0x0000" )
        XCTAssertEqual( UInt16( 0x000F ).asHex, "0x000F" )
        XCTAssertEqual( UInt16( 0xF000 ).asHex, "0xF000" )
        XCTAssertEqual( UInt16( 0xFFFF ).asHex, "0xFFFF" )
        XCTAssertEqual( UInt16( 0xABCD ).asHex, "0xABCD" )
    }

    func testAsHex32()
    {
        XCTAssertEqual( UInt32( 0x00000000 ).asHex, "0x00000000" )
        XCTAssertEqual( UInt32( 0x0000000F ).asHex, "0x0000000F" )
        XCTAssertEqual( UInt32( 0xF0000000 ).asHex, "0xF0000000" )
        XCTAssertEqual( UInt32( 0xFFFFFFFF ).asHex, "0xFFFFFFFF" )
        XCTAssertEqual( UInt32( 0xABCDEF12 ).asHex, "0xABCDEF12" )
    }

    func testAsHex64()
    {
        XCTAssertEqual( UInt64( 0x0000000000000000 ).asHex, "0x0000000000000000" )
        XCTAssertEqual( UInt64( 0x000000000000000F ).asHex, "0x000000000000000F" )
        XCTAssertEqual( UInt64( 0xF000000000000000 ).asHex, "0xF000000000000000" )
        XCTAssertEqual( UInt64( 0xFFFFFFFFFFFFFFFF ).asHex, "0xFFFFFFFFFFFFFFFF" )
        XCTAssertEqual( UInt64( 0xABCDEF1234567890 ).asHex, "0xABCDEF1234567890" )
    }
}
