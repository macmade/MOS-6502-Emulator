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

public class PIA: WriteableMemoryDevice, LogSource, CustomStringConvertible
{
    public var data0:    UInt8 = 0
    public var control0: UInt8 = 0
    public var data1:    UInt8 = 0
    public var control1: UInt8 = 0
    public var logger:   Logger?

    public init()
    {}

    public func write( _ value: UInt8, at address: UInt16 ) throws
    {
        switch address
        {
            case 0: self.data0    = value
            case 1: self.control0 = value
            case 2: self.data1    = value
            case 3: self.control1 = value

            default: throw RuntimeError( message: "Invalid PIA address: \( address.asHex )" )
        }
    }

    public func read( at address: UInt16 ) throws -> UInt8
    {
        switch address
        {
            case 0: return self.data0
            case 1: return self.control0
            case 2: return self.data1
            case 3: return self.control1

            default: throw RuntimeError( message: "Invalid PIA address: \( address.asHex )" )
        }
    }

    public var description: String
    {
        "PIA"
    }
}
