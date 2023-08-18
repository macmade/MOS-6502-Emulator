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
                if key == 0x20 // space
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
                else if key == 0x2B // +
                {
                    self.memoryOffset += 1
                }
                else if key == 0x2D // -
                {
                    self.memoryOffset -= 1
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
            self.printStatus( window: $0 )
        }

        self.screen.addWindow( frame: Rect( x: 0, y: 3, width: 18, height: 12 ), style: .boxed )
        {
            self.printComputer( window: $0 )
        }

        self.screen.addWindow( frame: Rect( x: 18, y: 3, width: 25, height: 12 ), style: .boxed )
        {
            self.printRegisters( window: $0, registers: self.computer.cpu.registers )
        }

        self.screen.addWindow( frame: Rect( x: 43, y: 3, width: 26, height: 12 ), style: .boxed )
        {
            self.printFlags( window: $0, flags: self.computer.cpu.registers.PS )
        }

        self.screen.addWindow( frame: Rect( x: 69, y: 3, width: 18, height: 12 ), style: .boxed )
        {
            self.printInstructions( window: $0 )
        }

        self.screen.addWindow( frame: Rect( x: 87, y: 3, width: 0, height: 12 ), style: .boxed )
        {
            self.printDisassembly( window: $0 )
        }

        self.screen.addWindow( frame: Rect( x: 0, y: 15, width: 69, height: 0 ), style: .boxed )
        {
            self.printMemoryDevices( window: $0 )
        }

        self.screen.addWindow( frame: Rect( x: 69, y: 15, width: 0, height: 0 ), style: .boxed )
        {
            self.printMemory( window: $0 )
        }

        self.screen.start()
    }

    private enum RegisterDisplayMode
    {
        case none
        case decimal
        case binary
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
        window.print(     foreground: .cyan,   text: "NMI:   " )
        window.printLine( foreground: .yellow, text: "FFFF" )
        window.print(     foreground: .cyan,   text: "RESET: " )
        window.printLine( foreground: .yellow, text: "FFFF" )
        window.print(     foreground: .cyan,   text: "IRQ:   " )
        window.printLine( foreground: .yellow, text: "FFFF" )
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
        self.printDisassembly( window: window, options1: [ .address ], options2: [ .bytes ], showComments: false )
    }

    private func printDisassembly( window: ManagedWindow )
    {
        window.printLine( foreground: .blue, text: "Disassembly:" )
        window.separator()
        self.printDisassembly( window: window, options1: [ .address ], options2: [ .disassembly ], showComments: true )
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

    private func printDisassembly( window: ManagedWindow, options1: Disassembler.Options, options2: Disassembler.Options, showComments: Bool )
    {
        let stream1       = MemoryDeviceStream( device: self.computer.bus, offset: self.computer.cpu.registers.PC )
        let stream2       = MemoryDeviceStream( device: self.computer.bus, offset: self.computer.cpu.registers.PC )
        let comments      = showComments ? self.disassemblerComments : [ : ]
        let disassembler1 = try? Disassembler( stream: stream1, origin: self.computer.cpu.registers.PC, size: 0, instructions: 1, options: options1, separator: " ", comments: [ : ],    labels: [ : ] )
        let disassembler2 = try? Disassembler( stream: stream2, origin: self.computer.cpu.registers.PC, size: 0, instructions: 1, options: options2, separator: " ", comments: comments, labels: [ : ] )

        if let disassembler1 = disassembler1, let disassembler2 = disassembler2
        {
            ( 0 ..< 8 ).forEach
            {
                _ in

                let address = try? disassembler1.disassemble()
                let other   = try? disassembler2.disassemble()

                if let address = address, let other = other
                {
                    window.print( foreground: .cyan,   text: address )
                    window.print(                      text: " " )

                    if let index = other.firstIndex( of:  ";" )
                    {
                        let part1 = String( other[ other.startIndex ..< index ] )
                        let part2 = String( other[ index            ..< other.endIndex ] )

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
            return "\( bytes )B"
        }
        else if bytes < 1024 * 1024
        {
            return "\( String( format: "%.02f", Double( bytes ) / 1024.0 ) )KB"
        }
        else
        {
            return "\( String( format: "%.02f", ( Double( bytes ) / 1024.0 ) / 1024.0 ) )MB"
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

    private func printMemory( window: ManagedWindow )
    {
        window.printLine( foreground: .blue, text: "Memory:" )
        window.separator()

        let bytes = ( 0x0000 ... 0xFFFF ).map
        {
            try? self.computer.bus.read( at: $0 )
        }

        let memoryBytesPerLine = Int( ( window.bounds.size.width / 4 ) - 2 )
        let memoryLines        = Int( window.bounds.size.height - 2 )

        guard memoryBytesPerLine > 0, memoryLines > 0
        else
        {
            return
        }

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

        var address = 0x0000 + ( memoryBytesPerLine * ( memoryLines / 2 ) * self.memoryOffset )

        ( 0 ..< memoryLines ).forEach
        {
            _ in

            if address > UInt16.max
            {
                return
            }

            window.print( foreground: .cyan, text: "\( String( format: "%04X", UInt16( address ) ) ): " )

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
