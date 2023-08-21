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

public class StatusWindow: DebuggerWindow
{
    public var error:   Error?
    public var paused = false

    public override func render( on window: ManagedWindow )
    {
        let status: [ ( color: Color?, text: String ) ]

        if let error = self.error
        {
            status = [
                ( .cyan,   "Status: " ),
                ( .red,    "Error" ),
                ( .red,    " - " ),
                ( .yellow, error.localizedDescription ),
            ]
        }
        else if self.paused
        {
            status = [
                ( .cyan,   "Status: " ),
                ( .blue,   "Paused" ),
                ( nil,     " - " ),
                ( .yellow, "\( self.computer.cpu.clock ) cycles" ),
                ( nil,     " - Press 'r' to run or 'space' to step" ),
            ]
        }
        else
        {
            status = [
                (  .cyan,   "Status: " ),
                (  .green,  "Running" ),
                (  nil,     " - " ),
                (  .yellow, "\( self.computer.cpu.clock ) cycles" ),
            ]
        }

        status.forEach
        {
            if let color = $0.color
            {
                window.print( foreground: color, text: $0.text )
            }
            else
            {
                window.print( text: $0.text )
            }
        }

        let help = "Press '?' for help"
        let text = status.reduce( "" )
        {
            $0.appending( $1.text )
        }

        if text.count < window.bounds.size.width
        {
            window.moveX( by: ( window.bounds.size.width - Int32( text.count ) ) - Int32( help.count ) )
            window.print( text: help )
        }
    }
}
