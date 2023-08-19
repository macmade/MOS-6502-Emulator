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
import xasm65lib

public class InteractiveDebugger: ComputerRunner, Synchronizable
{
    private var computer:      Computer
    private var screen:        Screen
    private var queue:         DispatchQueue
    private var error:         Error?
    private var keyHandler:    Any?
    private var sync         = DispatchGroup()
    private var step         = false
    private var memoryOffset = 0
    private var prompt       = ""
    private var inPrompt     = false
    private var reset        = false
    private var paused       = false
    {
        willSet( newValue )
        {
            if newValue != self.paused, newValue
            {
                self.sync.enter()
            }
            else if newValue != self.paused, newValue == false
            {
                self.sync.leave()
            }
        }
    }

    private var setClock = false
    {
        didSet
        {
            self.prompt   = ""
            self.inPrompt = self.setClock
        }
    }

    private var setPC = false
    {
        didSet
        {
            self.prompt   = ""
            self.inPrompt = self.setPC
        }
    }

    private var setSP = false
    {
        didSet
        {
            self.prompt   = ""
            self.inPrompt = self.setSP
        }
    }

    private var setA = false
    {
        didSet
        {
            self.prompt   = ""
            self.inPrompt = self.setA
        }
    }

    private var setX = false
    {
        didSet
        {
            self.prompt   = ""
            self.inPrompt = self.setX
        }
    }

    private var setY = false
    {
        didSet
        {
            self.prompt   = ""
            self.inPrompt = self.setY
        }
    }

    private var setPS = false
    {
        didSet
        {
            self.prompt   = ""
            self.inPrompt = self.setPS
        }
    }

    public init( computer: Computer, screen: Screen )
    {
        self.computer = computer
        self.screen   = screen
        self.queue    = DispatchQueue( label: "com.xs-labs.MOS6502-Debugger", qos: .userInitiated, attributes: [] )
    }

    public func run() throws
    {
        self.computer.logger = nil

        self.paused = true

        self.computer.cpu.beforeInstruction =
        {
            try self.synchronized
            {
                if self.reset
                {
                    try self.computer.cpu.reset()
                    try self.computer.bus.reset()

                    self.reset = false
                }
            }

            self.sync.wait()
        }

        self.computer.cpu.afterInstruction =
        {
            self.synchronized
            {
                if self.step
                {
                    self.paused.toggle()
                }
            }
        }

        self.keyHandler = self.screen.onKeyPress.add
        {
            key in self.synchronized
            {
                if ( ( 0x30 ... 0x39 ).contains( key ) || key == 0x78 || ( 0x61 ... 0x66 ).contains( key ) || ( 0x41 ... 0x46 ).contains( key ) ), self.inPrompt // Number, a-f, A-F or x
                {
                    self.prompt.append( String( format: "%c", key ) )
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
                    }
                    else if self.setPC
                    {
                        if let pc: UInt16 = self.promptValue( initialize: { UInt16( $0, radix: $1 ) } )
                        {
                            self.computer.cpu.registers.PC = pc
                        }

                        self.setPC.toggle()
                    }
                    else if self.setSP
                    {
                        if let sp: UInt8 = self.promptValue( initialize: { UInt8( $0, radix: $1 ) } )
                        {
                            self.computer.cpu.registers.SP = sp
                        }

                        self.setSP.toggle()
                    }
                    else if self.setA
                    {
                        if let a: UInt8 = self.promptValue( initialize: { UInt8( $0, radix: $1 ) } )
                        {
                            self.computer.cpu.registers.A = a
                        }

                        self.setA.toggle()
                    }
                    else if self.setX
                    {
                        if let x: UInt8 = self.promptValue( initialize: { UInt8( $0, radix: $1 ) } )
                        {
                            self.computer.cpu.registers.X = x
                        }

                        self.setX.toggle()
                    }
                    else if self.setY
                    {
                        if let y: UInt8 = self.promptValue( initialize: { UInt8( $0, radix: $1 ) } )
                        {
                            self.computer.cpu.registers.Y = y
                        }

                        self.setY.toggle()
                    }
                    else if self.setPS
                    {
                        if let ps: UInt8 = self.promptValue( initialize: { UInt8( $0, radix: $1 ) } )
                        {
                            self.computer.cpu.registers.PS = .init( rawValue: ps )
                        }

                        self.setPS.toggle()
                    }
                }
                else if key == 0x20 // space
                {
                    self.step = true

                    self.paused.toggle()
                }
                else if key == 0x71 // q
                {
                    self.screen.stop()
                }
                else if key == 0x72, self.paused // r
                {
                    self.step = false

                    self.paused.toggle()
                }
                else if key == 0x7A // z
                {
                    self.reset = true

                    self.step.toggle()
                    self.paused.toggle()
                }
                else if key == 0x2B // +
                {
                    self.memoryOffset += 1
                }
                else if key == 0x2D // -
                {
                    self.memoryOffset -= 1
                }
                else if key == 0x68, ( self.inPrompt == false || self.setClock ) // f
                {
                    self.setClock.toggle()
                }
                else if key == 0x70, ( self.inPrompt == false || self.setPC ) // p
                {
                    self.setPC.toggle()
                }
                else if key == 0x73, ( self.inPrompt == false || self.setSP ) // s
                {
                    self.setSP.toggle()
                }
                else if key == 0x61, ( self.inPrompt == false || self.setA ) // a
                {
                    self.setA.toggle()
                }
                else if key == 0x78, ( self.inPrompt == false || self.setX ) // x
                {
                    self.setX.toggle()
                }
                else if key == 0x79, ( self.inPrompt == false || self.setY ) // y
                {
                    self.setY.toggle()
                }
                else if key == 0x66, ( self.inPrompt == false || self.setPS ) // f
                {
                    self.setPS.toggle()
                }
            }
        }

        self.queue.async
        {
            do
            {
                try self.computer.reset()
            }
            catch
            {
                self.error = error
            }
        }

        self.screen.addWindow( frame: Rect( x: 0, y: 0, width: 0, height: 3 ), style: .boxed )
        {
            self.printMenu( window: $0 )
        }

        self.screen.addWindow( frame: Rect( x: 0, y: 3, width: 0, height: 3 ), style: .boxed )
        {
            if self.setClock
            {
                self.printClockPrompt( window: $0 )
            }
            else if self.setPC
            {
                self.printRegisterPrompt( window: $0, register: "PC" )
            }
            else if self.setSP
            {
                self.printRegisterPrompt( window: $0, register: "SP" )
            }
            else if self.setA
            {
                self.printRegisterPrompt( window: $0, register: "A" )
            }
            else if self.setX
            {
                self.printRegisterPrompt( window: $0, register: "X" )
            }
            else if self.setY
            {
                self.printRegisterPrompt( window: $0, register: "Y" )
            }
            else if self.setPS
            {
                self.printRegisterPrompt( window: $0, register: "PS" )
            }
            else
            {
                self.printStatus( window: $0 )
            }
        }

        self.screen.addWindow( frame: Rect( x: 0, y: 6, width: 19, height: 12 ), style: .boxed )
        {
            self.printComputer( window: $0 )
        }

        self.screen.addWindow( frame: Rect( x: 19, y: 6, width: 25, height: 12 ), style: .boxed )
        {
            self.printRegisters( window: $0, registers: self.computer.cpu.registers )
        }

        self.screen.addWindow( frame: Rect( x: 44, y: 6, width: 26, height: 12 ), style: .boxed )
        {
            self.printFlags( window: $0, flags: self.computer.cpu.registers.PS )
        }

        self.screen.addWindow( frame: Rect( x: 70, y: 6, width: 18, height: 12 ), style: .boxed )
        {
            self.printInstructions( window: $0 )
        }

        self.screen.addWindow( frame: Rect( x: 88, y: 6, width: 0, height: 12 ), style: .boxed )
        {
            self.printDisassembly( window: $0 )
        }

        self.screen.addWindow( frame: Rect( x: 0, y: 18, width: 70, height: 20 ), style: .boxed )
        {
            self.printStack( window: $0 )
        }

        self.screen.addWindow( frame: Rect( x: 0, y: 38, width: 70, height: 0 ), style: .boxed )
        {
            self.printMemoryDevices( window: $0 )
        }

        self.screen.addWindow( frame: Rect( x: 70, y: 18, width: 0, height: 0 ), style: .boxed )
        {
            self.printMemory( window: $0 )
        }

        self.screen.start()
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

    private func printMenu( window: ManagedWindow )
    {
        window.print( foreground: .cyan,   text: "r" )
        window.print(                      text: ": " )
        window.print( foreground: .yellow, text: "Run" )
        window.print(                      text: " | " )
        window.print( foreground: .cyan,   text: "[space]" )
        window.print(                      text: ": " )
        window.print( foreground: .yellow, text: "Pause/Step" )
        window.print(                      text: " | " )
        window.print( foreground: .cyan,   text: "+/-" )
        window.print(                      text: ": " )
        window.print( foreground: .yellow, text: "Scroll Memory" )
        window.print(                      text: " | " )
        window.print( foreground: .cyan,   text: "h" )
        window.print(                      text: ": " )
        window.print( foreground: .yellow, text: "Set CPU frequency" )
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
        self.synchronized
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
    }

    private func readUInt16FromMemory( at address: UInt16 ) throws -> UInt16
    {
        let u1 = UInt16( try self.computer.bus.read( at: address ) )
        let u2 = UInt16( try self.computer.bus.read( at: address + 1 ) )

        return ( u2 << 8 ) | u1
    }

    private func printComputer( window: ManagedWindow )
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

    private enum RegisterDisplayMode
    {
        case none
        case decimal
        case binary
    }

    private func printRegisters( window: ManagedWindow, registers: Registers )
    {
        window.printLine( foreground: .blue,   text: "CPU Registers:" )
        window.separator()

        let registers: [ ( name: String, value: Either< UInt8, UInt16 >, mode: RegisterDisplayMode ) ] = [
            ( "PC: ", .right( registers.PC          ), .none ),
            ( "SP: ", .left(  registers.SP          ), .none ),
            ( "--",   .left(  0                     ), .none ),
            ( "A:  ", .left(  registers.A           ), .decimal ),
            ( "X:  ", .left(  registers.X           ), .decimal ),
            ( "Y:  ", .left(  registers.Y           ), .decimal ),
            ( "--",   .left(  0                     ), .none ),
            ( "PS: ", .left(  registers.PS.rawValue ), .binary ),
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
            bits.forEach
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

    private func printFlags( window: ManagedWindow, flags: Registers.Flags )
    {
        window.printLine( foreground: .blue, text: "CPU Flags:" )
        window.separator()

        [
            ( "Carry:             ", flags.contains( .carryFlag ) ),
            ( "Zero:              ", flags.contains( .zeroFlag ) ),
            ( "Interrupt Disable: ", flags.contains( .interruptDisable ) ),
            ( "Decimal Mode:      ", flags.contains( .decimalMode ) ),
            ( "Break:             ", flags.contains( .breakCommand ) ),
            ( "(Unused):          ", flags.contains( .unused ) ),
            ( "Overflow:          ", flags.contains( .overflowFlag ) ),
            ( "Negative:          ", flags.contains( .negativeFlag ) ),
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

    private func printInstructions( window: ManagedWindow )
    {
        window.printLine( foreground: .blue, text: "Instructions:" )
        window.separator()
        self.printDisassembly( window: window, lines: Int( window.bounds.size.height ), options1: [ .address ], options2: [ .bytes ] )
    }

    private func printDisassembly( window: ManagedWindow )
    {
        window.printLine( foreground: .blue, text: "Disassembly:" )
        window.separator()
        self.printDisassembly( window: window, lines: Int( window.bounds.size.height ), options1: [ .address ], options2: [ .disassembly, .comments ] )
    }

    private var disassemblerLabels: [ UInt16: String ]
    {
        self.computer.bus.devices.reduce( into: [ UInt16: String ]() )
        {
            result, mapping in if let rom = mapping.device as? ROM
            {
                rom.labels.forEach { result[ $0.key ] = $0.value }
            }
        }
    }

    private var disassemblerComments: [ UInt16: String ]
    {
        self.computer.bus.devices.reduce( into: [ UInt16: String ]() )
        {
            result, mapping in if let rom = mapping.device as? ROM
            {
                rom.comments.forEach { result[ $0.key ] = $0.value }
            }
        }
    }

    private func printDisassembly( window: ManagedWindow, lines: Int, options1: Disassembler.Options, options2: Disassembler.Options )
    {
        let stream1       = MemoryDeviceStream( device: self.computer.bus, offset: self.computer.cpu.registers.PC )
        let stream2       = MemoryDeviceStream( device: self.computer.bus, offset: self.computer.cpu.registers.PC )
        let labels        = self.disassemblerLabels
        let comments      = self.disassemblerComments
        let disassembler1 = try? Disassembler( stream: stream1, origin: self.computer.cpu.registers.PC, size: 0, instructions: 1, options: options1, separator: " ", comments: comments, labels: labels )
        let disassembler2 = try? Disassembler( stream: stream2, origin: self.computer.cpu.registers.PC, size: 0, instructions: 1, options: options2, separator: " ", comments: comments, labels: labels )

        if let disassembler1 = disassembler1, let disassembler2 = disassembler2
        {
            ( 0 ..< lines ).forEach
            {
                _ in

                let address = try? disassembler1.disassemble()
                let other   = try? disassembler2.disassemble()

                if let address = address, let other = other
                {
                    window.print( foreground: .cyan,   text: address )
                    window.print(                      text: " " )

                    if let index = other.firstIndex( of: ";" )
                    {
                        let part1 = index == other.startIndex ? "" : String( other[ other.startIndex ..< index ] )
                        let part2 = String( other[ index ..< other.endIndex ] )

                        window.print( foreground: .yellow,  text: part1.padding( toLength: 15, withPad: " ", startingAt: 0 ) )
                        window.print( foreground: .magenta, text: part2 )
                    }
                    else
                    {
                        window.print( foreground: .yellow, text: other )
                    }

                    window.newLine()
                }
                else
                {
                    window.printLine( foreground: .red, text: "???" )
                }
            }
        }
        else
        {
            window.printLine( foreground: .red, text: "???" )
        }
    }

    private func printableSize( bytes: UInt64 ) -> String
    {
        if bytes < 1024
        {
            return "\( bytes ) B"
        }
        else if bytes < 1024 * 1024
        {
            return "\( String( format: "%.02f", Double( bytes ) / 1024.0 ) ) KB"
        }
        else
        {
            return "\( String( format: "%.02f", ( Double( bytes ) / 1024.0 ) / 1024.0 ) ) MB"
        }
    }

    private func printMemoryDevices( window: ManagedWindow )
    {
        window.printLine( foreground: .blue, text: "Mapped Devices:" )
        window.separator()
        self.computer.bus.devices.forEach
        {
            let start = String( format: "%04X", $0.address )
            let end   = String( format: "%04X", $0.address + UInt16( $0.size - 1 ) )

            window.print( foreground: .cyan,   text: "\( start ) - \( end ): " )
            window.print( foreground: .yellow, text: self.printableSize( bytes: $0.size ).padding( toLength: 6, withPad: " ", startingAt: 0 ) )
            window.print(                      text: " - " )

            if let device = $0.device as? CustomStringConvertible
            {
                window.print( foreground: .magenta, text: device.description )
            }
            else
            {
                window.print( foreground: .magenta, text: "Unknown" )
            }

            window.newLine()
        }
    }

    private func printStack( window: ManagedWindow )
    {
        window.printLine( foreground: .blue, text: "Stack:" )
        window.separator()
        self.printMemory( window: window, start: CPU.stackStart, end: CPU.stackEnd, columns: Int( window.bounds.size.width ) - 2, lines: Int( window.bounds.size.height ) - 2, canScroll: false )
    }

    private func printMemory( window: ManagedWindow )
    {
        window.printLine( foreground: .blue, text: "Memory:" )
        window.separator()
        self.printMemory( window: window, start: 0x0000, end: 0xFFFF, columns: Int( window.bounds.size.width ) - 2, lines: Int( window.bounds.size.height ) - 2, canScroll: true )
    }

    private func printMemory( window: ManagedWindow, start: UInt16, end: UInt16, columns: Int, lines: Int, canScroll: Bool )
    {
        let bytes = ( start ... end ).map
        {
            try? self.computer.bus.read( at: $0 )
        }

        let memoryBytesPerLine = ( columns / 4 )
        let memoryLines        = lines

        guard memoryBytesPerLine > 0, memoryLines > 0
        else
        {
            return
        }

        var address = 0x0000

        if canScroll
        {
            if self.memoryOffset < 0
            {
                self.memoryOffset = 0
            }

            let totalLines = bytes.count / memoryBytesPerLine
            let maxOffset  = ( totalLines / memoryLines ) * 2

            if self.memoryOffset >= maxOffset
            {
                self.memoryOffset = maxOffset
            }

            address = 0x0000 + ( memoryBytesPerLine * ( memoryLines / 2 ) * self.memoryOffset )
        }

        ( 0 ..< memoryLines ).forEach
        {
            _ in

            if address + Int( start ) > Int( end )
            {
                return
            }

            window.print( foreground: .cyan, text: "\( String( format: "%04X", UInt16( address ) + start ) ): " )

            ( 0 ..< memoryBytesPerLine ).forEach
            {
                if address + $0 >= bytes.count
                {
                    return
                }

                if let byte = bytes[ address + $0 ]
                {
                    window.print( foreground: .yellow, text: "\( String( format: "%02X", byte ) ) " )
                }
                else
                {
                    window.print( foreground: .red, text: "xx " )
                }
            }

            window.print( text: "| " )

            ( 0 ..< memoryBytesPerLine ).forEach
            {
                if address + $0 >= bytes.count
                {
                    return
                }

                if let byte = bytes[ address + $0 ]
                {
                    if isprint( Int32( byte ) ) == 1, isspace( Int32( byte ) ) == 0
                    {
                        window.print( foreground: .yellow, text: String( format: "%c", byte ) )
                    }
                    else
                    {
                        window.print( foreground: .magenta, text: "." )
                    }
                }
                else
                {
                    window.print( text: " " )
                }
            }

            address += Int( memoryBytesPerLine )

            window.newLine()
        }
    }
}
