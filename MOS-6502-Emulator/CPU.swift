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

    public init( memory: Memory< UInt16 > ) throws
    {
        if memory.size < CPU.requiredMemory
        {
            throw RuntimeError( message: "Invalid memory size: must be at least \( CPU.requiredMemory ) bytes" )
        }

        if memory.size > CPU.maximumMemory
        {
            throw RuntimeError( message: "Invalid memory size: must not be greater than \( CPU.maximumMemory ) bytes" )
        }

        try self.mapDevice( memory, at: 0x00, size: UInt16( memory.size ) )
    }

    public func mapDevice( _ device: MemoryDevice, at address: UInt16, size: UInt16 ) throws
    {
        try self.devices.forEach
        {
            let existing = ( UInt64( $0.address ) ..< UInt64( $0.address ) + UInt64( $0.size ) )
            let new      = ( UInt64( address )    ..< UInt64( address )    + UInt64( size ) )

            if new.overlaps( existing )
            {
                throw RuntimeError( message: "Cannot map device at address: \( address.asHex ): would overlap an existing device" )
            }
        }

        self.devices.append( ( address: address, size: size, device: device ) )
    }

    public func targetForAddress( _ address: UInt16 ) throws -> ( origin: UInt16, address: UInt16, device: MemoryDevice )
    {
        for mapped in self.devices
        {
            if address >= mapped.address, UInt64( address ) < UInt64( mapped.address ) + UInt64( mapped.size )
            {
                return ( origin: mapped.address, address: address - mapped.address, device: mapped.device )
            }
        }

        throw RuntimeError( message: "No mapped device for address \( address.asHex )" )
    }

    public func writeableTargetForAddress( _ address: UInt16 ) throws -> ( origin: UInt16, address: UInt16, device: WriteableMemoryDevice )
    {
        let mapped = try self.targetForAddress( address )

        guard let device = mapped.device as? WriteableMemoryDevice
        else
        {
            throw RuntimeError( message: "Invalid device for memory address \( address.asHex ): not writeable" )
        }

        return ( origin: mapped.origin, address: mapped.address, device: device )
    }

    public func reset() throws
    {
        let mapped = try self.targetForAddress( CPU.resetVector )
        let u1     = UInt16( try mapped.device.read( at: mapped.address ) )
        let u2     = UInt16( try mapped.device.read( at: mapped.address + 1 ) )

        self.registers.PC = ( u2 << 8 ) | u1
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

    public func decodeAndExecuteNextInstruction() throws
    {
        if let mapped      = try? self.targetForAddress( self.registers.PC ),
           let disassembly = try? Disassembler.disassemble( at: mapped.address, from: mapped.device, offset: mapped.origin, instructions: 1, comments: [ : ] ),
           disassembly.isEmpty == false
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
        let mapped  = try self.targetForAddress( address )
        let value   = try mapped.device.read( at: mapped.address )
        self.cycles += 1

        return value
    }

    public func readUInt16FromMemory( at address: UInt16 ) throws -> UInt16
    {
        let mapped = try self.targetForAddress( address )
        let u1     = UInt16( try mapped.device.read( at: mapped.address ) )
        let u2     = UInt16( try mapped.device.read( at: mapped.address + 1 ) )

        self.cycles += 2

        return ( u2 << 8 ) | u1
    }

    public func writeUInt8ToMemory( _ value: UInt8, at address: UInt16 ) throws
    {
        let mapped = try self.writeableTargetForAddress( address )

        try mapped.device.write( value, at: mapped.address )

        self.cycles += 1
    }

    public func writeUInt16ToMemory( _ value: UInt16, at address: UInt16 ) throws
    {
        let mapped = try self.writeableTargetForAddress( address )
        let u1     = UInt8( value & 0xFF )
        let u2     = UInt8( ( value >> 8 ) & 0xFF )

        try mapped.device.write( u1, at: mapped.address )
        try mapped.device.write( u2, at: mapped.address + 1 )

        self.cycles += 2
    }
}
