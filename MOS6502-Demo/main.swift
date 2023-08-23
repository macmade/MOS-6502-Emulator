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
import MOS6502Debugger

do
{
    if ProcessInfo.processInfo.arguments.contains( "--test" )
    {
        let computer = try Computer( frequency: .mhz( 1 ), memory: .kb( 0 ) )
        let rom      = try WritableFileROM( url: Bundle.main.bundleURL.appendingPathComponent( "6502-Functional-Test.bin" ), origin: 0 )

        try computer.loadROM( rom )
        try Debugger.debugger( for: computer ).run()
    }
    else
    {
        let computer = try Computer( frequency: .mhz( 1 ), memory: .kb( 4 ) )
        let rom      = Apple1WozMonitor()
        let keyboard = MC6820Keyboard()
        let display  = MC6820Display()
        let pia      = MC6820( peripheral1: keyboard, peripheral2: display )

        try computer.mapDevice( pia, at: 0xD010, size: 4 )
        try computer.loadROM( rom )
        try Debugger.debugger( for: computer ).run()
    }
}
catch
{
    print( "Error - \( error.localizedDescription )" )
}
