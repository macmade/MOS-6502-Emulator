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

public class RegistersWindow: DebuggerWindow
{
    private enum RegisterDisplayMode
    {
        case none
        case decimal
        case binary
    }

    public override func render( on window: ManagedWindow )
    {
        window.printLine( foreground: .blue,   text: "CPU Registers:" )
        window.separator()

        let registers: [ ( name: String, value: Either< UInt8, UInt16 >, mode: RegisterDisplayMode ) ] = [
            ( "PC: ", .right( self.computer.cpu.registers.PC          ), .none ),
            ( "SP: ", .left(  self.computer.cpu.registers.SP          ), .none ),
            ( "--",   .left(  0                                       ), .none ),
            ( "A:  ", .left(  self.computer.cpu.registers.A           ), .decimal ),
            ( "X:  ", .left(  self.computer.cpu.registers.X           ), .decimal ),
            ( "Y:  ", .left(  self.computer.cpu.registers.Y           ), .decimal ),
            ( "--",   .left(  0                                       ), .none ),
            ( "PS: ", .left(  self.computer.cpu.registers.PS.rawValue ), .binary ),
        ]

        registers.forEach
        {
            if $0.name == "--"
            {
                window.separator()
            }
            else
            {
                self.printRegister( window: window, register: $0 )
            }
        }
    }

    private func printRegister( window: ManagedWindow, register: ( name: String, value: Either< UInt8, UInt16 >, mode: RegisterDisplayMode ) )
    {
        window.print( foreground: .cyan, text: register.name )

        let bits:     [ Bool ]
        let unsigned: UInt16
        let signed:   Int16

        switch register.value
        {
            case .left(  let value ):

                window.print( foreground: .yellow, text: value.asHex )

                bits     = value.bits
                unsigned = UInt16( value )
                signed   = Int16( Int8( bitPattern: value ) )

            case .right( let value ):

                window.print( foreground: .yellow, text: value.asHex )

                bits     = value.bits
                unsigned = value
                signed   = Int16( bitPattern: unsigned )
        }

        if register.mode == .binary
        {
            window.print( text: " | " )
            bits.reversed().forEach
            {
                window.print( foreground: $0 ? .green : .red, text: $0 ? "1" : "0" )
            }
        }
        else if register.mode == .decimal
        {
            window.print( text: " | " )
            window.print( foreground: .yellow, text: "\( unsigned )" )

            if signed < 0
            {
                window.print( text: " | " )
                window.print( foreground: .yellow, text: "\( signed )" )
            }
        }

        window.newLine()
    }
}
