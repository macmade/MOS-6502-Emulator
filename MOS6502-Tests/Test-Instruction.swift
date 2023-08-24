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

import MOS6502
import XCTest

class Test_Instruction: XCTestCase
{
    struct Flags
    {
        var C: UInt8?
        var Z: UInt8?
        var I: UInt8?
        var D: UInt8?
        var B: UInt8?
        var U: UInt8?
        var V: UInt8?
        var N: UInt8?

        init( C: UInt8? = nil, Z: UInt8? = nil, I: UInt8? = nil, D: UInt8? = nil, B: UInt8? = nil, U: UInt8? = nil, V: UInt8? = nil, N: UInt8? = nil )
        {
            self.C = C
            self.Z = Z
            self.I = I
            self.D = D
            self.B = B
            self.U = U
            self.V = V
            self.N = N
        }

        init( rawValue: UInt8 )
        {
            self.C = rawValue & ( 1 << 0 ) != 0 ? 1 : 0
            self.Z = rawValue & ( 1 << 1 ) != 0 ? 1 : 0
            self.I = rawValue & ( 1 << 2 ) != 0 ? 1 : 0
            self.D = rawValue & ( 1 << 3 ) != 0 ? 1 : 0
            self.B = rawValue & ( 1 << 4 ) != 0 ? 1 : 0
            self.U = rawValue & ( 1 << 5 ) != 0 ? 1 : 0
            self.V = rawValue & ( 1 << 6 ) != 0 ? 1 : 0
            self.N = rawValue & ( 1 << 7 ) != 0 ? 1 : 0
        }
    }

    struct Registers
    {
        var PC: UInt16? = nil
        var SP: UInt8?  = nil
        var A:  UInt8?  = nil
        var X:  UInt8?  = nil
        var Y:  UInt8?  = nil
        var PS: Flags?  = nil
    }

    private func registers( from registers: MOS6502.Registers, with additionalRegisters: Registers, defaultRegisters: UInt8?, defaultFlags: UInt8? ) -> MOS6502.Registers
    {
        var flags = MOS6502.Registers.Flags()

        if ( additionalRegisters.PS?.C ?? defaultFlags ?? ( registers.PS.contains( .carryFlag        ) ? 1 : 0 ) ) == 1 { flags.insert( .carryFlag ) }
        if ( additionalRegisters.PS?.Z ?? defaultFlags ?? ( registers.PS.contains( .zeroFlag         ) ? 1 : 0 ) ) == 1 { flags.insert( .zeroFlag ) }
        if ( additionalRegisters.PS?.I ?? defaultFlags ?? ( registers.PS.contains( .interruptDisable ) ? 1 : 0 ) ) == 1 { flags.insert( .interruptDisable ) }
        if ( additionalRegisters.PS?.D ?? defaultFlags ?? ( registers.PS.contains( .decimalMode      ) ? 1 : 0 ) ) == 1 { flags.insert( .decimalMode ) }
        if ( additionalRegisters.PS?.B ?? defaultFlags ?? ( registers.PS.contains( .breakCommand     ) ? 1 : 0 ) ) == 1 { flags.insert( .breakCommand ) }
        if ( additionalRegisters.PS?.U ?? defaultFlags ?? ( registers.PS.contains( .unused           ) ? 1 : 0 ) ) == 1 { flags.insert( .unused ) }
        if ( additionalRegisters.PS?.V ?? defaultFlags ?? ( registers.PS.contains( .overflowFlag     ) ? 1 : 0 ) ) == 1 { flags.insert( .overflowFlag ) }
        if ( additionalRegisters.PS?.N ?? defaultFlags ?? ( registers.PS.contains( .negativeFlag     ) ? 1 : 0 ) ) == 1 { flags.insert( .negativeFlag ) }

        return MOS6502.Registers(
            PC: additionalRegisters.PC ?? registers.PC,
            SP: additionalRegisters.SP ?? registers.SP,
            A:  additionalRegisters.A  ?? defaultRegisters ?? registers.A,
            X:  additionalRegisters.X  ?? defaultRegisters ?? registers.X,
            Y:  additionalRegisters.Y  ?? defaultRegisters ?? registers.Y,
            PS: flags
        )
    }

    @discardableResult
    func executeSingleInstruction( instruction: String, addressingMode: Instruction.AddressingMode, operand: UInt16, inputRegisters: Registers, outputRegisters: Registers, setup: ( ( CPU, Bus, RAM ) throws -> Void )? = nil ) throws -> ( cpu: CPU, bus: Bus, ram: RAM )
    {
        try self.executeSingleInstruction( instruction: instruction, addressingMode: addressingMode, operand: operand, origin: 0xFF00, inputRegisters: inputRegisters, outputRegisters: outputRegisters, setup: setup )
    }

    @discardableResult
    func executeSingleInstruction( instruction: String, addressingMode: Instruction.AddressingMode, operands: [ UInt8 ], inputRegisters: Registers, outputRegisters: Registers, setup: ( ( CPU, Bus, RAM ) throws -> Void )? = nil ) throws -> ( cpu: CPU, bus: Bus, ram: RAM )
    {
        try self.executeSingleInstruction( instruction: instruction, addressingMode: addressingMode, operands: operands, origin: 0xFF00, inputRegisters: inputRegisters, outputRegisters: outputRegisters, setup: setup )
    }

    @discardableResult
    func executeSingleInstruction( instruction: String, addressingMode: Instruction.AddressingMode, operand: UInt16, origin: UInt16, inputRegisters: Registers, outputRegisters: Registers, setup: ( ( CPU, Bus, RAM ) throws -> Void )? = nil ) throws -> ( cpu: CPU, bus: Bus, ram: RAM )
    {
        try self.executeSingleInstruction( instruction: instruction, addressingMode: addressingMode, operands: [ UInt8( operand & 0xFF ), UInt8( ( operand >> 8 ) & 0xFF ) ], origin: origin, inputRegisters: inputRegisters, outputRegisters: outputRegisters, setup: setup )
    }

    @discardableResult
    func executeSingleInstruction( instruction: String, addressingMode: Instruction.AddressingMode, operands: [ UInt8 ], origin: UInt16, inputRegisters: Registers, outputRegisters: Registers, setup: ( ( CPU, Bus, RAM ) throws -> Void )? = nil ) throws -> ( cpu: CPU, bus: Bus, ram: RAM )
    {
        let bus = Bus()
        let cpu = CPU( bus: bus )
        let ram = try RAM( capacity: .kb( 64 ), options: [] )

        XCTAssertNoThrow( try bus.mapDevice( ram, at: 0x00, size: ram.capacity.bytes ) )

        guard let instruction = Instruction.instruction( for: instruction, addressingMode: addressingMode )
        else
        {
            XCTAssertTrue( false, "Invalid instruction \( instruction ) \( addressingMode.description )" )

            return ( cpu, bus, ram )
        }

        try [
            ( 0x00, 0 ),
            ( 0x00, 1 ),
            ( 0x01, 0 ),
            ( 0x01, 1 ),
            ( 0x7F, 0 ),
            ( 0x7F, 1 ),
            ( 0xFF, 0 ),
            ( 0xFF, 1 ),
        ]
        .forEach
        {
            XCTAssertNoThrow( try ram.reset() )
            XCTAssertNoThrow( try ram.write( instruction.opcode, at: origin ) )

            try operands.enumerated().forEach
            {
                XCTAssertNoThrow( try ram.write( $0.element, at: origin + UInt16( $0.offset ) + 1 ) )
            }

            XCTAssertNoThrow( try ram.write( UInt8( origin & 0xFF ),          at: CPU.resetVector ) )
            XCTAssertNoThrow( try ram.write( UInt8( ( origin >> 8 ) & 0xFF ), at: CPU.resetVector + 1 ) )
            XCTAssertNoThrow( try cpu.reset() )

            let inputRegisters = self.registers( from: cpu.registers, with: inputRegisters, defaultRegisters: UInt8( $0.0 ), defaultFlags: UInt8( $0.1 ) )
            cpu.registers      = inputRegisters

            if let setup = setup
            {
                XCTAssertNoThrow( try setup( cpu, bus, ram ) )
            }

            let clock = cpu.clock

            XCTAssertNoThrow( try cpu.run( instructions: 1 ) )

            XCTAssertEqual( cpu.clock, clock + UInt64( instruction.cycles ), "Incorrect CPU cycles for instruction \( instruction.mnemonic )" )

            let expectedRegisters = self.registers( from: inputRegisters, with: outputRegisters, defaultRegisters: nil, defaultFlags: nil )

            XCTAssertEqual( cpu.registers.PC, expectedRegisters.PC, "Register mismatch for PC" )
            XCTAssertEqual( cpu.registers.SP, expectedRegisters.SP, "Register mismatch for SP" )
            XCTAssertEqual( cpu.registers.A,  expectedRegisters.A,  "Register mismatch for A" )
            XCTAssertEqual( cpu.registers.X,  expectedRegisters.X,  "Register mismatch for X" )
            XCTAssertEqual( cpu.registers.Y,  expectedRegisters.Y,  "Register mismatch for Y" )

            XCTAssertEqual( expectedRegisters.PS.contains( .carryFlag        ), cpu.registers.PS.contains( .carryFlag        ), "Register mismatch for PS: carry flag" )
            XCTAssertEqual( expectedRegisters.PS.contains( .zeroFlag         ), cpu.registers.PS.contains( .zeroFlag         ), "Register mismatch for PS: zero flag" )
            XCTAssertEqual( expectedRegisters.PS.contains( .interruptDisable ), cpu.registers.PS.contains( .interruptDisable ), "Register mismatch for PS: interrupt disable" )
            XCTAssertEqual( expectedRegisters.PS.contains( .decimalMode      ), cpu.registers.PS.contains( .decimalMode      ), "Register mismatch for PS: decimal mode" )
            XCTAssertEqual( expectedRegisters.PS.contains( .breakCommand     ), cpu.registers.PS.contains( .breakCommand     ), "Register mismatch for PS: break command" )
            XCTAssertEqual( expectedRegisters.PS.contains( .unused           ), cpu.registers.PS.contains( .unused           ), "Register mismatch for PS: unused" )
            XCTAssertEqual( expectedRegisters.PS.contains( .overflowFlag     ), cpu.registers.PS.contains( .overflowFlag     ), "Register mismatch for PS: overlfow flag" )
            XCTAssertEqual( expectedRegisters.PS.contains( .negativeFlag     ), cpu.registers.PS.contains( .negativeFlag     ), "Register mismatch for PS: negative flag" )
        }

        return ( cpu, bus, ram )
    }
}
