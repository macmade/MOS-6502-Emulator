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

public class StatusWindow: DebuggerWindow
{
    public var error:   Error?
    public var paused = false

    private var setClock = false
    {
        didSet
        {
            self.togglePrompt( value: self.setClock )
        }
    }

    private var setPC = false
    {
        didSet
        {
            self.togglePrompt( value: self.setPC )
        }
    }

    private var setSP = false
    {
        didSet
        {
            self.togglePrompt( value: self.setSP )
        }
    }

    private var setA = false
    {
        didSet
        {
            self.togglePrompt( value: self.setA )
        }
    }

    private var setX = false
    {
        didSet
        {
            self.togglePrompt( value: self.setX )
        }
    }

    private var setY = false
    {
        didSet
        {
            self.togglePrompt( value: self.setY )
        }
    }

    private var setPS = false
    {
        didSet
        {
            self.togglePrompt( value: self.setPS )
        }
    }

    private var prompt   = ""
    private var inPrompt = false

    public override func render( on window: ManagedWindow )
    {
        if self.setClock
        {
            self.printClockPrompt( window: window )
        }
        else if self.setPC
        {
            self.printRegisterPrompt( window: window, register: "PC" )
        }
        else if self.setSP
        {
            self.printRegisterPrompt( window: window, register: "SP" )
        }
        else if self.setA
        {
            self.printRegisterPrompt( window: window, register: "A" )
        }
        else if self.setX
        {
            self.printRegisterPrompt( window: window, register: "X" )
        }
        else if self.setY
        {
            self.printRegisterPrompt( window: window, register: "Y" )
        }
        else if self.setPS
        {
            self.printRegisterPrompt( window: window, register: "PS" )
        }
        else
        {
            self.printStatus( window: window )
        }
    }

    private func togglePrompt( value: Bool )
    {
        self.prompt   = ""
        self.inPrompt = value
    }

    private func printClockPrompt( window: ManagedWindow )
    {
        window.print( foreground: .cyan,   text: "Enter a new clock frequency in Hz: " )
        window.print( foreground: .yellow, text: self.prompt )
    }

    private func printRegisterPrompt( window: ManagedWindow, register: String )
    {
        window.print( foreground: .cyan,   text: "Enter a new value for the \( register ) register: " )
        window.print( foreground: .yellow, text: self.prompt )
    }

    private func printStatus( window: ManagedWindow )
    {
        if let error = self.error
        {
            window.print( foreground: .cyan,   text: "Status: " )
            window.print( foreground: .red,    text: "Error" )
            window.print(                      text: " - " )
            window.print( foreground: .yellow, text: error.localizedDescription )
        }
        else if self.paused
        {
            window.print( foreground: .cyan,   text: "Status: " )
            window.print( foreground: .blue,   text: "Paused" )
            window.print(                      text: " - " )
            window.print( foreground: .yellow, text: "\( self.computer.cpu.clock ) cycles" )
            window.print(                      text: " - Press 'r' to run or 'space' to step" )
        }
        else
        {
            window.print( foreground: .cyan,   text: "Status: " )
            window.print( foreground: .green,  text: "Running" )
            window.print(                      text: " - " )
            window.print( foreground: .yellow, text: "\( self.computer.cpu.clock ) cycles" )
        }
    }

    private func promptValue< T: UnsignedInteger >( initialize: ( String, Int ) -> T? ) -> T?
    {
        let prompt = self.prompt.trimmingCharacters( in: .whitespaces )

        if prompt.hasPrefix( "0x" )
        {
            let start = prompt.index( prompt.startIndex, offsetBy: 2 )
            let end   = prompt.endIndex

            return initialize( String( prompt[ start ..< end ] ), 16 )
        }

        return initialize( prompt, 10 )
    }

    public override func handleKey( _ key: Int32 ) -> Bool
    {
        if ( ( 0x30 ... 0x39 ).contains( key ) || key == 0x78 || ( 0x61 ... 0x66 ).contains( key ) || ( 0x41 ... 0x46 ).contains( key ) ), self.inPrompt // Number, a-f, A-F or x
        {
            self.prompt.append( String( format: "%c", key ) )

            return true
        }
        if key == 0x7F, self.inPrompt // Number, a-f, A-F or x
        {
            if self.prompt.isEmpty == false
            {
                self.prompt = String( self.prompt.dropLast( 1 ) )
            }

            return true
        }
        else if key == 0x0D // Enter
        {
            if self.setClock
            {
                if let clock: UInt = self.promptValue( initialize: { UInt( $0, radix: $1 ) } )
                {
                    self.computer.clock.frequency = .hz( clock )
                }

                self.setClock.toggle()

                return true
            }
            else if self.setPC
            {
                if let pc: UInt16 = self.promptValue( initialize: { UInt16( $0, radix: $1 ) } )
                {
                    self.computer.cpu.registers.PC = pc
                }

                self.setPC.toggle()

                return true
            }
            else if self.setSP
            {
                if let sp: UInt8 = self.promptValue( initialize: { UInt8( $0, radix: $1 ) } )
                {
                    self.computer.cpu.registers.SP = sp
                }

                self.setSP.toggle()

                return true
            }
            else if self.setA
            {
                if let a: UInt8 = self.promptValue( initialize: { UInt8( $0, radix: $1 ) } )
                {
                    self.computer.cpu.registers.A = a
                }

                self.setA.toggle()

                return true
            }
            else if self.setX
            {
                if let x: UInt8 = self.promptValue( initialize: { UInt8( $0, radix: $1 ) } )
                {
                    self.computer.cpu.registers.X = x
                }

                self.setX.toggle()

                return true
            }
            else if self.setY
            {
                if let y: UInt8 = self.promptValue( initialize: { UInt8( $0, radix: $1 ) } )
                {
                    self.computer.cpu.registers.Y = y
                }

                self.setY.toggle()

                return true
            }
            else if self.setPS
            {
                if let ps: UInt8 = self.promptValue( initialize: { UInt8( $0, radix: $1 ) } )
                {
                    self.computer.cpu.registers.PS = .init( rawValue: ps )
                }

                self.setPS.toggle()

                return true
            }
        }
        else if key == 0x68, ( self.inPrompt == false || self.setClock ) // f
        {
            self.setClock.toggle()

            return true
        }
        else if key == 0x70, ( self.inPrompt == false || self.setPC ) // p
        {
            self.setPC.toggle()

            return true
        }
        else if key == 0x73, ( self.inPrompt == false || self.setSP ) // s
        {
            self.setSP.toggle()

            return true
        }
        else if key == 0x61, ( self.inPrompt == false || self.setA ) // a
        {
            self.setA.toggle()

            return true
        }
        else if key == 0x78, ( self.inPrompt == false || self.setX ) // x
        {
            self.setX.toggle()

            return true
        }
        else if key == 0x79, ( self.inPrompt == false || self.setY ) // y
        {
            self.setY.toggle()

            return true
        }
        else if key == 0x66, ( self.inPrompt == false || self.setPS ) // f
        {
            self.setPS.toggle()

            return true
        }

        return false
    }
}
