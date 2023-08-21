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

public class RegistersWindow: DebuggerWindow
{
    public struct RegisterDisplayOptions: OptionSet
    {
        public static var decimal: RegisterDisplayOptions { RegisterDisplayOptions( rawValue: 1 << 0 ) }
        public static var binary:  RegisterDisplayOptions { RegisterDisplayOptions( rawValue: 1 << 1 ) }

        public let rawValue: Int

        public init( rawValue: Int )
        {
            self.rawValue = rawValue
        }
    }

    public override func render( on window: ManagedWindow )
    {
        window.printLine( foreground: .blue,   text: "CPU Registers:" )
        window.separator()

        let registers: [ ( name: String, value: MOS6502.Either< UInt8, UInt16 >, options: RegisterDisplayOptions ) ] = [
            ( "PC: ", .right( self.computer.cpu.registers.PC          ), [] ),
            ( "SP: ", .left(  self.computer.cpu.registers.SP          ), [] ),
            ( "--",   .left(  0                                       ), [] ),
            ( "A:  ", .left(  self.computer.cpu.registers.A           ), [ .decimal, .binary ] ),
            ( "X:  ", .left(  self.computer.cpu.registers.X           ), [ .decimal, .binary ] ),
            ( "Y:  ", .left(  self.computer.cpu.registers.Y           ), [ .decimal, .binary ] ),
            ( "--",   .left(  0                                       ), [] ),
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

    private func printRegister( window: ManagedWindow, register: ( name: String, value: MOS6502.Either< UInt8, UInt16 >, options: RegisterDisplayOptions ) )
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

        if register.options.contains( .binary )
        {
            window.print( text: " | " )
            bits.reversed().forEach
            {
                window.print( foreground: $0 ? .green : .red, text: $0 ? "1" : "0" )
            }
        }

        if register.options.contains( .decimal )
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

    public override func handleKey( _ key: Int32 ) -> Bool
    {
        if key == 0x70 // p
        {
            self.showPrompt( name: "PC", register: \.PC ) { $0.uint16 }

            return true
        }
        else if key == 0x73 // s
        {
            self.showPrompt( name: "SP", register: \.SP ) { $0.uint8 }

            return true
        }
        else if key == 0x61 // a
        {
            self.showPrompt( name: "A", register: \.A ) { $0.uint8 }

            return true
        }
        else if key == 0x78 // x
        {
            self.showPrompt( name: "X", register: \.X ) { $0.uint8 }

            return true
        }
        else if key == 0x79 // y
        {
            self.showPrompt( name: "Y", register: \.Y ) { $0.uint8 }

            return true
        }
        else if key == 0x66 // f
        {
            self.showPrompt( name: "PS", register: \.PS )
            {
                if let value = $0.uint8
                {
                    return Registers.Flags( rawValue: value )
                }

                return nil
            }

            return true
        }

        return false
    }

    private func showPrompt< T >( name: String, register: ReferenceWritableKeyPath< Registers, T >, getValue: @escaping ( PromptValue ) -> T? )
    {
        self.prompt.show( title: "Enter a new value for the \( name ) register:", descriptions: nil )
        {
            if let value = getValue( $0 )
            {
                self.computer.cpu.registers[ keyPath: register ] = value
            }
        }
    }
}
