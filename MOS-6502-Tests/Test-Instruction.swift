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

import MOS_6502_Emulator
import XCTest

class Test_Instruction: XCTestCase
{
    func setup( bytes: [ UInt8 ] ) throws -> CPU
    {
        let memory = try Memory( size: CPU.totalMemory, options: [ .wrapAround ], initializeTo: 0 )
        let origin = UInt16( 0xFF00 )

        try bytes.enumerated().forEach
        {
            try memory.writeUInt8( $0.element, at: UInt64( origin ) + UInt64( $0.offset ) )
        }

        try memory.writeUInt16( origin, at: CPU.resetVector )

        let cpu = try CPU( memory: memory )

        try cpu.reset()

        return cpu
    }
}