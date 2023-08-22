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

        self.printInteger( window: window, label: "DDR-A: ", value: pia.DDRA )
        self.printInteger( window: window, label: "OR-A:  ", value: pia.ORA )
        self.printInteger( window: window, label: "CR-A:  ", value: pia.CRA )
        window.print( foreground: .cyan,    text: "I/O:   " )
        window.print( foreground: .yellow,  text: pia.CRA & 0x04 != 0 ? "OR-A" : "DDR-A" )
        window.separator()
        self.printInteger( window: window, label: "DDR-B: ", value: pia.DDRB )
        self.printInteger( window: window, label: "OR-B:  ", value: pia.ORB )
        self.printInteger( window: window, label: "CR_B:  ", value: pia.CRB )
        window.print( foreground: .cyan,    text: "I/O:   " )
        window.print( foreground: .yellow,  text: pia.CRB & 0x04 != 0 ? "OR-B" : "DDR-B" )
    }
}
