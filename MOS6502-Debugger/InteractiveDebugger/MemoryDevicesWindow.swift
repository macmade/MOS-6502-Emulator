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

public class MemoryDevicesWindow: DebuggerWindow
{
    public override func render( on window: ManagedWindow )
    {
        window.printLine( foreground: .blue, text: "Mapped Devices:" )
        window.separator()
        self.computer.bus.devices.forEach
        {
            if $0.size == 0
            {
                return
            }

            let start = String( format: "%04X", $0.address )
            let end   = String( format: "%04X", UInt64( $0.address ) + ( $0.size - 1 ) )

            window.print( foreground: .cyan,   text: "\( start ) - \( end ): " )
            window.print( foreground: .yellow, text: self.printableSize( bytes: $0.size ).padding( toLength: 6, withPad: " ", startingAt: 0 ) )
            window.print(                      text: " - " )

            if let device = $0.device as? CustomStringConvertible
            {
                window.print( foreground: .magenta, text: device.description )
            }
            else
            {
                window.print( foreground: .magenta, text: "Unknown" )
            }

            window.newLine()
        }
    }
}
