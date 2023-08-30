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

public class FlagsWindow: DebuggerWindow
{
    public override func render( on window: ManagedWindow )
    {
        window.printLine( foreground: .blue, text: "CPU Flags:" )
        window.separator()

        [
            ( "Carry:             ", self.computer.cpu.registers.P.contains( .carryFlag ) ),
            ( "Zero:              ", self.computer.cpu.registers.P.contains( .zeroFlag ) ),
            ( "Interrupt Disable: ", self.computer.cpu.registers.P.contains( .interruptDisable ) ),
            ( "Decimal Mode:      ", self.computer.cpu.registers.P.contains( .decimalMode ) ),
            ( "Break:             ", self.computer.cpu.registers.P.contains( .breakCommand ) ),
            ( "(Unused):          ", self.computer.cpu.registers.P.contains( .unused ) ),
            ( "Overflow:          ", self.computer.cpu.registers.P.contains( .overflowFlag ) ),
            ( "Negative:          ", self.computer.cpu.registers.P.contains( .negativeFlag ) ),
        ]
        .forEach
        {
            window.print( foreground: .cyan, text: $0.0 )

            if $0.1
            {
                window.printLine( foreground: .green, text: "Yes" )
            }
            else
            {
                window.printLine( foreground: .red, text: " No" )
            }
        }
    }
}
