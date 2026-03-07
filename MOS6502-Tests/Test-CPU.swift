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

final class Test_CPU: XCTestCase
{
    private func makeCPU() throws -> ( cpu: CPU, bus: Bus, ram: RAM )
    {
        let bus = Bus()
        let cpu = CPU( bus: bus )
        let ram = try RAM( capacity: .kb( 64 ), options: [] )

        try bus.mapDevice( ram, at: 0x0000, size: ram.capacity.bytes )

        return ( cpu, bus, ram )
    }

    func testClockFrequencyNanosecondsForHz() throws
    {
        XCTAssertEqual( Clock.Frequency.hz( 0 ).nanoseconds, 1000000000 )
        XCTAssertEqual( Clock.Frequency.hz( 1 ).nanoseconds, 1000000000 )
        XCTAssertEqual( Clock.Frequency.hz( 2 ).nanoseconds, 500000000 )
    }

    func testClockFrequencyNanosecondsForKHz() throws
    {
        XCTAssertEqual( Clock.Frequency.khz( 0 ).nanoseconds, 1000000 )
        XCTAssertEqual( Clock.Frequency.khz( 1 ).nanoseconds, 1000000 )
        XCTAssertEqual( Clock.Frequency.khz( 2 ).nanoseconds, 500000 )
    }

    func testClockFrequencyNanosecondsForMHz() throws
    {
        XCTAssertEqual( Clock.Frequency.mhz( 0 ).nanoseconds, 1000 )
        XCTAssertEqual( Clock.Frequency.mhz( 1 ).nanoseconds, 1000 )
        XCTAssertEqual( Clock.Frequency.mhz( 2 ).nanoseconds, 500 )
    }

    func testResetInitializesRegistersClockWithoutStackWrites() throws
    {
        let env = try self.makeCPU()

        try env.bus.writeUInt8( 0xAA, at: 0x0100 )
        try env.bus.writeUInt8( 0xBB, at: 0x01FE )
        try env.bus.writeUInt8( 0xCC, at: 0x01FF )
        try env.bus.writeUInt16( 0x1234, at: CPU.resetVector )
        try env.cpu.reset()

        XCTAssertEqual( env.cpu.registers.PC, 0x1234 )
        XCTAssertEqual( env.cpu.registers.SP, 0xFD )
        XCTAssertEqual( env.cpu.registers.A,  0x00 )
        XCTAssertEqual( env.cpu.registers.X,  0x00 )
        XCTAssertEqual( env.cpu.registers.Y,  0x00 )
        XCTAssertEqual( env.cpu.clock, 7 )

        XCTAssertTrue(  env.cpu.registers.P.contains( .interruptDisable ) )
        XCTAssertFalse( env.cpu.registers.P.contains( .carryFlag ) )
        XCTAssertFalse( env.cpu.registers.P.contains( .zeroFlag ) )
        XCTAssertFalse( env.cpu.registers.P.contains( .decimalMode ) )
        XCTAssertFalse( env.cpu.registers.P.contains( .breakCommand ) )
        XCTAssertFalse( env.cpu.registers.P.contains( .overflowFlag ) )
        XCTAssertFalse( env.cpu.registers.P.contains( .negativeFlag ) )

        XCTAssertEqual( try env.bus.readUInt8( at: 0x0100 ), 0xAA )
        XCTAssertEqual( try env.bus.readUInt8( at: 0x01FE ), 0xBB )
        XCTAssertEqual( try env.bus.readUInt8( at: 0x01FF ), 0xCC )
    }

    func testPushAndPopUInt8FromStack() throws
    {
        let env = try self.makeCPU()

        env.cpu.registers.SP = 0xFF

        try env.cpu.pushUInt8ToStack( value: 0x42 )

        XCTAssertEqual( env.cpu.registers.SP, 0xFE )
        XCTAssertEqual( try env.bus.readUInt8( at: 0x01FF ), 0x42 )

        let value = try env.cpu.popUInt8FromStack()

        XCTAssertEqual( value, 0x42 )
        XCTAssertEqual( env.cpu.registers.SP, 0xFF )
    }

    func testPushAndPopUInt16FromStack() throws
    {
        let env = try self.makeCPU()

        env.cpu.registers.SP = 0xFF

        try env.cpu.pushUInt16ToStack( value: 0x1234 )

        XCTAssertEqual( env.cpu.registers.SP, 0xFD )
        XCTAssertEqual( try env.bus.readUInt8( at: 0x01FF ), 0x12 )
        XCTAssertEqual( try env.bus.readUInt8( at: 0x01FE ), 0x34 )

        let value = try env.cpu.popUInt16FromStack()

        XCTAssertEqual( value, 0x1234 )
        XCTAssertEqual( env.cpu.registers.SP, 0xFF )
    }

    func testSetAndClearFlagHelpers() throws
    {
        let env = try self.makeCPU()

        env.cpu.registers.P = []

        env.cpu.setFlag( .carryFlag )
        XCTAssertTrue( env.cpu.registers.P.contains( .carryFlag ) )

        env.cpu.clearFlag( .carryFlag )
        XCTAssertFalse( env.cpu.registers.P.contains( .carryFlag ) )

        env.cpu.setFlag( true, for: .zeroFlag )
        XCTAssertTrue( env.cpu.registers.P.contains( .zeroFlag ) )

        env.cpu.setFlag( false, for: .zeroFlag )
        XCTAssertFalse( env.cpu.registers.P.contains( .zeroFlag ) )
    }

    func testSetZeroAndNegativeFlags() throws
    {
        let env = try self.makeCPU()

        env.cpu.registers.P = []

        env.cpu.setZeroAndNegativeFlags( for: 0x00 )
        XCTAssertTrue(  env.cpu.registers.P.contains( .zeroFlag ) )
        XCTAssertFalse( env.cpu.registers.P.contains( .negativeFlag ) )

        env.cpu.setZeroAndNegativeFlags( for: 0x80 )
        XCTAssertFalse( env.cpu.registers.P.contains( .zeroFlag ) )
        XCTAssertTrue(  env.cpu.registers.P.contains( .negativeFlag ) )
    }

    func testReadUInt8FromMemoryAtPCAdvancesPC() throws
    {
        let env = try self.makeCPU()

        env.cpu.registers.PC = 0x2000
        try env.bus.writeUInt8( 0x42, at: 0x2000 )

        let value = try env.cpu.readUInt8FromMemoryAtPC()

        XCTAssertEqual( value, 0x42 )
        XCTAssertEqual( env.cpu.registers.PC, 0x2001 )
    }

    func testReadUInt16FromMemoryAtPCAdvancesPC() throws
    {
        let env = try self.makeCPU()

        env.cpu.registers.PC = 0x2000
        try env.bus.writeUInt8( 0x34, at: 0x2000 )
        try env.bus.writeUInt8( 0x12, at: 0x2001 )

        let value = try env.cpu.readUInt16FromMemoryAtPC()

        XCTAssertEqual( value, 0x1234 )
        XCTAssertEqual( env.cpu.registers.PC, 0x2002 )
    }

    func testReadAndWriteMemoryHelpers() throws
    {
        let env = try self.makeCPU()

        try env.cpu.writeUInt8ToMemory( 0x42, at: 0x3000 )
        XCTAssertEqual( try env.cpu.readUInt8FromMemory( at: 0x3000 ), 0x42 )

        try env.cpu.writeUInt16ToMemory( 0x1234, at: 0x3001 )
        XCTAssertEqual( try env.cpu.readUInt16FromMemory( at: 0x3001 ), 0x1234 )
    }

    func testRelativeAddressFromPCPositiveAndNegative() throws
    {
        let env = try self.makeCPU()

        env.cpu.registers.PC = 0x2000
        XCTAssertEqual( try env.cpu.relativeAddressFromPC( signedOffset: 0x10 ), 0x2010 )
        XCTAssertEqual( try env.cpu.relativeAddressFromPC( signedOffset: 0xF0 ), 0x1FF0 )
    }

    func testCycleExecutesNOPAndConsumesInstructionCycles() throws
    {
        let env = try self.makeCPU()

        try env.bus.writeUInt16( 0x4000, at: CPU.resetVector )
        try env.bus.writeUInt8( 0xEA, at: 0x4000 )
        try env.cpu.reset()

        try env.cpu.cycle()
        XCTAssertEqual( env.cpu.registers.PC, 0x4001 )
        XCTAssertEqual( env.cpu.clock, 8 )

        try env.cpu.cycle()
        XCTAssertEqual( env.cpu.clock, 9 )
    }

    func testRunExecutesMultipleInstructions() throws
    {
        let env = try self.makeCPU()

        try env.bus.writeUInt16( 0x4000, at: CPU.resetVector )
        try env.bus.writeUInt8( 0xEA, at: 0x4000 )
        try env.bus.writeUInt8( 0xEA, at: 0x4001 )
        try env.cpu.reset()

        try env.cpu.run( instructions: 2 )

        XCTAssertEqual( env.cpu.registers.PC, 0x4002 )
        XCTAssertEqual( env.cpu.clock, 11 )
        XCTAssertNotNil( env.cpu.currentContext )
    }

    func testCycleThrowsOnUnhandledInstruction() throws
    {
        let env = try self.makeCPU()

        try env.bus.writeUInt16( 0x4000, at: CPU.resetVector )
        try env.bus.writeUInt8( 0x0B, at: 0x4000 )
        try env.cpu.reset()

        XCTAssertThrowsError( try env.cpu.cycle() )
    }
}
