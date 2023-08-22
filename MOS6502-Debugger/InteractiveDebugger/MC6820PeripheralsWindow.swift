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
    private var pia: MC6820?
    {
        self.computer.bus.devices.compactMap { $0.device as? MC6820 }.first
    }

    private var keyboard: MC6820Keyboard?
    {
        self.pia?.peripheral1 as? MC6820Keyboard ?? self.pia?.peripheral2 as? MC6820Keyboard
    }

    private var display: MC6820Display?
    {
        self.pia?.peripheral1 as? MC6820Display ?? self.pia?.peripheral2 as? MC6820Display
    }

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

    public override func handleKey( _ key: Int32 ) -> Bool
    {
        if key == 0x6B // k
        {
            self.prompt.show( title: "Enter a key to send to the keyboard", descriptions: nil )
            {
                if let u8 = $0.uint8, let key = String( format: "%c", u8 ).first
                {
                    self.keyboard?.enterKey( key )
                }
                else if let key = $0.string.first
                {
                    self.keyboard?.enterKey( key )
                }
            }

            return true
        }

        return false
    }

    private func printPeripheral( window: ManagedWindow, peripheral: MC6820Peripheral )
    {
        window.print( foreground: .cyan, text: "Type: " )
        window.print( foreground: .magenta, text: peripheral.description )
        window.newLine()
        window.print( foreground: .cyan,   text: "RDY:  " )
        self.printBool( window: window, value: peripheral.ready )
        window.newLine()
        window.print( foreground: .cyan,   text: "ACC:  " )
        self.printBool( window: window, value: peripheral.acknowledge )
        window.newLine()
        self.printInteger( window: window, label: "Data: ", value: peripheral.data )
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
}
