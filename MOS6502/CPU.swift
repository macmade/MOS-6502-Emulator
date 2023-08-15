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
import xasm65lib

public class CPU
{
    public private( set ) var registers      = Registers()
    public private( set ) var clock: UInt64 = 0

    private var bus:    Bus
    private var cycles: UInt = 0

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
        self.clock        = 0
    }

    public func cycle() throws
    {
        self.clock += 1

        if self.cycles == 0
        {
            try self.decodeAndExecuteNextInstruction()
        }
        else
        {
            self.cycles -= 1
        }
    }

    public func run( instructions: UInt ) throws
    {
        var instructions = instructions

        while instructions > 0
        {
            try self.cycle()

            while self.cycles > 0
            {
                try self.cycle()
            }

            instructions -= 1
        }
    }

    private func decodeAndExecuteNextInstruction() throws
    {
        let disassembly = try? Disassembler.disassemble(
            stream:       MemoryDeviceStream( device: self.bus, offset: self.registers.PC ),
            origin:       self.registers.PC,
            instructions: 1,
            options:      [ .address, .disassembly ],
            separator:    " "
        )

        if let disassembly = disassembly, disassembly.isEmpty == false
        {
            print( disassembly )
        }

        let opcode = try self.readUInt8FromMemoryAtPC()

        if let instruction = Instruction.all.first( where: { $0.opcode == opcode } )
        {
            guard instruction.cycles > 0
            else
            {
                throw RuntimeError( message: "Invalid cycle count for instruction \( opcode.asHex ): \( instruction.mnemonic ) \( instruction.addressingMode.description )" )
            }

            self.cycles = instruction.cycles - 1

            try instruction.execute( self, try self.context( for: instruction.addressingMode ) )
        }
        else
        {
            throw RuntimeError( message: "Unhandled instruction: \( opcode.asHex )" )
        }
    }

    private func context( for addressingMode: Instruction.AddressingMode ) throws -> AddressingContext
    {
        switch addressingMode
        {
            case .implied:     return try AddressingContext.implied(     cpu: self )
            case .accumulator: return try AddressingContext.accumulator( cpu: self )
            case .immediate:   return try AddressingContext.immediate(   cpu: self )
            case .zeroPage:    return try AddressingContext.zeroPage(    cpu: self )
            case .zeroPageX:   return try AddressingContext.zeroPageX(   cpu: self )
            case .zeroPageY:   return try AddressingContext.zeroPageY(   cpu: self )
            case .relative:    return try AddressingContext.relative(    cpu: self )
            case .absolute:    return try AddressingContext.absolute(    cpu: self )
            case .absoluteX:   return try AddressingContext.absoluteX(   cpu: self )
            case .absoluteY:   return try AddressingContext.absoluteY(   cpu: self )
            case .indirect:    return try AddressingContext.indirect(    cpu: self )
            case .indirectX:   return try AddressingContext.indirectX(   cpu: self )
            case .indirectY:   return try AddressingContext.indirectY(   cpu: self )
        }
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
    }

    public func clearFlag( _ flag: Registers.Flags )
    {
        self.registers.PS.remove( flag )
    }

    public func setZeroAndNegativeFlags( for value: UInt8 )
    {
        self.setFlag( value == 0,              for: .zeroFlag )
        self.setFlag( value & ( 1 << 7 ) != 0, for: .negativeFlag )
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
        let value = try self.bus.readUInt8( at: address )

        return value
    }

    public func readUInt16FromMemory( at address: UInt16 ) throws -> UInt16
    {
        let value = try self.bus.readUInt16( at: address )

        return value
    }

    public func writeUInt8ToMemory( _ value: UInt8, at address: UInt16 ) throws
    {
        try self.bus.writeUInt8( value, at: address )
    }

    public func writeUInt16ToMemory( _ value: UInt16, at address: UInt16 ) throws
    {
        try self.bus.writeUInt16( value, at: address )
    }
}
