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

public class Apple1: Computer
{
    public init() throws
    {
        try super.init( frequency: .mhz( 1 ), memory: 4096 )

        let keyboard   = try ShiftRegister( size: 1024 )
        let keyboardCR = try ShiftRegister( size: 1024 )
        let display    = try ShiftRegister( size: 1024 )
        let displayCR  = try ShiftRegister( size: 1024 )

        try self.mapDevice( keyboard,   at: 0xD010, size: 1 )
        try self.mapDevice( keyboardCR, at: 0xD011, size: 1 )
        try self.mapDevice( display,    at: 0xD012, size: 1 )
        try self.mapDevice( displayCR,  at: 0xD013, size: 1 )

        try self.loadROM( Apple1WozMonitor() )
        try self.reset()
    }
}
