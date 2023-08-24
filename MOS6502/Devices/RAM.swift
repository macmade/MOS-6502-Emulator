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

public class RAM: WritableMemoryDevice, LogSource, Resettable, CustomStringConvertible
{
    public enum Capacity
    {
        case b( UInt64 )
        case kb( UInt64 )
        case mb( UInt64 )

        public var bytes: UInt64
        {
            switch self
            {
                case .b( let b ):   return b
                case .kb( let kb ): return kb * 1024
                case .mb( let mb ): return mb * 1024 * 1024
            }
        }
    }

    public var logger: Logger?

    public private( set ) var capacity: Capacity

    private var memory: Memory< UInt16 >

    public init( capacity: Capacity, options: Memory< UInt16 >.Options ) throws
    {
        self.capacity = capacity
        self.memory   = try .init( size: capacity.bytes, options: options, initializeTo: 0 )
    }

    public func reset() throws
    {
        try self.reset( 0x00 )
    }

    public func reset( _ value: UInt8 ) throws
    {
        try self.memory.reset( 0x00 )
    }

    public func read( at address: UInt16 ) throws -> UInt8
    {
        try self.memory.readUInt8( at: address )
    }

    public func write( _ value: UInt8, at address: UInt16 ) throws
    {
        try self.memory.writeUInt8( value, at: address )
    }

    public var description: String
    {
        "RAM"
    }
}
