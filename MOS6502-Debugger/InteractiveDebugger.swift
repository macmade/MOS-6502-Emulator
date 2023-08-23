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
import XSLabsSwift

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

    private var beforeInstructionObserver: Any?
    private var afterInstructionObserver:  Any?

    private let helpWindow:              HelpWindow
    private let statusWindow:            StatusWindow
    private let computerWindow:          ComputerWindow
    private let registersWindow:         RegistersWindow
    private let flagsWindow:             FlagsWindow
    private let instructionsWindow:      InstructionsWindow
    private let stackWindow:             StackWindow
    private let mc6820Window:            MC6820Window?
    private let mc6820PeripheralsWindow: MC6820PeripheralsWindow?
    private let memoryDevicesWindow:     MemoryDevicesWindow
    private let memoryWindow:            MemoryWindow
    private let promptWindow:            PromptWindow

    public var windows: [ DebuggerWindow ]
    {
        [
            self.helpWindow,
            self.statusWindow,
            self.computerWindow,
            self.registersWindow,
            self.flagsWindow,
            self.instructionsWindow,
            self.stackWindow,
            self.mc6820Window,
            self.mc6820PeripheralsWindow,
            self.memoryDevicesWindow,
            self.memoryWindow,
        ]
        .compactMap
        {
            $0
        }
    }

    public init( computer: Computer, screen: Screen )
    {
        self.computer = computer
        self.screen   = screen
        self.queue    = DispatchQueue( label: "com.xs-labs.MOS6502-Debugger", qos: .userInitiated, attributes: [] )

        let hasPIA = computer.bus.devices.first { $0.device is MC6820 } != nil

        self.promptWindow            =          PromptWindow(            computer: computer, frame: Rect( x: -1, y:               -1, width:  50, height: 10 ), style: .boxed )
        self.helpWindow              =          HelpWindow(              computer: computer, frame: Rect( x: -1, y:               -1, width:   0, height:  0 ), style: .boxed, prompt: self.promptWindow )
        self.statusWindow            =          StatusWindow(            computer: computer, frame: Rect( x:  0, y:                0, width:   0, height:  3 ), style: .boxed, prompt: self.promptWindow )
        self.computerWindow          =          ComputerWindow(          computer: computer, frame: Rect( x:  0, y:                3, width:  19, height: 12 ), style: .boxed, prompt: self.promptWindow )
        self.registersWindow         =          RegistersWindow(         computer: computer, frame: Rect( x: 19, y:                3, width:  36, height: 12 ), style: .boxed, prompt: self.promptWindow )
        self.flagsWindow             =          FlagsWindow(             computer: computer, frame: Rect( x: 55, y:                3, width:  26, height: 12 ), style: .boxed, prompt: self.promptWindow )
        self.instructionsWindow      =          InstructionsWindow(      computer: computer, frame: Rect( x: 81, y:                3, width:   0, height: 12 ), style: .boxed, prompt: self.promptWindow )
        self.stackWindow             =          StackWindow(             computer: computer, frame: Rect( x:  0, y:               15, width:  81, height: 20 ), style: .boxed, prompt: self.promptWindow )
        self.mc6820Window            = hasPIA ? MC6820Window(            computer: computer, frame: Rect( x:  0, y:               35, width:  41, height: 13 ), style: .boxed, prompt: self.promptWindow ) : nil
        self.mc6820PeripheralsWindow = hasPIA ? MC6820PeripheralsWindow( computer: computer, frame: Rect( x: 41, y:               35, width:  40, height: 13 ), style: .boxed, prompt: self.promptWindow ) : nil
        self.memoryDevicesWindow     =          MemoryDevicesWindow(     computer: computer, frame: Rect( x:  0, y: hasPIA ? 48 : 35, width:  81, height:  0 ), style: .boxed, prompt: self.promptWindow )
        self.memoryWindow            =          MemoryWindow(            computer: computer, frame: Rect( x: 81, y:               15, width:   0, height:  0 ), style: .boxed, prompt: self.promptWindow )
    }

    public func run() throws
    {
        self.computer.logger = nil

        self.paused = true

        self.beforeInstructionObserver = self.computer.cpu.beforeInstruction.add
        {
            do
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
            }
            catch
            {
                self.error = error
            }

            self.sync.wait()
        }

        self.afterInstructionObserver = self.computer.cpu.afterInstruction.add
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
