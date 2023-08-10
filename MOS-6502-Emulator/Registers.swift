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

open class Registers
{
    public var PC: UInt16 = 0
    public var SP: UInt8  = 0
    public var A:  UInt8  = 0
    public var X:  UInt8  = 0
    public var Y:  UInt8  = 0
    public var PS: Flags  = .init( rawValue: 0 )

    public struct Flags: OptionSet
    {
        public static let carryFlag        = Flags( rawValue: 1 << 0 )
        public static let zeroFlag         = Flags( rawValue: 1 << 1 )
        public static let interruptDisable = Flags( rawValue: 1 << 2 )
        public static let decimalMode      = Flags( rawValue: 1 << 3 )
        public static let breakCommand     = Flags( rawValue: 1 << 4 )
        public static let overflowFlag     = Flags( rawValue: 1 << 5 )
        public static let negativeFlag     = Flags( rawValue: 1 << 6 )

        public let rawValue: UInt8

        public init( rawValue: UInt8 )
        {
            self.rawValue = rawValue
        }
    }
}
