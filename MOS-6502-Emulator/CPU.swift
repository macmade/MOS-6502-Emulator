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

open class CPU: CustomStringConvertible
{
    public private( set ) var registers      = Registers()
    public private( set ) var cycles: UInt64 = 0

    private var memory: Memory

    public static let zeroPageStart: UInt64 = 0x0000
    public static let zeroPageEnd:   UInt64 = 0x00FF
    public static let zeroPageSize:  UInt64 = 0x00FF
    public static let stackStart:    UInt64 = 0x0100
    public static let stackEnd:      UInt64 = 0x01FF
    public static let stackSize:     UInt64 = 0x00FF
    public static let resetVector:   UInt64 = 0xFFFC
    public static let totalMemory:   UInt64 = 0xFFFF

    public convenience init() throws
    {
        try self.init( memory: try Memory( size: CPU.totalMemory, options: [ .wrapAround ], initializeTo: 0 ) )
    }

    public init( memory: Memory ) throws
    {
        if memory.size < CPU.totalMemory
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

    open func reset() throws
    {
        self.registers.PC = try self.memory.readUInt16( at: CPU.resetVector )
        self.registers.SP = 0
        self.registers.A  = 0
        self.registers.X  = 0
        self.registers.Y  = 0
        self.registers.PS = []
        self.cycles       = 0
    }

    open func run() throws
    {
        while true
        {
            try self.decodeAndExecuteNextInstruction()
        }
    }

    open func run( instructions: UInt = 0 ) throws
    {
        var n = instructions

        while instructions == 0 || n > 0
        {
            try self.decodeAndExecuteNextInstruction()

            n -= 1
        }
    }

    open func decodeAndExecuteNextInstruction() throws
    {
        var error:        Error?
        let disassembly = Disassembler.disassemble( at: UInt64( self.registers.PC ), from: self.memory, instructions: 1, error: &error )

        if error == nil, disassembly.isEmpty == false
        {
            print( "    \( disassembly )" )
        }

        let opcode = try self.readUInt8FromMemoryAtPC()

        if let instruction = Instructions.all.first( where: { $0.opcode == opcode } )
        {
            try instruction.execute( self )
        }
        else
        {
            throw RuntimeError( message: "Unhandled instruction: \( opcode.asHex )" )
        }
    }

    open func clearFlag( _ flag: Registers.Flags )
    {
        self.registers.PS.remove( flag )

        self.cycles += 1
    }

    open func readUInt8FromMemoryAtPC() throws -> UInt8
    {
        let value          = try self.readUInt8FromMemory( at: UInt64( self.registers.PC ) )
        self.registers.PC += 1

        return value
    }

    open func readUInt16FromMemoryAtPC() throws -> UInt16
    {
        let value          = try self.readUInt16FromMemory( at: UInt64( self.registers.PC ) )
        self.registers.PC += 2

        return value
    }

    open func readUInt8FromMemory( at address: UInt64 ) throws -> UInt8
    {
        self.cycles += 1

        return try self.memory.readUInt8( at: address )
    }

    open func readUInt16FromMemory( at address: UInt64 ) throws -> UInt16
    {
        self.cycles += 2

        return try self.memory.readUInt16( at: address )
    }

    open func writeUInt8ToMemory( _ value: UInt8, at address: UInt64 ) throws
    {
        self.cycles += 1

        try self.memory.writeUInt8( value, at: address )
    }

    open func writeUInt16ToMemory( _ value: UInt16, at address: UInt64 ) throws
    {
        self.cycles += 2

        try self.memory.writeUInt16( value, at: address )
    }

    open var description: String
    {
        """
        MOS 6502
        {
            Cycles: \( self.cycles )
            {
                PC: \( self.registers.PC.asHex )
                SP: \( self.registers.SP.asHex )
                A:  \( self.registers.A.asHex )
                X:  \( self.registers.X.asHex )
                Y:  \( self.registers.Y.asHex )
                PS: \( self.registers.PS.rawValue.asHex ) (\( self.registers.PS ))
            }
        }
        """
    }
}
