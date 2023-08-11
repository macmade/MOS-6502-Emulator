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

open class Computer
{
    private var cpu:    CPU
    private var memory: Memory

    public init() throws
    {
        self.memory = try Memory( size: CPU.totalMemory, options: [ .wrapAround ], initializeTo: 0 )
        self.cpu    = try CPU( memory: self.memory )
    }

    open func loadROM( _ rom: ROM ) throws
    {
        let data = rom.data

        guard data.isEmpty == false
        else
        {
            throw RuntimeError( message: "Cannot load empty ROM" )
        }

        try data.enumerated().forEach
        {
            try memory.writeUInt8( $0.element, at: UInt64( rom.origin ) + UInt64( $0.offset ) )
        }

        try self.memory.writeUInt16( rom.origin, at: CPU.resetVector )

        print( "Loaded ROM at \( rom.origin.asHex ): \( data.count ) bytes" )

        var error:        Error?
        let disassembly = Disassembler.disassemble( at: UInt64( rom.origin ), from: self.memory, size: UInt64( data.count ), error: &error )

        print( disassembly.components( separatedBy: "\n" ).map { "    \( $0 )" }.joined( separator: "\n" ) )

        if let error = error
        {
            print( "Disassembler error - \( error.localizedDescription )" )
        }
    }

    open func start() throws
    {
        print( "Resetting CPU and running..." )

        try self.cpu.reset()
        try self.cpu.run()
    }
}
