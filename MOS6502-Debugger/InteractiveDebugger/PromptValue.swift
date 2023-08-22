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

public class PromptValue
{
    public private( set ) var string: String

    public init( string: String )
    {
        self.string = string
    }

    public var uint8: UInt8?
    {
        self.numericValue { UInt8( $0, radix: $1 ) }
    }

    public var uint16: UInt16?
    {
        self.numericValue { UInt16( $0, radix: $1 ) }
    }

    public var uint32: UInt32?
    {
        self.numericValue { UInt32( $0, radix: $1 ) }
    }

    public var uint64: UInt64?
    {
        self.numericValue { UInt64( $0, radix: $1 ) }
    }

    public var uint: UInt?
    {
        self.numericValue { UInt( $0, radix: $1 ) }
    }

    public var uint8Array: [ UInt8 ]
    {
        self.numericArray { UInt8( $0, radix: $1 ) }
    }

    public var uint16Array: [ UInt16 ]
    {
        self.numericArray { UInt16( $0, radix: $1 ) }
    }

    public var uint32Array: [ UInt32 ]
    {
        self.numericArray { UInt32( $0, radix: $1 ) }
    }

    public var uint64Array: [ UInt64 ]
    {
        self.numericArray { UInt64( $0, radix: $1 ) }
    }

    public var uintArray: [ UInt ]
    {
        self.numericArray { UInt( $0, radix: $1 ) }
    }

    private func numericValue< T: UnsignedInteger >( initialize: ( String, Int ) -> T? ) -> T?
    {
        let prompt = self.string.trimmingCharacters( in: .whitespaces )

        if prompt.hasPrefix( "0x" )
        {
            let start = prompt.index( prompt.startIndex, offsetBy: 2 )
            let end   = prompt.endIndex

            return initialize( String( prompt[ start ..< end ] ), 16 )
        }
        else if prompt.hasPrefix( "$" )
        {
            let start = prompt.index( prompt.startIndex, offsetBy: 1 )
            let end   = prompt.endIndex

            return initialize( String( prompt[ start ..< end ] ), 16 )
        }

        return initialize( prompt, 10 )
    }

    private func numericArray< T: UnsignedInteger >( initialize: ( String, Int ) -> T? ) -> [ T ]
    {
        let prompt         = self.string.trimmingCharacters( in: .whitespaces ).components( separatedBy: " " )
        let values: [ T? ] = prompt.filter
        {
            $0.trimmingCharacters( in: .whitespaces ).isEmpty == false
        }
        .map
        {
            if $0.hasPrefix( "0x" )
            {
                let start = $0.index( $0.startIndex, offsetBy: 2 )
                let end   = $0.endIndex

                return initialize( String( $0[ start ..< end ] ), 16 )
            }

            return initialize( $0, 10 )
        }

        return values.contains( nil ) ? [] : values.compactMap { $0 }
    }
}
