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

public class MenuWindow: DebuggerWindow
{
    public override func render( on window: ManagedWindow )
    {
        window.print( foreground: .cyan,   text: "[space]" )
        window.print(                      text: ": " )
        window.print( foreground: .yellow, text: "Pause/Step" )
        window.print(                      text: " | " )
        window.print( foreground: .cyan,   text: "r" )
        window.print(                      text: ": " )
        window.print( foreground: .yellow, text: "Run" )
        window.print(                      text: " | " )
        window.print( foreground: .cyan,   text: "z" )
        window.print(                      text: ": " )
        window.print( foreground: .yellow, text: "Reset CPU" )
        window.print(                      text: " | " )
        window.print( foreground: .cyan,   text: "h" )
        window.print(                      text: ": " )
        window.print( foreground: .yellow, text: "Set CPU frequency" )
        window.print(                      text: " | " )
        window.print( foreground: .cyan,   text: "+/-" )
        window.print(                      text: ": " )
        window.print( foreground: .yellow, text: "Scroll Memory" )
        window.print(                      text: " | " )
        window.print( foreground: .cyan,   text: "p" )
        window.print(                      text: ": " )
        window.print( foreground: .yellow, text: "Set PC" )
        window.print(                      text: " | " )
        window.print( foreground: .cyan,   text: "s" )
        window.print(                      text: ": " )
        window.print( foreground: .yellow, text: "Set SP" )
        window.print(                      text: " | " )
        window.print( foreground: .cyan,   text: "a" )
        window.print(                      text: ": " )
        window.print( foreground: .yellow, text: "Set A" )
        window.print(                      text: " | " )
        window.print( foreground: .cyan,   text: "x" )
        window.print(                      text: ": " )
        window.print( foreground: .yellow, text: "Set X" )
        window.print(                      text: " | " )
        window.print( foreground: .cyan,   text: "y" )
        window.print(                      text: ": " )
        window.print( foreground: .yellow, text: "Set Y" )
        window.print(                      text: " | " )
        window.print( foreground: .cyan,   text: "f" )
        window.print(                      text: ": " )
        window.print( foreground: .yellow, text: "Set PS" )
    }
}
