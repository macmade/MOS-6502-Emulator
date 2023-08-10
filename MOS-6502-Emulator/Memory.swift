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

open class Memory
{
    public struct Options: OptionSet
    {
        public static let wrapAround = Options( rawValue: 1 << 0 )

        public let rawValue: Int

        public init( rawValue: Int )
        {
            self.rawValue = rawValue
        }
    }

    public private( set ) var size:    UInt64
    public private( set ) var options: Options

    private var data: UnsafeMutableBufferPointer< UInt8 >

    public init( size: UInt64, options: Options, initializeTo defaultValue: UInt8 ) throws
    {
        if size == 0 || size > Int.max
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

        _ = self.data.initialize( fromContentsOf: buffer )
    }

    deinit
    {
        self.data.deallocate()
    }

    open func offset( for address: UInt64 ) throws -> Int
    {
        if address < self.size
        {
            return Int( address )
        }
        else if self.options.contains( .wrapAround ) == false
        {
            throw RuntimeError( message: "Invalid memory address: \( address )" )
        }
        else
        {
            var offset = address

            while offset >= self.size
            {
                offset -= self.size
            }

            return Int( offset )
        }
    }

    open func readUInt8( at address: UInt64 ) throws -> UInt8
    {
        let offset = try self.offset( for: address )

        return self.data[ offset ]
    }

    open func readUInt16( at address: UInt64 ) throws -> UInt16
    {
        let n1 = try UInt16( self.readUInt8( at: address ) )
        let n2 = try UInt16( self.readUInt8( at: address + 1 ) )

        return ( n2 << 8 ) | n1
    }

    open func readUInt32( at address: UInt64 ) throws -> UInt32
    {
        let n1 = try UInt32( self.readUInt16( at: address ) )
        let n2 = try UInt32( self.readUInt16( at: address + 2 ) )

        return ( n2 << 16 ) | n1
    }

    open func readUInt64( at address: UInt64 ) throws -> UInt64
    {
        let n1 = try UInt64( self.readUInt32( at: address ) )
        let n2 = try UInt64( self.readUInt32( at: address + 4 ) )

        return ( n2 << 32 ) | n1
    }

    open func writeUInt8( _ byte: UInt8, at address: UInt64 ) throws
    {
        let offset = try self.offset( for: address )

        self.data[ offset ] = byte
    }

    open func writeUInt16( _ byte: UInt16, at address: UInt64 ) throws
    {
        let n1 = UInt8( byte & 0xFF )
        let n2 = UInt8( ( byte >> 8 ) & 0xFF )

        try self.writeUInt8( n1, at: address )
        try self.writeUInt8( n2, at: address + 1 )
    }

    open func writeUInt32( _ byte: UInt32, at address: UInt64 ) throws
    {
        let n1 = UInt16( byte & 0xFFFF )
        let n2 = UInt16( ( byte >> 16 ) & 0xFFFF )

        try self.writeUInt16( n1, at: address )
        try self.writeUInt16( n2, at: address + 2 )
    }

    open func writeUInt64( _ byte: UInt64, at address: UInt64 ) throws
    {
        let n1 = UInt32( byte & 0xFFFFFFFF )
        let n2 = UInt32( ( byte >> 32 ) & 0xFFFFFFFF )

        try self.writeUInt32( n1, at: address )
        try self.writeUInt32( n2, at: address + 4 )
    }
}
