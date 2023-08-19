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

public class MC6820Window: DebuggerWindow
{
    public override func render( on window: ManagedWindow )
    {
        window.printLine( foreground: .blue, text: "MC6820 PIA:" )
        window.separator()

        guard let pia = self.computer.bus.devices.compactMap( { $0.device as? MC6820 } ).first
        else
        {
            window.printLine( foreground: .red, text: "Error:" )
            window.printLine( foreground: .red, text: "No MC6820 PIA" )

            return
        }

        self.printRegister( window: window, name: "DDR A", value: pia.DDRA )
        self.printRegister( window: window, name: "OR  A",  value: pia.ORA )
        self.printRegister( window: window, name: "CR  A",  value: pia.CRA )
        window.separator()
        self.printRegister( window: window, name: "DDR B", value: pia.DDRB )
        self.printRegister( window: window, name: "OR  B",  value: pia.ORB )
        self.printRegister( window: window, name: "CR  A",  value: pia.CRB )
    }

    private func printRegister( window: ManagedWindow, name: String, value: UInt8 )
    {
        window.print( foreground: .cyan,   text: "\( name ): " )
        window.print( foreground: .yellow, text: value.asHex )
        window.print(                      text: " | " )

        value.bits.reversed().forEach
        {
            if $0
            {
                window.print( foreground: .green, text: "1" )
            }
            else
            {
                window.print( foreground: .red, text: "0" )
            }
        }

        window.newLine()
    }
}
