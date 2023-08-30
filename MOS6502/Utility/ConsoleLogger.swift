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

public class ConsoleLogger: Logger
{
    public var shouldLog: ( ( String ) -> Bool )?

    public init()
    {}

    public func log( text: String )
    {
        if self.shouldLog?( text ) ?? true
        {
            print( text )
        }
    }

    public func logInstruction( address: UInt16, bytes: [ UInt8 ], disassembly: String, registers: Registers, clock: UInt64, label: String?, comment: String? )
    {
        let address     = String( format: "%04X", address )
        let bytes       = bytes.map { String( format: "%02X", $0 ) }.joined( separator: " " ).padding( toLength: 8, withPad: " ", startingAt: 0 )
        let a           = String( format: "%02X", registers.A )
        let x           = String( format: "%02X", registers.X )
        let y           = String( format: "%02X", registers.Y )
        let p           = String( format: "%02X", registers.P.rawValue )
        let sp          = String( format: "%02X", registers.SP )
        let instruction = "\( address )  \( bytes )  \( disassembly )".padding( toLength: 48, withPad: " ", startingAt: 0 )
        let registers   = "A:\( a ) X:\( x ) Y:\( y ) P:\( p ) SP:\( sp )"
        let cycles      = "CYC:\( clock )"
        let text        = "\( instruction )\( registers ) \( cycles )"

        if let comment = comment
        {
            self.log( text: "\( text ) ; \( comment )" )
        }
        else
        {
            self.log( text: text )
        }
    }
}
