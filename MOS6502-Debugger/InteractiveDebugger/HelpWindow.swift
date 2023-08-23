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

public class HelpWindow: DebuggerWindow
{
    private var show = false

    public override var priority: Int
    {
        100
    }

    private static let commands: [ ( key: String, description: String ) ] =
        [
            ( "[space]", "Pause/Step" ),
            ( "r",       "Run" ),
            ( "z",       "Reset CPU" ),
            ( "h",       "Set CPU frequency" ),
            ( "+/-",     "Scroll memory up or down" ),
            ( "m",       "Edit memory" ),
            ( "p",       "Set the PC register" ),
            ( "s",       "Set the SP register" ),
            ( "a",       "Set the A register" ),
            ( "x",       "Set the X register" ),
            ( "y",       "Set the Y register" ),
            ( "f",       "Set the PS register" ),
            ( "k",       "Enter keyboard input" ),
            ( "$",       "Show instructions history" ),
        ]

    public override init( computer: Computer, frame: Rect, style: ManagedWindow.Style, prompt: PromptWindow )
    {
        let maxKey         = HelpWindow.commands.reduce( 0 ) { $0 < $1.key.count         ? $1.key.count         : $0 }
        let maxDescription = HelpWindow.commands.reduce( 0 ) { $0 < $1.description.count ? $1.description.count : $0 }
        let width          = maxKey + maxDescription + 6
        let height         = HelpWindow.commands.count + 4
        let frame          = Rect( x: -1, y: -1, width: Int32( width ), height: Int32( height ) )

        super.init( computer: computer, frame: frame, style: style, prompt: prompt )
    }

    public override func shouldBeRendered() -> Bool
    {
        self.show
    }

    public override func handleKey( _ key: Int32 ) -> Bool
    {
        if key == 0x3F // ?
        {
            self.show.toggle()
        }

        return false
    }

    public override func render( on window: ManagedWindow )
    {
        window.print( foreground: .blue, text: "Available commands:" )
        window.separator()

        let maxKey = HelpWindow.commands.reduce( 0 ) { $0 < $1.key.count ? $1.key.count : $0 }

        HelpWindow.commands.forEach
        {
            window.print( foreground: .cyan,   text: $0.key )
            window.print(                      text: ": ".padding( toLength: ( maxKey + 2 ) - $0.key.count, withPad: " ", startingAt: 0 ) )
            window.print( foreground: .yellow, text: $0.description )
            window.newLine()
        }
    }
}
