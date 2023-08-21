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
import MOS6502
import SwiftCurses

public class DebuggerWindow: WindowBuilder
{
    public var desiredFame: Rect
    public var style:       ManagedWindow.Style

    public var priority: Int
    {
        DebuggerWindow.defaultPriority
    }

    public private( set ) var computer: Computer
    public private( set ) var prompt:   PromptWindow

    public init( computer: Computer, frame: Rect, style: ManagedWindow.Style, prompt: PromptWindow )
    {
        self.computer    = computer
        self.desiredFame = frame
        self.style       = style
        self.prompt      = prompt
    }

    public func shouldBeRendered() -> Bool
    {
        true
    }

    public func render( on window: ManagedWindow )
    {}

    public func handleKey( _ key: Int32 ) -> Bool
    {
        false
    }

    func readUInt16FromMemory( at address: UInt16 ) throws -> UInt16
    {
        let u1 = UInt16( try self.computer.bus.read( at: address ) )
        let u2 = UInt16( try self.computer.bus.read( at: address + 1 ) )

        return ( u2 << 8 ) | u1
    }

    func printableSize( bytes: UInt64 ) -> String
    {
        if bytes < 1024
        {
            return "\( bytes ) B"
        }
        else if bytes < 1024 * 1024
        {
            return "\( String( format: "%.02f", Double( bytes ) / 1024.0 ) ) KB"
        }
        else
        {
            return "\( String( format: "%.02f", ( Double( bytes ) / 1024.0 ) / 1024.0 ) ) MB"
        }
    }
}
