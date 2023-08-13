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
    private var memory: Memory< UInt16 >

    public init() throws
    {
        self.memory = try Memory( size: CPU.requiredMemory, options: [], initializeTo: 0 )
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

        guard data.count <= UInt16.max
        else
        {
            throw RuntimeError( message: "ROM is too large" )
        }

        try data.enumerated().forEach
        {
            try memory.writeUInt8( $0.element, at: rom.origin + UInt16( $0.offset ) )
        }

        try self.memory.writeUInt16( rom.origin, at: CPU.resetVector )

        print( "Loaded \( data.count ) bytes ROM at \( rom.origin.asHex ): \( rom.name )" )

        var error:            Error?
        let disassembly     = Disassembler.disassemble( at: rom.origin, from: self.memory, size: UInt16( data.count ), comments: rom.comments, error: &error )
        let disassemblyText = disassembly.components( separatedBy: "\n" ).map { "    \( $0 )" }.joined( separator: "\n" )

        if disassemblyText.trimmingCharacters( in: .whitespaces ).isEmpty == false
        {
            print( disassemblyText )
        }

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
