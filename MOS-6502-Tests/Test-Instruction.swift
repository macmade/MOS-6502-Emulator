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

import MOS_6502_Emulator
import XCTest

class Test_Instruction: XCTestCase
{
    struct Flags
    {
        var C: UInt8
        var Z: UInt8
        var I: UInt8
        var D: UInt8
        var B: UInt8
        var V: UInt8
        var N: UInt8
    }

    struct Registers
    {
        var A:  UInt8
        var X:  UInt8
        var Y:  UInt8
        var PS: Flags
    }

    @discardableResult
    func executeSingleInstruction( instruction: Instruction, operands: [ UInt8 ], inputRegisters: Registers, outputRegisters: Registers, setup: ( ( CPU ) throws -> Void )? = nil ) throws -> CPU
    {
        let memory = try Memory< UInt16 >( size: CPU.requiredMemory, options: [ .wrapAround ], initializeTo: 0 )
        let origin = UInt16( 0xFF00 )

        XCTAssertNoThrow( try memory.writeUInt8( instruction.opcode, at: origin ) )

        try operands.enumerated().forEach
        {
            XCTAssertNoThrow( try memory.writeUInt8( $0.element, at: origin + UInt16( $0.offset ) + 1 ) )
        }

        XCTAssertNoThrow( try memory.writeUInt16( origin, at: CPU.resetVector ) )

        let cpu = try CPU( memory: memory )

        XCTAssertNoThrow( try cpu.reset() )

        cpu.registers.A  = inputRegisters.A
        cpu.registers.X  = inputRegisters.X
        cpu.registers.Y  = inputRegisters.Y
        cpu.registers.PS = []

        if inputRegisters.PS.C != 0 { cpu.registers.PS.insert( .carryFlag ) }
        if inputRegisters.PS.Z != 0 { cpu.registers.PS.insert( .zeroFlag ) }
        if inputRegisters.PS.I != 0 { cpu.registers.PS.insert( .interruptDisable ) }
        if inputRegisters.PS.D != 0 { cpu.registers.PS.insert( .decimalMode ) }
        if inputRegisters.PS.B != 0 { cpu.registers.PS.insert( .breakCommand ) }
        if inputRegisters.PS.V != 0 { cpu.registers.PS.insert( .overflowFlag ) }
        if inputRegisters.PS.N != 0 { cpu.registers.PS.insert( .negativeFlag ) }

        if let setup = setup
        {
            XCTAssertNoThrow( try setup( cpu ) )
        }

        let cycles = cpu.cycles

        XCTAssertNoThrow( try cpu.run( instructions: 1 ) )

        XCTAssertEqual( cpu.cycles, cycles + UInt64( instruction.cycles ), "Incorrect CPU cycles for instruction \( instruction.mnemonic )" )

        XCTAssertEqual( cpu.registers.A, outputRegisters.A, "Register mismatch for A" )
        XCTAssertEqual( cpu.registers.X, outputRegisters.X, "Register mismatch for X" )
        XCTAssertEqual( cpu.registers.Y, outputRegisters.Y, "Register mismatch for Y" )

        XCTAssertEqual( outputRegisters.PS.C != 0, cpu.registers.PS.contains( .carryFlag        ), "Register mismatch for PS: carry flag" )
        XCTAssertEqual( outputRegisters.PS.Z != 0, cpu.registers.PS.contains( .zeroFlag         ), "Register mismatch for PS: zero flag" )
        XCTAssertEqual( outputRegisters.PS.I != 0, cpu.registers.PS.contains( .interruptDisable ), "Register mismatch for PS: interrupt disable" )
        XCTAssertEqual( outputRegisters.PS.D != 0, cpu.registers.PS.contains( .decimalMode      ), "Register mismatch for PS: decimal mode" )
        XCTAssertEqual( outputRegisters.PS.B != 0, cpu.registers.PS.contains( .breakCommand     ), "Register mismatch for PS: break command" )
        XCTAssertEqual( outputRegisters.PS.V != 0, cpu.registers.PS.contains( .overflowFlag     ), "Register mismatch for PS: overlfow flag" )
        XCTAssertEqual( outputRegisters.PS.N != 0, cpu.registers.PS.contains( .negativeFlag     ), "Register mismatch for PS: negative flag" )

        return cpu
    }
}
