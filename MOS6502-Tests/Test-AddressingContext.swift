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
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 ******************************************************************************/

import MOS6502
import XCTest

final class Test_AddressingContext: XCTestCase
{
    private func makeCPU( origin: UInt16 = 0x2000, operands: [ UInt8 ] = [] ) throws -> ( cpu: CPU, bus: Bus, ram: RAM )
    {
        let bus = Bus()
        let cpu = CPU( bus: bus )
        let ram = try RAM( capacity: .kb( 64 ), options: [] )

        try bus.mapDevice( ram, at: 0x00, size: ram.capacity.bytes )
        try ram.reset( 0 )

        for ( offset, operand ) in operands.enumerated()
        {
            try ram.write( operand, at: origin + UInt16( offset ) )
        }

        cpu.registers.PC = origin

        return ( cpu, bus, ram )
    }

    private func makeInstruction( _ mnemonic: String, _ mode: Instruction.AddressingMode ) throws -> Instruction
    {
        guard let instruction = Instruction.instruction( for: mnemonic, addressingMode: mode )
        else
        {
            throw XCTSkip( "Cannot create instruction \( mnemonic ) \( mode.description )" )
        }

        return instruction
    }

    func testImmediateReadsOperandAndAdvancesPC() throws
    {
        let env         = try self.makeCPU( operands: [ 0x42 ] )
        let instruction = try self.makeInstruction( "LDA", .immediate )
        let context     = try AddressingContext.context( for: instruction, cpu: env.cpu )

        XCTAssertEqual( try context.read(), 0x42 )
        XCTAssertEqual( env.cpu.registers.PC, 0x2001 )
        XCTAssertEqual( context.extraCycles, 0 )
    }

    func testZeroPageReadAndWriteUseResolvedAddress() throws
    {
        let env         = try self.makeCPU( operands: [ 0x44 ] )
        let instruction = try self.makeInstruction( "LDA", .zeroPage )

        try env.bus.write( 0x12, at: 0x0044 )

        let context = try AddressingContext.context( for: instruction, cpu: env.cpu )

        XCTAssertEqual( try context.readAddress(), 0x0044 )
        XCTAssertEqual( try context.read(), 0x12 )

        try context.write( 0x99 )

        XCTAssertEqual( try env.bus.read( at: 0x0044 ), 0x99 )
        XCTAssertEqual( env.cpu.registers.PC, 0x2001 )
    }

    func testAbsoluteXAddsIndexAndCachesExtraCycles() throws
    {
        let env         = try self.makeCPU( operands: [ 0xFF, 0x10 ] )
        let instruction = try self.makeInstruction( "LDA", .absoluteX )

        env.cpu.registers.X = 0x01

        let context = try AddressingContext.context( for: instruction, cpu: env.cpu )

        XCTAssertEqual( try context.readAddress(), 0x1100 )
        XCTAssertEqual( context.extraCycles, 1 )
        XCTAssertEqual( try context.readAddress(), 0x1100 )
        XCTAssertEqual( context.extraCycles, 1 )
        XCTAssertEqual( env.cpu.registers.PC, 0x2002 )
    }

    func testIndirectUses6502PageBoundaryWrap() throws
    {
        let env         = try self.makeCPU( operands: [ 0xFF, 0x70 ] )
        let instruction = try self.makeInstruction( "JMP", .indirect )

        try env.bus.write( 0x9D, at: 0x70FF )
        try env.bus.write( 0x98, at: 0x7000 )
        try env.bus.write( 0xAA, at: 0x7100 )

        let context = try AddressingContext.context( for: instruction, cpu: env.cpu )

        XCTAssertEqual( try context.readAddress(), 0x989D )
        XCTAssertEqual( context.extraCycles, 0 )
        XCTAssertEqual( env.cpu.registers.PC, 0x2002 )
    }

    func testIndirectYAddsIndexAndReportsPageCrossExtraCycle() throws
    {
        let env         = try self.makeCPU( operands: [ 0x80 ] )
        let instruction = try self.makeInstruction( "LDA", .indirectY )

        env.cpu.registers.Y = 0x01

        try env.bus.write( 0xFF, at: 0x0080 )
        try env.bus.write( 0x20, at: 0x0081 )

        let context = try AddressingContext.context( for: instruction, cpu: env.cpu )

        XCTAssertEqual( try context.readAddress(), 0x2100 )
        XCTAssertEqual( context.extraCycles, 1 )
        XCTAssertEqual( env.cpu.registers.PC, 0x2001 )
    }

    func testIndirectXPointerWrapsAtZeroPageFF() throws
    {
        let env         = try self.makeCPU( operands: [ 0xFE ] )
        let instruction = try self.makeInstruction( "LDA", .indirectX )

        env.cpu.registers.X = 0x01

        try env.bus.write( 0x78, at: 0x00FF )
        try env.bus.write( 0x56, at: 0x0000 )
        try env.bus.write( 0xAB, at: 0x0100 )

        try env.bus.write( 0x42, at: 0x5678 )
        try env.bus.write( 0x99, at: 0xAB78 )

        let context = try AddressingContext.context( for: instruction, cpu: env.cpu )

        XCTAssertEqual( try context.readAddress(), 0x5678 )
        XCTAssertEqual( try context.read(), 0x42 )
        XCTAssertEqual( context.extraCycles, 0 )
        XCTAssertEqual( env.cpu.registers.PC, 0x2001 )
    }

    func testIndirectYPointerWrapsAtZeroPageFF() throws
    {
        let env         = try self.makeCPU( operands: [ 0xFF ] )
        let instruction = try self.makeInstruction( "LDA", .indirectY )

        env.cpu.registers.Y = 0x01

        try env.bus.write( 0x34, at: 0x00FF )
        try env.bus.write( 0x12, at: 0x0000 )
        try env.bus.write( 0xAB, at: 0x0100 )

        try env.bus.write( 0x42, at: 0x1235 )
        try env.bus.write( 0x99, at: 0xAB35 )

        let context = try AddressingContext.context( for: instruction, cpu: env.cpu )

        XCTAssertEqual( try context.readAddress(), 0x1235 )
        XCTAssertEqual( try context.read(), 0x42 )
        XCTAssertEqual( context.extraCycles, 0 )
        XCTAssertEqual( env.cpu.registers.PC, 0x2001 )
    }
}
