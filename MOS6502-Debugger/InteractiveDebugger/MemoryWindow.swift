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
import SwiftCurses

public class MemoryWindow: DebuggerWindow
{
    public var offset = 0

    public override func render( on window: ManagedWindow )
    {
        window.printLine( foreground: .blue, text: "Memory:" )
        window.separator()
        self.printMemory( window: window, start: 0x0000, end: 0xFFFF, columns: Int( window.bounds.size.width ) - 2, lines: Int( window.bounds.size.height ) - 2, canScroll: true )
    }

    public override func handleKey( _ key: Int32 ) -> Bool
    {
        if key == 0x2B // +
        {
            self.offset += 1

            return true
        }
        else if key == 0x2D // -
        {
            self.offset -= 1

            return true
        }
        else if key == 0x6D // m
        {
            self.prompt.show( title: "Enter a memory address:", descriptions: nil )
            {
                if let address = $0.uint16
                {
                    self.prompt.show( title: "Enter a value for memory address \( address.asHex ):", descriptions: [ "Note: you can enter multiple values separated by a space." ] )
                    {
                        $0.uint8Array.enumerated().forEach
                        {
                            try? self.computer.bus.write( $0.element, at: address + UInt16( $0.offset ) )
                        }
                    }
                }
            }

            return true
        }

        return false
    }

    public func printMemory( window: ManagedWindow, start: UInt16, end: UInt16, columns: Int, lines: Int, canScroll: Bool )
    {
        let bytes = ( start ... end ).map
        {
            try? self.computer.bus.debugRead( at: $0 )
        }


        let memoryBytesPerLine = ( columns / 4 )
        let memoryLines        = lines

        guard memoryBytesPerLine > 0, memoryLines > 0
        else
        {
            return
        }

        var address = 0x0000

        if canScroll
        {
            if self.offset < 0
            {
                self.offset = 0
            }

            let totalLines = bytes.count / memoryBytesPerLine
            let maxOffset  = ( totalLines / memoryLines ) * 2

            if self.offset >= maxOffset
            {
                self.offset = maxOffset
            }

            address = 0x0000 + ( memoryBytesPerLine * ( memoryLines / 2 ) * self.offset )
        }

        ( 0 ..< memoryLines ).forEach
        {
            _ in

            if address + Int( start ) > Int( end )
            {
                return
            }

            window.print( foreground: .cyan, text: "\( String( format: "%04X", UInt16( address ) + start ) ): " )

            ( 0 ..< memoryBytesPerLine ).forEach
            {
                if address + $0 >= bytes.count
                {
                    return
                }

                if let byte = bytes[ address + $0 ]
                {
                    window.print( foreground: .yellow, text: "\( String( format: "%02X", byte ) ) " )
                }
                else
                {
                    window.print( foreground: .red, text: "xx " )
                }
            }

            window.print( text: "| " )

            ( 0 ..< memoryBytesPerLine ).forEach
            {
                if address + $0 >= bytes.count
                {
                    return
                }

                if let byte = bytes[ address + $0 ]
                {
                    if isprint( Int32( byte ) ) == 1, isspace( Int32( byte ) ) == 0
                    {
                        window.print( foreground: .yellow, text: String( format: "%c", byte ) )
                    }
                    else
                    {
                        window.print( foreground: .magenta, text: "." )
                    }
                }
                else
                {
                    window.print( text: " " )
                }
            }

            address += Int( memoryBytesPerLine )

            window.newLine()
        }
    }
}
