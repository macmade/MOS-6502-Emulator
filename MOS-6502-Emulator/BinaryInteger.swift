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

public extension BinaryInteger
{
    var bits: [ Bool ]
    {
        ( 0 ..< self.bitWidth ).map
        {
            ( self >> $0 ) & 0x01 == 1
        }
    }

    var bytes: [ UInt8 ]
    {
        switch self.bitWidth
        {
            case 8:  return [ UInt8( self ) ]
            case 16: return [ UInt8( self & 0xFF ), UInt8( ( self >> 8 ) & 0xFF ) ]
            case 32: return [ UInt8( self & 0xFF ), UInt8( ( self >> 8 ) & 0xFF ), UInt8( ( self >> 16 ) & 0xFF ), UInt8( ( self >> 24 ) & 0xFF ) ]
            default: return [ UInt8( self & 0xFF ), UInt8( ( self >> 8 ) & 0xFF ), UInt8( ( self >> 16 ) & 0xFF ), UInt8( ( self >> 24 ) & 0xFF ), UInt8( ( self >> 32 ) & 0xFF ), UInt8( ( self >> 40 ) & 0xFF ), UInt8( ( self >> 48 ) & 0xFF ), UInt8( ( self >> 56 ) & 0xFF ) ]
        }
    }

    var asHex: String
    {
        switch self.bitWidth
        {
            case 8:  return String( format: "0x%02llX",  UInt64( self ) )
            case 16: return String( format: "0x%04llX",  UInt64( self ) )
            case 32: return String( format: "0x%08llX",  UInt64( self ) )
            default: return String( format: "0x%016llX", UInt64( self ) )
        }
    }
}
