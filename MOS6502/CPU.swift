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
import XSLabsSwift

public class CPU: LogSource, Resettable
{
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

    public var registers = Registers()

    public var disassemblerLabels:   [ UInt16: String ] = [ : ]
    public var disassemblerComments: [ UInt16: String ] = [ : ]
    public var logger:               Logger?

    public var onReset           = Event< Void >()
    public var beforeInstruction = Event< Void >()
    public var afterInstruction  = Event< Void >()

    public private( set ) var clock:          UInt64 = 0
    public private( set ) var currentContext: AddressingContext?

    private var bus:    Bus
    private var cycles: UInt = 0
    private var irqs:   [ () -> Void ] = []

    public init( bus: Bus )
    {
        self.bus = bus
        self.bus.sendIRQ =
        {
            [ weak self ] in self?.irqs.append( $0 )
        }
    }

    public func reset() throws
    {
        self.registers.PC = try self.bus.readUInt16( at: CPU.resetVector )
        self.registers.SP = 0x00
        self.registers.A  = 0
        self.registers.X  = 0
        self.registers.Y  = 0
        self.registers.P  = [ .interruptDisable ]
        self.clock        = 7
        self.cycles       = 0

        // SP starts at 0x00. Reset pushes PC and SP, so SP will be 0xFD after reset.
        try self.pushUInt16ToStack( value: self.registers.PC )
        try self.pushUInt8ToStack(  value: self.registers.P.rawValue )

        self.onReset.fire()
    }

    public func cycle() throws
    {
        if self.cycles == 0
        {
            self.currentContext = nil

            self.beforeInstruction.fire()

            if self.registers.P.contains( .interruptDisable ) == false
            {
                let irqs  = self.irqs
                self.irqs = []

                irqs.forEach { $0() }
            }

            try self.decodeAndExecuteNextInstruction()
            self.afterInstruction.fire()
        }
        else
        {
            self.cycles -= 1
        }

        self.clock += 1
    }

    public func run( instructions: UInt ) throws
    {
        var executed = 0

        while executed < instructions
        {
            try self.cycle()

            while self.cycles > 0
            {
                try self.cycle()
            }

            executed += 1
        }
    }

    private func decodeAndExecuteNextInstruction() throws
    {
        self.logCurrentInstruction()

        let opcode = try self.readUInt8FromMemoryAtPC()

        if let instruction = Instruction.all.first( where: { $0.opcode == opcode } )
        {
            guard instruction.cycles > 0
            else
            {
                throw RuntimeError( message: "Invalid cycle count for instruction \( opcode.asHex ): \( instruction.mnemonic ) \( instruction.addressingMode.description )" )
            }

            let context         = try AddressingContext.context( for: instruction, cpu: self )
            self.currentContext = context

            try instruction.execute( self, context )

            self.cycles = ( instruction.cycles + context.extraCycles ) - 1
        }
        else
        {
            throw RuntimeError( message: "Unhandled instruction: \( opcode.asHex )" )
        }
    }

    private func logCurrentInstruction()
    {
        do
        {
            let instruction = try? Disassembler.disassemble(
                stream:       MemoryDeviceStream( device: self.bus, offset: self.registers.PC ),
                origin:       self.registers.PC,
                instructions: 1,
                options:      [ .bytes ],
                separator:    ""
            )

            let disassembly = try? Disassembler.disassemble(
                stream:       MemoryDeviceStream( device: self.bus, offset: self.registers.PC ),
                origin:       self.registers.PC,
                instructions: 1,
                options:      [ .disassembly ],
                separator:    ""
            )

            guard let instruction = instruction, let disassembly = disassembly
            else
            {
                return
            }

            let bytes = try instruction.components( separatedBy: " " ).map
            {
                guard let byte = UInt8( $0, radix: 16 )
                else
                {
                    throw RuntimeError( message: "Invalid byte: \( $0 )" )
                }

                return byte
            }

            self.logger?.logInstruction(
                address:     self.registers.PC,
                bytes:       bytes,
                disassembly: disassembly,
                registers:   self.registers.copy(),
                clock:       self.clock,
                label:       self.disassemblerLabels[ self.registers.PC ],

                comment:     self.disassemblerComments[ self.registers.PC ]
            )
        }
        catch
        {}
    }

    public func pushUInt8ToStack( value: UInt8 ) throws
    {
        try self.writeUInt8ToMemory( value, at: CPU.stackStart + UInt16( self.registers.SP ) )

        self.registers.SP &-= 1
    }

    public func pushUInt16ToStack( value: UInt16 ) throws
    {
        try self.pushUInt8ToStack( value: UInt8( ( value >> 8 ) & 0xFF ) )
        try self.pushUInt8ToStack( value: UInt8( value & 0xFF ) )
    }

    public func popUInt8FromStack() throws -> UInt8
    {
        self.registers.SP &+= 1

        return try self.readUInt8FromMemory( at: CPU.stackStart + UInt16( self.registers.SP ) )
    }

    public func popUInt16FromStack() throws -> UInt16
    {
        let u1 = UInt16( try self.popUInt8FromStack() )
        let u2 = UInt16( try self.popUInt8FromStack() )

        return ( u2 << 8 ) | u1
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
        self.registers.P.insert( flag )
    }

    public func clearFlag( _ flag: Registers.Flags )
    {
        self.registers.P.remove( flag )
    }

    public func setZeroAndNegativeFlags( for value: UInt8 )
    {
        self.setFlag( value == 0,              for: .zeroFlag )
        self.setFlag( value & ( 1 << 7 ) != 0, for: .negativeFlag )
    }

    public func readUInt8FromMemoryAtPC() throws -> UInt8
    {
        let value           = try self.readUInt8FromMemory( at: self.registers.PC )
        self.registers.PC &+= 1

        return value
    }

    public func readUInt16FromMemoryAtPC() throws -> UInt16
    {
        let value           = try self.readUInt16FromMemory( at: self.registers.PC )
        self.registers.PC &+= 2

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

    public func relativeAddressFromPC( signedOffset: UInt8 ) throws -> UInt16
    {
        let offset = Int8( bitPattern: signedOffset )
        let pc     = Int64( self.registers.PC )

        if pc + Int64( offset ) < 0 || pc + Int64( offset ) > UInt16.max
        {
            throw RuntimeError( message: "Invalid PC relative address: \( self.registers.PC.asHex ) \( offset < 0 ? "-" : "+" ) \( offset ) = \( pc + Int64( offset ) )" )
        }

        return UInt16( pc + Int64( offset ) )
    }
}
