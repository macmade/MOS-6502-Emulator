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

import Foundation

open class Memory< SizeType > where SizeType: UnsignedInteger, SizeType: FixedWidthInteger
{
    public struct Options: OptionSet
    {
        public static var wrapAround: Options { Options( rawValue: 1 << 0 ) }

        public let rawValue: Int

        public init( rawValue: Int )
        {
            self.rawValue = rawValue
        }
    }

    public static var max: UInt64
    {
        let max = UInt64( SizeType.max )

        return max < UInt64.max ? max + 1 : max
    }

    public private( set ) var size:    UInt64
    public private( set ) var options: Options

    private var data: UnsafeMutableBufferPointer< UInt8 >

    public init( size: UInt64, options: Options, initializeTo defaultValue: UInt8 ) throws
    {
        if size == 0 || size > Int.max || ( size > Memory< SizeType >.max )
        {
            throw RuntimeError( message: "Invalid memory size: \( size )" )
        }

        self.data    = .allocate( capacity: Int( size ) )
        self.size    = size
        self.options = options

        self.data.initialize( repeating: defaultValue )
    }

    public init( buffer: UnsafeMutableBufferPointer< UInt8 >, options: Options ) throws
    {
        if buffer.count <= 0
        {
            throw RuntimeError( message: "Invalid buffer size: \( buffer.count )" )
        }

        self.data    = .allocate( capacity: buffer.count )
        self.size    = UInt64( buffer.count )
        self.options = options

        _ = self.data.initialize( from: buffer )
    }

    deinit
    {
        self.data.deallocate()
    }

    open func offset( for address: SizeType ) throws -> Int
    {
        if address < self.size
        {
            return Int( address )
        }
        else if self.options.contains( .wrapAround ) == false
        {
            throw RuntimeError( message: "Invalid memory address: \( address.asHex )" )
        }
        else
        {
            var offset = UInt64( address )

            while offset >= self.size
            {
                offset -= self.size
            }

            return Int( offset )
        }
    }

    open func readUInt8( at address: SizeType ) throws -> UInt8
    {
        let offset = try self.offset( for: address )

        return self.data[ offset ]
    }

    open func readUInt16( at address: SizeType ) throws -> UInt16
    {
        let n1 = try UInt16( self.readUInt8( at: address ) )
        let n2 = try UInt16( self.readUInt8( at: address + 1 ) )

        return ( n2 << 8 ) | n1
    }

    open func readUInt32( at address: SizeType ) throws -> UInt32
    {
        let n1 = try UInt32( self.readUInt16( at: address ) )
        let n2 = try UInt32( self.readUInt16( at: address + 2 ) )

        return ( n2 << 16 ) | n1
    }

    open func readUInt64( at address: SizeType ) throws -> UInt64
    {
        let n1 = try UInt64( self.readUInt32( at: address ) )
        let n2 = try UInt64( self.readUInt32( at: address + 4 ) )

        return ( n2 << 32 ) | n1
    }

    open func writeUInt8( _ value: UInt8, at address: SizeType ) throws
    {
        let offset = try self.offset( for: address )

        self.data[ offset ] = value
    }

    open func writeUInt16( _ value: UInt16, at address: SizeType ) throws
    {
        let n1 = UInt8( value & 0xFF )
        let n2 = UInt8( ( value >> 8 ) & 0xFF )

        try self.writeUInt8( n1, at: address )
        try self.writeUInt8( n2, at: address + 1 )
    }

    open func writeUInt32( _ value: UInt32, at address: SizeType ) throws
    {
        let n1 = UInt16( value & 0xFFFF )
        let n2 = UInt16( ( value >> 16 ) & 0xFFFF )

        try self.writeUInt16( n1, at: address )
        try self.writeUInt16( n2, at: address + 2 )
    }

    open func writeUInt64( _ value: UInt64, at address: SizeType ) throws
    {
        let n1 = UInt32( value & 0xFFFFFFFF )
        let n2 = UInt32( ( value >> 32 ) & 0xFFFFFFFF )

        try self.writeUInt32( n1, at: address )
        try self.writeUInt32( n2, at: address + 4 )
    }
}
