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

public class MC6820: WriteableMemoryDevice, LogSource, Resettable, CustomStringConvertible
{
    public var DDRA:   UInt8 = 0 // Data direction register A
    public var DDRB:   UInt8 = 0 // Data direction register B
    public var CRA:    UInt8 = 0 // Control register A
    public var CRB:    UInt8 = 0 // Control register B
    public var ORA:    UInt8 = 0 // Output register A
    public var ORB:    UInt8 = 0 // Output register B
    public var logger: Logger?

    public init()
    {}

    public func reset() throws
    {
        self.DDRA = 0
        self.DDRB = 0
        self.CRA  = 0
        self.CRB  = 0
        self.ORA  = 0
        self.ORB  = 0
    }

    private func register( for address: UInt16 ) throws -> ReferenceWritableKeyPath< MC6820, UInt8 >
    {
        switch address
        {
            case 0: return ( self.CRA & 0x40 ) == 0 ? \.DDRA : \.ORA
            case 1: return                            \.CRA
            case 2: return ( self.CRB & 0x40 ) == 0 ? \.DDRB : \.ORB
            case 3: return                            \.CRA

            default: throw RuntimeError( message: "Invalid MC6820 PIA register address: \( address.asHex )" )
        }
    }

    public func write( _ value: UInt8, at address: UInt16 ) throws
    {
        self[ keyPath: try self.register( for: address ) ] = value
    }

    public func read( at address: UInt16 ) throws -> UInt8
    {
        self[ keyPath: try self.register( for: address ) ]
    }

    public var description: String
    {
        "MC6820 PIA"
    }
}
