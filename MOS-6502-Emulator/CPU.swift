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

public class CPU
{
    public private( set ) var registers      = Registers()
    public private( set ) var cycles: UInt64 = 0

    private var bus:     Bus
    private var devices: [ ( address: UInt16, size: UInt16, device: MemoryDevice ) ] = []

    public static let zeroPageStart:  UInt16 = 0x0000
    public static let zeroPageEnd:    UInt16 = 0x00FF
    public static let zeroPageSize:   UInt16 = 0x00FF
    public static let stackStart:     UInt16 = 0x0100
    public static let stackEnd:       UInt16 = 0x01FF
    public static let stackSize:      UInt16 = 0x00FF
    public static let nmi:            UInt16 = 0xFFFA
    public static let resetVector:    UInt16 = 0xFFFC
    public static let irq:            UInt16 = 0xFFFE
    public static let requiredMemory: UInt64 = 512
    public static let maximumMemory:  UInt64 = 0xFFFF

    public init( bus: Bus )
    {
        self.bus = bus
    }

    public func reset() throws
    {
        self.registers.PC = try self.bus.readUInt16( at: CPU.resetVector )
        self.registers.SP = 0
        self.registers.A  = 0
        self.registers.X  = 0
        self.registers.Y  = 0
        self.registers.PS = []
        self.cycles       = 0
    }

    public func run() throws
    {
        try self.run( instructions: 0 )
    }

    public func run( instructions: Int ) throws
    {
        var n = instructions

        while instructions == 0 || n > 0
        {
            try self.decodeAndExecuteNextInstruction()

            if instructions != 0
            {
                n -= 1
            }
        }
    }

    private func decodeAndExecuteNextInstruction() throws
    {
        if let disassembly = try? Disassembler.disassemble( at: self.registers.PC, from: self.bus, offset: 0, instructions: 1, comments: [ : ] ),
           disassembly.isEmpty == false
        {
            print( "    \( disassembly )" )
        }

        let opcode = try self.readUInt8FromMemoryAtPC()

        if let instruction = Instructions.all.first( where: { $0.opcode == opcode } )
        {
            try instruction.execute( try self.fetchValue( for: instruction.addressingMode ), self )
        }
        else
        {
            throw RuntimeError( message: "Unhandled instruction: \( opcode.asHex )" )
        }
    }

    private func fetchValue( for addressingMode: Instruction.AddressingMode ) throws -> UInt8
    {
        switch addressingMode
        {
            case .implied:     return try self.fetchImplied()
            case .accumulator: return try self.fetchAccumulator()
            case .immediate:   return try self.fetchImmediate()
            case .zeroPage:    return try self.fetchZeroPage()
            case .zeroPageX:   return try self.fetchZeroPageX()
            case .zeroPageY:   return try self.fetchZeroPageY()
            case .relative:    return try self.fetchRelative()
            case .absolute:    return try self.fetchAbsolute()
            case .absoluteX:   return try self.fetchAbsoluteX()
            case .absoluteY:   return try self.fetchAbsoluteY()
            case .indirect:    return try self.fetchIndirect()
            case .indirectX:   return try self.fetchIndirectX()
            case .indirectY:   return try self.fetchIndirectY()
        }
    }

    private func fetchImplied() throws -> UInt8
    {
        0
    }

    private func fetchAccumulator() throws -> UInt8
    {
        self.registers.A
    }

    private func fetchImmediate() throws -> UInt8
    {
        try self.readUInt8FromMemoryAtPC()
    }

    private func fetchZeroPage() throws -> UInt8
    {
        0
    }

    private func fetchZeroPageX() throws -> UInt8
    {
        0
    }

    private func fetchZeroPageY() throws -> UInt8
    {
        0
    }

    private func fetchRelative() throws -> UInt8
    {
        0
    }

    private func fetchAbsolute() throws -> UInt8
    {
        0
    }

    private func fetchAbsoluteX() throws -> UInt8
    {
        0
    }

    private func fetchAbsoluteY() throws -> UInt8
    {
        0
    }

    private func fetchIndirect() throws -> UInt8
    {
        0
    }

    private func fetchIndirectX() throws -> UInt8
    {
        0
    }

    private func fetchIndirectY() throws -> UInt8
    {
        0
    }

    public func setFlag( _ value: Bool, for flag: Registers.Flags )
    {
        switch value
        {
            case true:  self.setFlag( flag )
            case false: self.clearFlag( flag )
        }
    }

    public func setFlag( _ flag: Registers.Flags )
    {
        self.registers.PS.insert( flag )

        self.cycles += 1
    }

    public func clearFlag( _ flag: Registers.Flags )
    {
        self.registers.PS.remove( flag )

        self.cycles += 1
    }

    public func readUInt8FromMemoryAtPC() throws -> UInt8
    {
        let value          = try self.readUInt8FromMemory( at: self.registers.PC )
        self.registers.PC += 1

        return value
    }

    public func readUInt16FromMemoryAtPC() throws -> UInt16
    {
        let value          = try self.readUInt16FromMemory( at: self.registers.PC )
        self.registers.PC += 2

        return value
    }

    public func readUInt8FromMemory( at address: UInt16 ) throws -> UInt8
    {
        let value   = try self.bus.readUInt8( at: address )
        self.cycles += 1

        return value
    }

    public func readUInt16FromMemory( at address: UInt16 ) throws -> UInt16
    {
        let value   = try self.bus.readUInt16( at: address )
        self.cycles += 2

        return value
    }

    public func writeUInt8ToMemory( _ value: UInt8, at address: UInt16 ) throws
    {
        try self.bus.writeUInt8( value, at: address )

        self.cycles += 1
    }

    public func writeUInt16ToMemory( _ value: UInt16, at address: UInt16 ) throws
    {
        try self.bus.writeUInt16( value, at: address )

        self.cycles += 2
    }
}
