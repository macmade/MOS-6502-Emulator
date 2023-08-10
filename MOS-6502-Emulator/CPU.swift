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

open class CPU
{
    public private( set ) var registers = Registers()
    public private( set ) var memory:     Memory
    public private( set ) var cycles:     UInt64 = 0

    public convenience init() throws
    {
        try self.init( memory: try Memory( size: 64 * 1024, options: [ .wrapAround ], initializeTo: 0 ) )
    }

    public init( memory: Memory ) throws
    {
        if memory.size < 64 * 1024
        {
            throw RuntimeError( message: "Invalid memory size: must be at least 64KB" )
        }

        if memory.options.contains( .wrapAround ) == false
        {
            throw RuntimeError( message: "Invalid memory: the .wrapAround flag must be set" )
        }

        self.memory = memory

        try self.reset()
    }

    public func reset() throws
    {
        self.registers.PC          = try self.memory.readUInt16( at: 0xFFFC )
        self.registers.SP          = 0
        self.registers.A           = 0
        self.registers.X           = 0
        self.registers.Y           = 0
        self.registers.PS          = []
        self.cycles                = 7
    }

    open func run( cycles: UInt = 0 )
    {
        if cycles > 0
        {
            var cycles = cycles

            while cycles > 0
            {
                self.executeInstruction()

                cycles -= 1
            }
        }
        else
        {
            while true
            {
                self.executeInstruction()
            }
        }
    }

    open func executeInstruction()
    {}
}
