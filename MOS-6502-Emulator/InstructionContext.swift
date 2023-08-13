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

public class InstructionContext
{
    public var value: Either< UInt8, () throws -> UInt16 >

    public convenience init()
    {
        self.init( value: .left( 0 ) )
    }

    public convenience init( value: UInt8 )
    {
        self.init( value: .left( value ) )
    }

    public convenience init( value: @escaping () throws -> UInt16 )
    {
        self.init( value: .right( value ) )
    }

    public init( value: Either< UInt8, () throws -> UInt16 > )
    {
        self.value = value
    }

    public func uint8() -> UInt8
    {
        switch self.value
        {
            case .left( let value ): return value
            case .right:             return 0
        }
    }

    public func uint16() throws -> UInt16
    {
        switch self.value
        {
            case .left:               return 0
            case .right( let value ): return try value()
        }
    }
}
