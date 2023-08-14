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

final class Test_Memory: XCTestCase
{
    func testInitSizeZero() throws
    {
        XCTAssertThrowsError( _ = try Memory< UInt64 >( size: 0, options: [], initializeTo: 0 ) )
    }

    func testInitBufferZero() throws
    {
        let buffer = UnsafeMutableBufferPointer< UInt8 >.allocate( capacity: 0 )

        defer
        {
            buffer.deallocate()
        }

        XCTAssertThrowsError( _ = try Memory< UInt64 >( buffer: buffer, options: [] ) )
    }

    func testInitSizeTooLarge() throws
    {
        XCTAssertThrowsError( _ = try Memory< UInt64 >( size: UInt64( Int.max    ) + 1, options: [], initializeTo: 0 ) )
        XCTAssertThrowsError( _ = try Memory< UInt16 >( size: UInt64( UInt16.max ) + 2, options: [], initializeTo: 0 ) )
        XCTAssertNoThrow(     _ = try Memory< UInt16 >( size: UInt64( UInt16.max ) + 1, options: [], initializeTo: 0 ) )
    }

    func testInitSize() throws
    {
        let memory1 = try Memory< UInt64 >( size: 1024, options: [], initializeTo: 0 )
        let memory2 = try Memory< UInt64 >( size: 2048, options: [ .wrapAround ], initializeTo: 42 )

        XCTAssertEqual( memory1.size, 1024 )
        XCTAssertEqual( memory2.size, 2048 )

        XCTAssertFalse( memory1.options.contains( .wrapAround ) )
        XCTAssertTrue(  memory2.options.contains( .wrapAround ) )

        XCTAssertEqual( try memory1.readUInt8( at: 0 ), 0 )
        XCTAssertEqual( try memory2.readUInt8( at: 0 ), 42 )
    }

    func testInitBuffer() throws
    {
        let buffer1 = UnsafeMutableBufferPointer< UInt8 >.allocate( capacity: 1024 )
        let buffer2 = UnsafeMutableBufferPointer< UInt8 >.allocate( capacity: 2048 )

        defer
        {
            buffer1.deallocate()
            buffer2.deallocate()
        }

        buffer1[ 0 ] = 0x01
        buffer2[ 0 ] = 0x42

        let memory1 = try Memory< UInt64 >( buffer: buffer1, options: [] )
        let memory2 = try Memory< UInt64 >( buffer: buffer2, options: [ .wrapAround ] )

        XCTAssertEqual( memory1.size, 1024 )
        XCTAssertEqual( memory2.size, 2048 )

        XCTAssertFalse( memory1.options.contains( .wrapAround ) )
        XCTAssertTrue(  memory2.options.contains( .wrapAround ) )

        XCTAssertEqual( try memory1.readUInt8( at: 0 ), 0x01 )
        XCTAssertEqual( try memory2.readUInt8( at: 0 ), 0x42 )
    }

    func testReadUInt8() throws
    {
        let buffer = UnsafeMutableBufferPointer< UInt8 >.allocate( capacity: 3 )

        defer
        {
            buffer.deallocate()
        }

        buffer[ 0 ] = 0x01
        buffer[ 1 ] = 0x02
        buffer[ 2 ] = 0x03

        let memory = try Memory< UInt64 >( buffer: buffer, options: [] )

        XCTAssertEqual( try memory.readUInt8( at: 0 ), 0x01 )
        XCTAssertEqual( try memory.readUInt8( at: 1 ), 0x02 )
        XCTAssertEqual( try memory.readUInt8( at: 2 ), 0x03 )
    }

    func testReadUInt8Overflow() throws
    {
        let buffer = UnsafeMutableBufferPointer< UInt8 >.allocate( capacity: 1 )

        defer
        {
            buffer.deallocate()
        }

        buffer[ 0 ] = 0x01

        let memory = try Memory< UInt64 >( buffer: buffer, options: [] )

        XCTAssertEqual(       try memory.readUInt8( at: 0 ), 0x01 )
        XCTAssertThrowsError( try memory.readUInt8( at: UInt64( buffer.count ) ) )
    }

    func testReadUInt8OverflowWrap() throws
    {
        let buffer = UnsafeMutableBufferPointer< UInt8 >.allocate( capacity: 3 )

        defer
        {
            buffer.deallocate()
        }

        buffer[ 0 ] = 0x01
        buffer[ 1 ] = 0x02
        buffer[ 2 ] = 0x03

        let memory = try Memory< UInt64 >( buffer: buffer, options: [ .wrapAround ] )

        XCTAssertEqual( try memory.readUInt8( at: 0 ), 0x01 )
        XCTAssertEqual( try memory.readUInt8( at: 1 ), 0x02 )
        XCTAssertEqual( try memory.readUInt8( at: 2 ), 0x03 )

        XCTAssertEqual( try memory.readUInt8( at: 3 ), 0x01 )
        XCTAssertEqual( try memory.readUInt8( at: 4 ), 0x02 )
        XCTAssertEqual( try memory.readUInt8( at: 5 ), 0x03 )

        XCTAssertEqual( try memory.readUInt8( at: 6 ), 0x01 )
        XCTAssertEqual( try memory.readUInt8( at: 7 ), 0x02 )
        XCTAssertEqual( try memory.readUInt8( at: 8 ), 0x03 )
    }

    func testReadUInt16() throws
    {
        let buffer = UnsafeMutableBufferPointer< UInt8 >.allocate( capacity: 3 * 2 )

        defer
        {
            buffer.deallocate()
        }

        buffer[ 0 ] = 0x01
        buffer[ 1 ] = 0x42
        buffer[ 2 ] = 0x02
        buffer[ 3 ] = 0x42
        buffer[ 4 ] = 0x03
        buffer[ 5 ] = 0x42

        let memory = try Memory< UInt64 >( buffer: buffer, options: [] )

        XCTAssertEqual( try memory.readUInt16( at: 0 * 2 ), UInt16( 0x4201 ) )
        XCTAssertEqual( try memory.readUInt16( at: 1 * 2 ), UInt16( 0x4202 ) )
        XCTAssertEqual( try memory.readUInt16( at: 2 * 2 ), UInt16( 0x4203 ) )
    }

    func testReadUInt16Overflow() throws
    {
        let buffer = UnsafeMutableBufferPointer< UInt8 >.allocate( capacity: 1 * 2 )

        defer
        {
            buffer.deallocate()
        }

        buffer[ 0 ] = 0x001
        buffer[ 1 ] = 0x042

        let memory = try Memory< UInt64 >( buffer: buffer, options: [] )

        XCTAssertEqual(       try memory.readUInt16( at: 0 * 2 ), UInt16( 0x4201 ) )
        XCTAssertThrowsError( try memory.readUInt16( at: UInt64( buffer.count ) - 1 ) )
        XCTAssertThrowsError( try memory.readUInt16( at: UInt64( buffer.count ) ) )
    }

    func testReadUInt16OverflowWrap() throws
    {
        let buffer = UnsafeMutableBufferPointer< UInt8 >.allocate( capacity: 3 * 2 )

        defer
        {
            buffer.deallocate()
        }

        buffer[ 0 ] = 0x01
        buffer[ 1 ] = 0x42
        buffer[ 2 ] = 0x02
        buffer[ 3 ] = 0x42
        buffer[ 4 ] = 0x03
        buffer[ 5 ] = 0x42

        let memory = try Memory< UInt64 >( buffer: buffer, options: [ .wrapAround ] )

        XCTAssertEqual( try memory.readUInt16( at: 0 * 2 ), UInt16( 0x4201 ) )
        XCTAssertEqual( try memory.readUInt16( at: 1 * 2 ), UInt16( 0x4202 ) )
        XCTAssertEqual( try memory.readUInt16( at: 2 * 2 ), UInt16( 0x4203 ) )

        XCTAssertEqual( try memory.readUInt16( at: 3 * 2 ), UInt16( 0x4201 ) )
        XCTAssertEqual( try memory.readUInt16( at: 4 * 2 ), UInt16( 0x4202 ) )
        XCTAssertEqual( try memory.readUInt16( at: 5 * 2 ), UInt16( 0x4203 ) )

        XCTAssertEqual( try memory.readUInt16( at: 6 * 2 ), UInt16( 0x4201 ) )
        XCTAssertEqual( try memory.readUInt16( at: 7 * 2 ), UInt16( 0x4202 ) )
        XCTAssertEqual( try memory.readUInt16( at: 8 * 2 ), UInt16( 0x4203 ) )
    }

    func testReadUInt32() throws
    {
        let buffer = UnsafeMutableBufferPointer< UInt8 >.allocate( capacity: 3 * 4 )

        defer
        {
            buffer.deallocate()
        }

        buffer[  0 ] = 0x01
        buffer[  1 ] = 0x42
        buffer[  2 ] = 0x43
        buffer[  3 ] = 0x44
        buffer[  4 ] = 0x02
        buffer[  5 ] = 0x42
        buffer[  6 ] = 0x43
        buffer[  7 ] = 0x44
        buffer[  8 ] = 0x03
        buffer[  9 ] = 0x42
        buffer[ 10 ] = 0x43
        buffer[ 11 ] = 0x44

        let memory = try Memory< UInt64 >( buffer: buffer, options: [] )

        XCTAssertEqual( try memory.readUInt32( at: 0 * 4 ), UInt32( 0x44434201 ) )
        XCTAssertEqual( try memory.readUInt32( at: 1 * 4 ), UInt32( 0x44434202 ) )
        XCTAssertEqual( try memory.readUInt32( at: 2 * 4 ), UInt32( 0x44434203 ) )
    }

    func testReadUInt32Overflow() throws
    {
        let buffer = UnsafeMutableBufferPointer< UInt8 >.allocate( capacity: 1 * 4 )

        defer
        {
            buffer.deallocate()
        }

        buffer[ 0 ] = 0x01
        buffer[ 1 ] = 0x42
        buffer[ 2 ] = 0x43
        buffer[ 3 ] = 0x44

        let memory = try Memory< UInt64 >( buffer: buffer, options: [] )

        XCTAssertEqual(       try memory.readUInt32( at: 0 * 4 ), UInt32( 0x44434201 ) )
        XCTAssertThrowsError( try memory.readUInt32( at: UInt64( buffer.count ) - 1 ) )
        XCTAssertThrowsError( try memory.readUInt32( at: UInt64( buffer.count ) - 2 ) )
        XCTAssertThrowsError( try memory.readUInt32( at: UInt64( buffer.count ) - 3 ) )
        XCTAssertThrowsError( try memory.readUInt32( at: UInt64( buffer.count ) ) )
    }

    func testReadUInt32OverflowWrap() throws
    {
        let buffer = UnsafeMutableBufferPointer< UInt8 >.allocate( capacity: 3 * 4 )

        defer
        {
            buffer.deallocate()
        }

        buffer[  0 ] = 0x01
        buffer[  1 ] = 0x42
        buffer[  2 ] = 0x43
        buffer[  3 ] = 0x44
        buffer[  4 ] = 0x02
        buffer[  5 ] = 0x42
        buffer[  6 ] = 0x43
        buffer[  7 ] = 0x44
        buffer[  8 ] = 0x03
        buffer[  9 ] = 0x42
        buffer[ 10 ] = 0x43
        buffer[ 11 ] = 0x44

        let memory = try Memory< UInt64 >( buffer: buffer, options: [ .wrapAround ] )

        XCTAssertEqual( try memory.readUInt32( at: 0 * 4 ), UInt32( 0x44434201 ) )
        XCTAssertEqual( try memory.readUInt32( at: 1 * 4 ), UInt32( 0x44434202 ) )
        XCTAssertEqual( try memory.readUInt32( at: 2 * 4 ), UInt32( 0x44434203 ) )

        XCTAssertEqual( try memory.readUInt32( at: 3 * 4 ), UInt32( 0x44434201 ) )
        XCTAssertEqual( try memory.readUInt32( at: 4 * 4 ), UInt32( 0x44434202 ) )
        XCTAssertEqual( try memory.readUInt32( at: 5 * 4 ), UInt32( 0x44434203 ) )

        XCTAssertEqual( try memory.readUInt32( at: 6 * 4 ), UInt32( 0x44434201 ) )
        XCTAssertEqual( try memory.readUInt32( at: 7 * 4 ), UInt32( 0x44434202 ) )
        XCTAssertEqual( try memory.readUInt32( at: 8 * 4 ), UInt32( 0x44434203 ) )
    }

    func testReadUInt64() throws
    {
        let buffer = UnsafeMutableBufferPointer< UInt8 >.allocate( capacity: 3 * 8 )

        defer
        {
            buffer.deallocate()
        }

        buffer[  0 ] = 0x01
        buffer[  1 ] = 0x42
        buffer[  2 ] = 0x43
        buffer[  3 ] = 0x44
        buffer[  4 ] = 0x45
        buffer[  5 ] = 0x46
        buffer[  6 ] = 0x47
        buffer[  7 ] = 0x48
        buffer[  8 ] = 0x02
        buffer[  9 ] = 0x42
        buffer[ 10 ] = 0x43
        buffer[ 11 ] = 0x44
        buffer[ 12 ] = 0x45
        buffer[ 13 ] = 0x46
        buffer[ 14 ] = 0x47
        buffer[ 15 ] = 0x48
        buffer[ 16 ] = 0x03
        buffer[ 17 ] = 0x42
        buffer[ 18 ] = 0x43
        buffer[ 19 ] = 0x44
        buffer[ 20 ] = 0x45
        buffer[ 21 ] = 0x46
        buffer[ 22 ] = 0x47
        buffer[ 23 ] = 0x48

        let memory = try Memory< UInt64 >( buffer: buffer, options: [] )

        XCTAssertEqual( try memory.readUInt64( at: 0 * 8 ), UInt64( 0x4847464544434201 ) )
        XCTAssertEqual( try memory.readUInt64( at: 1 * 8 ), UInt64( 0x4847464544434202 ) )
        XCTAssertEqual( try memory.readUInt64( at: 2 * 8 ), UInt64( 0x4847464544434203 ) )
    }

    func testReadUInt64Overflow() throws
    {
        let buffer = UnsafeMutableBufferPointer< UInt8 >.allocate( capacity: 1 * 8 )

        defer
        {
            buffer.deallocate()
        }

        buffer[ 0 ] = 0x01
        buffer[ 1 ] = 0x42
        buffer[ 2 ] = 0x43
        buffer[ 3 ] = 0x44
        buffer[ 4 ] = 0x45
        buffer[ 5 ] = 0x46
        buffer[ 6 ] = 0x47
        buffer[ 7 ] = 0x48

        let memory = try Memory< UInt64 >( buffer: buffer, options: [] )

        XCTAssertEqual(       try memory.readUInt64( at: 0 * 8 ), UInt64( 0x4847464544434201 ) )
        XCTAssertThrowsError( try memory.readUInt64( at: UInt64( buffer.count ) - 1 ) )
        XCTAssertThrowsError( try memory.readUInt64( at: UInt64( buffer.count ) - 2 ) )
        XCTAssertThrowsError( try memory.readUInt64( at: UInt64( buffer.count ) - 3 ) )
        XCTAssertThrowsError( try memory.readUInt64( at: UInt64( buffer.count ) - 4 ) )
        XCTAssertThrowsError( try memory.readUInt64( at: UInt64( buffer.count ) - 5 ) )
        XCTAssertThrowsError( try memory.readUInt64( at: UInt64( buffer.count ) - 6 ) )
        XCTAssertThrowsError( try memory.readUInt64( at: UInt64( buffer.count ) - 7 ) )
        XCTAssertThrowsError( try memory.readUInt64( at: UInt64( buffer.count ) ) )
    }

    func testReadUInt64OverflowWrap() throws
    {
        let buffer = UnsafeMutableBufferPointer< UInt8 >.allocate( capacity: 3 * 8 )

        defer
        {
            buffer.deallocate()
        }

        buffer[  0 ] = 0x01
        buffer[  1 ] = 0x42
        buffer[  2 ] = 0x43
        buffer[  3 ] = 0x44
        buffer[  4 ] = 0x45
        buffer[  5 ] = 0x46
        buffer[  6 ] = 0x47
        buffer[  7 ] = 0x48
        buffer[  8 ] = 0x02
        buffer[  9 ] = 0x42
        buffer[ 10 ] = 0x43
        buffer[ 11 ] = 0x44
        buffer[ 12 ] = 0x45
        buffer[ 13 ] = 0x46
        buffer[ 14 ] = 0x47
        buffer[ 15 ] = 0x48
        buffer[ 16 ] = 0x03
        buffer[ 17 ] = 0x42
        buffer[ 18 ] = 0x43
        buffer[ 19 ] = 0x44
        buffer[ 20 ] = 0x45
        buffer[ 21 ] = 0x46
        buffer[ 22 ] = 0x47
        buffer[ 23 ] = 0x48

        let memory = try Memory< UInt64 >( buffer: buffer, options: [ .wrapAround ] )

        XCTAssertEqual( try memory.readUInt64( at: 0 * 8 ), UInt64( 0x4847464544434201 ) )
        XCTAssertEqual( try memory.readUInt64( at: 1 * 8 ), UInt64( 0x4847464544434202 ) )
        XCTAssertEqual( try memory.readUInt64( at: 2 * 8 ), UInt64( 0x4847464544434203 ) )

        XCTAssertEqual( try memory.readUInt64( at: 3 * 8 ), UInt64( 0x4847464544434201 ) )
        XCTAssertEqual( try memory.readUInt64( at: 4 * 8 ), UInt64( 0x4847464544434202 ) )
        XCTAssertEqual( try memory.readUInt64( at: 5 * 8 ), UInt64( 0x4847464544434203 ) )

        XCTAssertEqual( try memory.readUInt64( at: 6 * 8 ), UInt64( 0x4847464544434201 ) )
        XCTAssertEqual( try memory.readUInt64( at: 7 * 8 ), UInt64( 0x4847464544434202 ) )
        XCTAssertEqual( try memory.readUInt64( at: 8 * 8 ), UInt64( 0x4847464544434203 ) )
    }

    func testWriteUInt8() throws
    {
        let memory = try Memory< UInt64 >( size: 3, options: [], initializeTo: 0 )

        XCTAssertEqual( try memory.readUInt8( at: 0 ), 0 )
        XCTAssertEqual( try memory.readUInt8( at: 1 ), 0 )
        XCTAssertEqual( try memory.readUInt8( at: 2 ), 0 )

        XCTAssertNoThrow( try memory.writeUInt8( 0x42, at: 0 ) )
        XCTAssertNoThrow( try memory.writeUInt8( 0x43, at: 1 ) )
        XCTAssertNoThrow( try memory.writeUInt8( 0x44, at: 2 ) )

        XCTAssertEqual( try memory.readUInt8( at: 0 ), 0x42 )
        XCTAssertEqual( try memory.readUInt8( at: 1 ), 0x43 )
        XCTAssertEqual( try memory.readUInt8( at: 2 ), 0x44 )
    }

    func testWriteUInt8Overflow() throws
    {
        let memory = try Memory< UInt64 >( size: 1, options: [], initializeTo: 0 )

        XCTAssertEqual( try memory.readUInt8( at: 0 ), 0 )

        XCTAssertNoThrow(     try memory.writeUInt8( 0x42, at: 0 ) )
        XCTAssertThrowsError( try memory.writeUInt8( 0x43, at: 1 ) )

        XCTAssertEqual( try memory.readUInt8( at: 0 ), 0x42 )
    }

    func testWriteUInt8OverflowWrap() throws
    {
        let memory = try Memory< UInt64 >( size: 3, options: [ .wrapAround ], initializeTo: 0 )

        XCTAssertEqual( try memory.readUInt8( at: 0 ), 0 )
        XCTAssertEqual( try memory.readUInt8( at: 1 ), 0 )
        XCTAssertEqual( try memory.readUInt8( at: 2 ), 0 )

        XCTAssertNoThrow( try memory.writeUInt8( 0x42, at: 0 ) )
        XCTAssertNoThrow( try memory.writeUInt8( 0x43, at: 1 ) )
        XCTAssertNoThrow( try memory.writeUInt8( 0x44, at: 2 ) )

        XCTAssertEqual( try memory.readUInt8( at: 0 ), 0x42 )
        XCTAssertEqual( try memory.readUInt8( at: 1 ), 0x43 )
        XCTAssertEqual( try memory.readUInt8( at: 2 ), 0x44 )

        XCTAssertNoThrow( try memory.writeUInt8( 0x45, at: 3 ) )
        XCTAssertNoThrow( try memory.writeUInt8( 0x46, at: 4 ) )
        XCTAssertNoThrow( try memory.writeUInt8( 0x47, at: 5 ) )

        XCTAssertEqual( try memory.readUInt8( at: 0 ), 0x45 )
        XCTAssertEqual( try memory.readUInt8( at: 1 ), 0x46 )
        XCTAssertEqual( try memory.readUInt8( at: 2 ), 0x47 )

        XCTAssertNoThrow( try memory.writeUInt8( 0x48, at: 6 ) )
        XCTAssertNoThrow( try memory.writeUInt8( 0x49, at: 7 ) )
        XCTAssertNoThrow( try memory.writeUInt8( 0x4A, at: 8 ) )

        XCTAssertEqual( try memory.readUInt8( at: 0 ), 0x48 )
        XCTAssertEqual( try memory.readUInt8( at: 1 ), 0x49 )
        XCTAssertEqual( try memory.readUInt8( at: 2 ), 0x4A )
    }

    func testWriteUInt16() throws
    {
        let memory = try Memory< UInt64 >( size: 3 * 2, options: [], initializeTo: 0 )

        XCTAssertEqual( try memory.readUInt16( at: 0 * 2 ), 0 )
        XCTAssertEqual( try memory.readUInt16( at: 1 * 2 ), 0 )
        XCTAssertEqual( try memory.readUInt16( at: 2 * 2 ), 0 )

        XCTAssertNoThrow( try memory.writeUInt16( 0x42, at: 0 * 2 ) )
        XCTAssertNoThrow( try memory.writeUInt16( 0x43, at: 1 * 2 ) )
        XCTAssertNoThrow( try memory.writeUInt16( 0x44, at: 2 * 2 ) )

        XCTAssertEqual( try memory.readUInt16( at: 0 * 2 ), 0x42 )
        XCTAssertEqual( try memory.readUInt16( at: 1 * 2 ), 0x43 )
        XCTAssertEqual( try memory.readUInt16( at: 2 * 2 ), 0x44 )
    }

    func testWriteUInt16Overflow() throws
    {
        let memory = try Memory< UInt64 >( size: 1 * 2, options: [], initializeTo: 0 )

        XCTAssertEqual( try memory.readUInt16( at: 0 ), 0 )

        XCTAssertNoThrow(     try memory.writeUInt16( 0x42, at: 0 * 2 ) )
        XCTAssertThrowsError( try memory.writeUInt16( 0x43, at: 1 * 2 ) )

        XCTAssertEqual( try memory.readUInt16( at: 0 * 2 ), 0x42 )
    }

    func testWriteUInt16OverflowWrap() throws
    {
        let memory = try Memory< UInt64 >( size: 3 * 2, options: [ .wrapAround ], initializeTo: 0 )

        XCTAssertEqual( try memory.readUInt16( at: 0 * 2 ), 0 )
        XCTAssertEqual( try memory.readUInt16( at: 1 * 2 ), 0 )
        XCTAssertEqual( try memory.readUInt16( at: 2 * 2 ), 0 )

        XCTAssertNoThrow( try memory.writeUInt16( 0x42, at: 0 * 2 ) )
        XCTAssertNoThrow( try memory.writeUInt16( 0x43, at: 1 * 2 ) )
        XCTAssertNoThrow( try memory.writeUInt16( 0x44, at: 2 * 2 ) )

        XCTAssertEqual( try memory.readUInt16( at: 0 * 2 ), 0x42 )
        XCTAssertEqual( try memory.readUInt16( at: 1 * 2 ), 0x43 )
        XCTAssertEqual( try memory.readUInt16( at: 2 * 2 ), 0x44 )

        XCTAssertNoThrow( try memory.writeUInt16( 0x45, at: 3 * 2 ) )
        XCTAssertNoThrow( try memory.writeUInt16( 0x46, at: 4 * 2 ) )
        XCTAssertNoThrow( try memory.writeUInt16( 0x47, at: 5 * 2 ) )

        XCTAssertEqual( try memory.readUInt16( at: 0 * 2 ), 0x45 )
        XCTAssertEqual( try memory.readUInt16( at: 1 * 2 ), 0x46 )
        XCTAssertEqual( try memory.readUInt16( at: 2 * 2 ), 0x47 )

        XCTAssertNoThrow( try memory.writeUInt16( 0x48, at: 6 * 2 ) )
        XCTAssertNoThrow( try memory.writeUInt16( 0x49, at: 7 * 2 ) )
        XCTAssertNoThrow( try memory.writeUInt16( 0x4A, at: 8 * 2 ) )

        XCTAssertEqual( try memory.readUInt16( at: 0 * 2 ), 0x48 )
        XCTAssertEqual( try memory.readUInt16( at: 1 * 2 ), 0x49 )
        XCTAssertEqual( try memory.readUInt16( at: 2 * 2 ), 0x4A )
    }

    func testWriteUInt32() throws
    {
        let memory = try Memory< UInt64 >( size: 3 * 4, options: [], initializeTo: 0 )

        XCTAssertEqual( try memory.readUInt32( at: 0 * 4 ), 0 )
        XCTAssertEqual( try memory.readUInt32( at: 1 * 4 ), 0 )
        XCTAssertEqual( try memory.readUInt32( at: 2 * 4 ), 0 )

        XCTAssertNoThrow( try memory.writeUInt32( 0x42, at: 0 * 4 ) )
        XCTAssertNoThrow( try memory.writeUInt32( 0x43, at: 1 * 4 ) )
        XCTAssertNoThrow( try memory.writeUInt32( 0x44, at: 2 * 4 ) )

        XCTAssertEqual( try memory.readUInt32( at: 0 * 4 ), 0x42 )
        XCTAssertEqual( try memory.readUInt32( at: 1 * 4 ), 0x43 )
        XCTAssertEqual( try memory.readUInt32( at: 2 * 4 ), 0x44 )
    }

    func testWriteUInt32Overflow() throws
    {
        let memory = try Memory< UInt64 >( size: 1 * 4, options: [], initializeTo: 0 )

        XCTAssertEqual( try memory.readUInt32( at: 0 ), 0 )

        XCTAssertNoThrow(     try memory.writeUInt32( 0x42, at: 0 * 4 ) )
        XCTAssertThrowsError( try memory.writeUInt32( 0x43, at: 1 * 4 ) )

        XCTAssertEqual( try memory.readUInt32( at: 0 * 4 ), 0x42 )
    }

    func testWriteUInt32OverflowWrap() throws
    {
        let memory = try Memory< UInt64 >( size: 3 * 4, options: [ .wrapAround ], initializeTo: 0 )

        XCTAssertEqual( try memory.readUInt32( at: 0 * 4 ), 0 )
        XCTAssertEqual( try memory.readUInt32( at: 1 * 4 ), 0 )
        XCTAssertEqual( try memory.readUInt32( at: 2 * 4 ), 0 )

        XCTAssertNoThrow( try memory.writeUInt32( 0x42, at: 0 * 4 ) )
        XCTAssertNoThrow( try memory.writeUInt32( 0x43, at: 1 * 4 ) )
        XCTAssertNoThrow( try memory.writeUInt32( 0x44, at: 2 * 4 ) )

        XCTAssertEqual( try memory.readUInt32( at: 0 * 4 ), 0x42 )
        XCTAssertEqual( try memory.readUInt32( at: 1 * 4 ), 0x43 )
        XCTAssertEqual( try memory.readUInt32( at: 2 * 4 ), 0x44 )

        XCTAssertNoThrow( try memory.writeUInt32( 0x45, at: 3 * 4 ) )
        XCTAssertNoThrow( try memory.writeUInt32( 0x46, at: 4 * 4 ) )
        XCTAssertNoThrow( try memory.writeUInt32( 0x47, at: 5 * 4 ) )

        XCTAssertEqual( try memory.readUInt32( at: 0 * 4 ), 0x45 )
        XCTAssertEqual( try memory.readUInt32( at: 1 * 4 ), 0x46 )
        XCTAssertEqual( try memory.readUInt32( at: 2 * 4 ), 0x47 )

        XCTAssertNoThrow( try memory.writeUInt32( 0x48, at: 6 * 4 ) )
        XCTAssertNoThrow( try memory.writeUInt32( 0x49, at: 7 * 4 ) )
        XCTAssertNoThrow( try memory.writeUInt32( 0x4A, at: 8 * 4 ) )

        XCTAssertEqual( try memory.readUInt32( at: 0 * 4 ), 0x48 )
        XCTAssertEqual( try memory.readUInt32( at: 1 * 4 ), 0x49 )
        XCTAssertEqual( try memory.readUInt32( at: 2 * 4 ), 0x4A )
    }

    func testWriteUInt64() throws
    {
        let memory = try Memory< UInt64 >( size: 3 * 8, options: [], initializeTo: 0 )

        XCTAssertEqual( try memory.readUInt64( at: 0 * 8 ), 0 )
        XCTAssertEqual( try memory.readUInt64( at: 1 * 8 ), 0 )
        XCTAssertEqual( try memory.readUInt64( at: 2 * 8 ), 0 )

        XCTAssertNoThrow( try memory.writeUInt64( 0x42, at: 0 * 8 ) )
        XCTAssertNoThrow( try memory.writeUInt64( 0x43, at: 1 * 8 ) )
        XCTAssertNoThrow( try memory.writeUInt64( 0x44, at: 2 * 8 ) )

        XCTAssertEqual( try memory.readUInt64( at: 0 * 8 ), 0x42 )
        XCTAssertEqual( try memory.readUInt64( at: 1 * 8 ), 0x43 )
        XCTAssertEqual( try memory.readUInt64( at: 2 * 8 ), 0x44 )
    }

    func testWriteUInt64Overflow() throws
    {
        let memory = try Memory< UInt64 >( size: 1 * 8, options: [], initializeTo: 0 )

        XCTAssertEqual( try memory.readUInt64( at: 0 ), 0 )

        XCTAssertNoThrow(     try memory.writeUInt64( 0x42, at: 0 * 8 ) )
        XCTAssertThrowsError( try memory.writeUInt64( 0x43, at: 1 * 8 ) )

        XCTAssertEqual( try memory.readUInt64( at: 0 * 8 ), 0x42 )
    }

    func testWriteUInt64OverflowWrap() throws
    {
        let memory = try Memory< UInt64 >( size: 3 * 8, options: [ .wrapAround ], initializeTo: 0 )

        XCTAssertEqual( try memory.readUInt64( at: 0 * 8 ), 0 )
        XCTAssertEqual( try memory.readUInt64( at: 1 * 8 ), 0 )
        XCTAssertEqual( try memory.readUInt64( at: 2 * 8 ), 0 )

        XCTAssertNoThrow( try memory.writeUInt64( 0x42, at: 0 * 8 ) )
        XCTAssertNoThrow( try memory.writeUInt64( 0x43, at: 1 * 8 ) )
        XCTAssertNoThrow( try memory.writeUInt64( 0x44, at: 2 * 8 ) )

        XCTAssertEqual( try memory.readUInt64( at: 0 * 8 ), 0x42 )
        XCTAssertEqual( try memory.readUInt64( at: 1 * 8 ), 0x43 )
        XCTAssertEqual( try memory.readUInt64( at: 2 * 8 ), 0x44 )

        XCTAssertNoThrow( try memory.writeUInt64( 0x45, at: 3 * 8 ) )
        XCTAssertNoThrow( try memory.writeUInt64( 0x46, at: 4 * 8 ) )
        XCTAssertNoThrow( try memory.writeUInt64( 0x47, at: 5 * 8 ) )

        XCTAssertEqual( try memory.readUInt64( at: 0 * 8 ), 0x45 )
        XCTAssertEqual( try memory.readUInt64( at: 1 * 8 ), 0x46 )
        XCTAssertEqual( try memory.readUInt64( at: 2 * 8 ), 0x47 )

        XCTAssertNoThrow( try memory.writeUInt64( 0x48, at: 6 * 8 ) )
        XCTAssertNoThrow( try memory.writeUInt64( 0x49, at: 7 * 8 ) )
        XCTAssertNoThrow( try memory.writeUInt64( 0x4A, at: 8 * 8 ) )

        XCTAssertEqual( try memory.readUInt64( at: 0 * 8 ), 0x48 )
        XCTAssertEqual( try memory.readUInt64( at: 1 * 8 ), 0x49 )
        XCTAssertEqual( try memory.readUInt64( at: 2 * 8 ), 0x4A )
    }
}
