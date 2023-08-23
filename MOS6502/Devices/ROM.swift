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
import XSLabsSwift

public protocol ROM: MemoryDevice, CustomStringConvertible
{
    var name: String
    {
        get
    }

    var origin: UInt16
    {
        get
    }

    var data: Data
    {
        get
    }

    var comments: [ UInt16: String ]
    {
        get
    }

    var labels: [ UInt16: String ]
    {
        get
    }
}

public extension ROM
{
    func read( at address: UInt16 ) throws -> UInt8
    {
        if address >= self.data.count
        {
            throw RuntimeError( message: "Address out of bounds: \( address.asHex )" )
        }

        return self.data[ Int( address ) ]
    }

    var description: String
    {
        "ROM - \( self.name )"
    }
}
