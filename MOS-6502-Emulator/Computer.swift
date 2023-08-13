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

public class Computer
{
    private var cpu:    CPU
    private var bus:    Bus
    private var memory: Memory< UInt16 >

    public init( memory: UInt64 ) throws
    {
        self.bus    = Bus()
        self.memory = try Memory( size: memory, options: [], initializeTo: 0 )
        self.cpu    = CPU( bus: self.bus )

        try self.bus.mapDevice( self.memory, at: 0x00, size: UInt16( self.memory.size ) )
    }

    public func loadROM( _ rom: ROM ) throws
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
            throw RuntimeError( message: "ROM is too large: \( data.count ) bytes" )
        }

        try self.bus.mapDevice( rom, at: rom.origin, size: UInt16( rom.data.count ) )

        print( "Loaded \( data.count ) bytes ROM at \( rom.origin.asHex ): \( rom.name )" )

        if let disassembly = try? Disassembler.disassembleROM( rom ), disassembly.isEmpty == false
        {
            print( disassembly )
        }
    }

    public func reset() throws
    {
        print( "Resetting CPU and running..." )

        try self.cpu.reset()
        try self.cpu.run()
    }
}
