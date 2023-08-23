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
import xasm65lib

public class InstructionsWindow: DebuggerWindow
{
    public override init( computer: Computer, frame: Rect, style: ManagedWindow.Style, prompt: PromptWindow )
    {
        super.init( computer: computer, frame: frame, style: style, prompt: prompt )
    }

    public override func render( on window: ManagedWindow )
    {
        window.printLine( foreground: .blue, text: "Instructions:" )
        window.separator()
        self.printDisassembly( window: window, lines: Int( window.bounds.size.height ) - 2 )
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

    public func printDisassembly( window: ManagedWindow, lines: Int )
    {
        guard lines > 0
        else
        {
            return
        }

        let instructions = self.getInstructions( lines: lines )
        let max          = instructions.reduce( into: [ Int: Int ]() )
        {
            result, line in line.enumerated().forEach
            {
                if let max = result[ $0.offset ], max >= $0.element.text.count
                {
                    return
                }

                result[ $0.offset ] = $0.element.text.count
            }
        }

        instructions.map
        {
            $0.enumerated().map
            {
                if let max = max[ $0.offset ], $0.offset > 0
                {
                    if $0.offset == 1
                    {
                        return ( $0.element.color, " \( $0.element.text )".padding( toLength: max + 1, withPad: " ", startingAt: 0 ) )
                    }
                    else
                    {
                        return ( $0.element.color, "    \( $0.element.text )".padding( toLength: max + 4, withPad: " ", startingAt: 0 ) )
                    }
                }
                else
                {
                    return ( $0.element.color, $0.element.text )
                }
            }
        }
        .forEach
        {
            self.printInstruction( window: window, instruction: $0 )
        }
    }

    private func printInstruction( window: ManagedWindow, instruction: [ ( color: Color?, text: String ) ] )
    {
        instruction.forEach
        {
            if let color = $0.color
            {
                window.print( foreground: color, text: $0.text )
            }
            else
            {
                window.print( text: $0.text )
            }
        }

        window.newLine()
    }

    private func getInstructions( lines: Int ) -> [ [ ( color: Color?, text: String ) ] ]
    {
        let stream       = MemoryDeviceStream( device: self.computer.bus, offset: self.computer.cpu.registers.PC )
        let comments     = self.disassemblerComments
        let disassembler = try? Disassembler( stream: stream, origin: self.computer.cpu.registers.PC, size: 0, instructions: 1, options: [], separator: "\0", comments: comments, labels: [ : ] )

        guard let disassembler = disassembler
        else
        {
            return [ [ ( color: .red, text: "???" ) ] ]
        }

        return ( 0 ..< lines ).map
        {
            _ in

            let text = try? disassembler.disassemble()

            guard let text = text
            else
            {
                return [ ( color: .red, text: "???" ) ]
            }

            return text.components( separatedBy: "\0" ).enumerated().map
            {
                if $0.offset == 0
                {
                    return ( .cyan, $0.element )
                }
                else if $0.offset == 1
                {
                    return ( .yellow, $0.element )
                }
                else if $0.offset == 2
                {
                    return ( .green, $0.element )
                }
                else
                {
                    return ( .magenta, $0.element )
                }
            }
        }
    }
}
