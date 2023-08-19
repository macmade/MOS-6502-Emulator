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

public class DisassemblyWindow: DebuggerWindow
{
    public override func render( on window: ManagedWindow )
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

    public func printDisassembly( window: ManagedWindow, lines: Int, options1: Disassembler.Options, options2: Disassembler.Options )
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
                    window.printLine( foreground: .red, text: "????" )
                }
            }
        }
        else
        {
            window.printLine( foreground: .red, text: "????" )
        }
    }
}
