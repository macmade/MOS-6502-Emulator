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

public class MC6820PeripheralsWindow: DebuggerWindow
{
    public override func render( on window: ManagedWindow )
    {
        window.printLine( foreground: .blue, text: "MC6820 Peripherals:" )
        window.separator()

        guard let pia = self.computer.bus.devices.compactMap( { $0.device as? MC6820 } ).first
        else
        {
            window.printLine( foreground: .red, text: "Error:" )
            window.printLine( foreground: .red, text: "No MC6820 PIA" )

            return
        }

        self.printPeripheral( window: window, peripheral: pia.peripheral1 )
        window.separator()
        self.printPeripheral( window: window, peripheral: pia.peripheral2 )
    }

    private func printPeripheral( window: ManagedWindow, peripheral: MC6820Peripheral )
    {
        window.print( foreground: .cyan, text: "Type:        " )
        window.print( foreground: .magenta, text: peripheral.description )
        window.newLine()
        window.print( foreground: .cyan,   text: "Ready:       " )
        self.printBool( window: window, value: peripheral.ready )
        window.newLine()
        window.print( foreground: .cyan,   text: "Acknowledge: " )
        self.printBool( window: window, value: peripheral.acknowledge )
        window.newLine()
        window.print( foreground: .cyan,   text: "Data:        " )
        self.printData( window: window, value: peripheral.data )
    }

    private func printBool( window: ManagedWindow, value: Bool )
    {
        if value
        {
            window.print( foreground: .green, text: "Yes" )
        }
        else
        {
            window.print( foreground: .red, text: "No" )
        }
    }

    private func printData( window: ManagedWindow, value: UInt8 )
    {
        let signed = Int8( bitPattern: value )

        window.print( foreground: .yellow, text: value.asHex )
        window.print( text: " | " )
        window.print( foreground: .yellow, text: "\( value )" )

        if signed < 0
        {
            window.print( text: " | " )
            window.print( foreground: .yellow, text: "\( signed )" )
        }

        window.print( text: " | " )
        value.bits.reversed().forEach
        {
            window.print( foreground: $0 ? .green : .red, text: $0 ? "1" : "0" )
        }
    }
}
