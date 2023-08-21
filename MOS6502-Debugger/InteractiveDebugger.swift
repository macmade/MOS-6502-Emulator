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

public class InteractiveDebugger: ComputerRunner, Synchronizable
{
    private var computer:   Computer
    private var screen:     Screen
    private var queue:      DispatchQueue
    private var keyHandler: Any?
    private var sync      = DispatchGroup()
    private var step      = false
    private var running   = false

    private var error: Error?
    {
        didSet
        {
            self.statusWindow.error = self.error
        }
    }

    private var reset = false
    {
        didSet
        {
            self.synchronized
            {
                self.error = nil

                if self.running == false
                {
                    self.runComputer()
                }
            }
        }
    }

    private var paused = false
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

        didSet
        {
            self.statusWindow.paused = self.paused
        }
    }

    let helpWindow:              HelpWindow
    let statusWindow:            StatusWindow
    let computerWindow:          ComputerWindow
    let registersWindow:         RegistersWindow
    let flagsWindow:             FlagsWindow
    let mc6820Window:            MC6820Window
    let instructionsWindow:      InstructionsWindow
    let disassemblyWindow:       DisassemblyWindow
    let stackWindow:             StackWindow
    let mc6820PeripheralsWindow: MC6820PeripheralsWindow
    let memoryDevicesWindow:     MemoryDevicesWindow
    let memoryWindow:            MemoryWindow
    let promptWindow:            PromptWindow

    public var windows: [ DebuggerWindow ]
    {
        [
            self.helpWindow,
            self.statusWindow,
            self.computerWindow,
            self.registersWindow,
            self.flagsWindow,
            self.mc6820Window,
            self.instructionsWindow,
            self.disassemblyWindow,
            self.stackWindow,
            self.mc6820PeripheralsWindow,
            self.memoryDevicesWindow,
            self.memoryWindow,
        ]
    }

    public init( computer: Computer, screen: Screen )
    {
        self.computer = computer
        self.screen   = screen
        self.queue    = DispatchQueue( label: "com.xs-labs.MOS6502-Debugger", qos: .userInitiated, attributes: [] )

        self.promptWindow            = PromptWindow(            computer: computer, frame: Rect( x:  -1, y: -1, width: 50, height: 10 ), style: .boxed )
        self.helpWindow              = HelpWindow(              computer: computer, frame: Rect( x:  -1, y: -1, width:  0, height:  0 ), style: .boxed, prompt: self.promptWindow )
        self.statusWindow            = StatusWindow(            computer: computer, frame: Rect( x:   0, y:  0, width:  0, height:  3 ), style: .boxed, prompt: self.promptWindow )
        self.computerWindow          = ComputerWindow(          computer: computer, frame: Rect( x:   0, y:  3, width: 19, height: 12 ), style: .boxed, prompt: self.promptWindow )
        self.registersWindow         = RegistersWindow(         computer: computer, frame: Rect( x:  19, y:  3, width: 25, height: 12 ), style: .boxed, prompt: self.promptWindow )
        self.flagsWindow             = FlagsWindow(             computer: computer, frame: Rect( x:  44, y:  3, width: 26, height: 12 ), style: .boxed, prompt: self.promptWindow )
        self.mc6820Window            = MC6820Window(            computer: computer, frame: Rect( x:  70, y:  3, width: 26, height: 12 ), style: .boxed, prompt: self.promptWindow )
        self.instructionsWindow      = InstructionsWindow(      computer: computer, frame: Rect( x:  96, y:  3, width: 18, height: 12 ), style: .boxed, prompt: self.promptWindow )
        self.disassemblyWindow       = DisassemblyWindow(       computer: computer, frame: Rect( x: 114, y:  3, width:  0, height: 12 ), style: .boxed, prompt: self.promptWindow )
        self.stackWindow             = StackWindow(             computer: computer, frame: Rect( x:   0, y: 15, width: 70, height: 20 ), style: .boxed, prompt: self.promptWindow )
        self.mc6820PeripheralsWindow = MC6820PeripheralsWindow( computer: computer, frame: Rect( x:   0, y: 35, width: 70, height: 13 ), style: .boxed, prompt: self.promptWindow )
        self.memoryDevicesWindow     = MemoryDevicesWindow(     computer: computer, frame: Rect( x:   0, y: 48, width: 70, height:  0 ), style: .boxed, prompt: self.promptWindow )
        self.memoryWindow            = MemoryWindow(            computer: computer, frame: Rect( x:  70, y: 15, width:  0, height:  0 ), style: .boxed, prompt: self.promptWindow )
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
                if self.promptWindow.handleKey( key )
                {
                    return
                }
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
                else if key == 0x7A // z
                {
                    self.reset = true
                    self.step  = true

                    self.paused.toggle()
                }
                else
                {
                    let _ = self.windows.first
                    {
                        $0.handleKey( key )
                    }
                }
            }
        }

        self.runComputer()

        self.windows.forEach
        {
            self.screen.addWindow( builder: $0 )
        }

        self.screen.addWindow( builder: self.promptWindow )
        self.screen.start()
    }

    private func runComputer()
    {
        self.synchronized
        {
            if self.running
            {
                return
            }

            self.running = true
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

            self.synchronized
            {
                self.running = false
            }
        }
    }
}
