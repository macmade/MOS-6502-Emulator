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

public class ComputerWindow: DebuggerWindow
{
    public override func render( on window: ManagedWindow )
    {
        window.printLine( foreground: .blue, text: "Computer:" )
        window.separator()

        window.print( foreground: .cyan, text: "CPU:   " )

        switch self.computer.clock.frequency
        {
            case .hz(  let hz  ): window.printLine( foreground: .yellow, text: "\(  hz )Hz" )
            case .mhz( let mhz ): window.printLine( foreground: .yellow, text: "\( mhz )MHz" )
        }

        window.print(     foreground: .cyan,   text: "RAM:   " )
        window.printLine( foreground: .yellow, text: "\( self.printableSize( bytes: self.computer.ram.capacity.bytes ) )" )
        window.separator()

        window.print( foreground: .cyan,   text: "NMI:   " )

        if let nmi = try? self.readUInt16FromMemory( at: CPU.nmi )
        {
            window.printLine( foreground: .yellow, text: String( format: "%04X", nmi ) )
        }
        else
        {
            window.printLine( foreground: .red, text: "????" )
        }

        window.print( foreground: .cyan,   text: "RESET: " )

        if let reset = try? self.readUInt16FromMemory( at: CPU.resetVector )
        {
            window.printLine( foreground: .yellow, text: String( format: "%04X", reset ) )
        }
        else
        {
            window.printLine( foreground: .red, text: "????" )
        }

        window.print(     foreground: .cyan,   text: "IRQ:   " )

        if let irq = try? self.readUInt16FromMemory( at: CPU.irq )
        {
            window.printLine( foreground: .yellow, text: String( format: "%04X", irq ) )
        }
        else
        {
            window.printLine( foreground: .red, text: "????" )
        }
    }

    public override func handleKey( _ key: Int32 ) -> Bool
    {
        if key == 0x68 // f
        {
            self.prompt.show( title: "Enter a new clock frequency in Hz:", descriptions: nil )
            {
                if let value = $0.uint
                {
                    self.computer.clock.frequency = .hz( value )
                }
            }

            return true
        }

        return false
    }
}
