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

final class Test_Bus: XCTestCase
{
    private final class ReadOnlyDevice: MemoryDevice
    {
        func read( at address: UInt16 ) throws -> UInt8
        {
            return 0xAA
        }
    }

    private final class LoggerAwareDevice: MemoryDevice, LogSource
    {
        var logger: Logger?

        func read( at address: UInt16 ) throws -> UInt8
        {
            return 0
        }
    }

    private final class TestLogger: Logger
    {
        func log( text: String )
        {}

        func logInstruction( address: UInt16, bytes: [ UInt8 ], disassembly: String, registers: Registers, clock: UInt64, label: String?, comment: String? )
        {}
    }

    private final class ResettableDevice: WritableMemoryDevice, Resettable
    {
        var resetCount = 0

        func read( at address: UInt16 ) throws -> UInt8
        {
            return 0
        }

        func write( _ value: UInt8, at address: UInt16 ) throws
        {}

        func reset() throws
        {
            self.resetCount += 1
        }
    }

    private final class IRQAwareDevice: WritableMemoryDevice, IRQSource
    {
        var sendIRQ: ( ( @escaping () -> Void ) -> Void )?

        func read( at address: UInt16 ) throws -> UInt8
        {
            return 0
        }

        func write( _ value: UInt8, at address: UInt16 ) throws
        {}
    }

    func testMapDeviceRejectsOverlappingRange() throws
    {
        let bus = Bus()
        let r1  = try RAM( capacity: .b( 2 ), options: [] )
        let r2  = try RAM( capacity: .b( 2 ), options: [] )

        XCTAssertNoThrow( try bus.mapDevice( r1, at: 0x1000, size: 2 ) )
        XCTAssertThrowsError( try bus.mapDevice( r2, at: 0x1001, size: 2 ) )
    }

    func testDeviceForAddressReturnsMappedOffset() throws
    {
        let bus = Bus()
        let ram = try RAM( capacity: .b( 16 ), options: [] )

        try bus.mapDevice( ram, at: 0x2000, size: 16 )

        let mapped = try bus.deviceForAddress( 0x200A )

        XCTAssertEqual( mapped.address, 0x000A )
        XCTAssertTrue( ( mapped.device as AnyObject ) === ram )
    }

    func testDeviceForAddressThrowsForUnmappedAddress() throws
    {
        let bus = Bus()

        XCTAssertThrowsError( try bus.deviceForAddress( 0x1234 ) )
    }

    func testWritableDeviceForAddressThrowsForReadOnlyDevice() throws
    {
        let bus = Bus()
        let ro  = ReadOnlyDevice()

        try bus.mapDevice( ro, at: 0x4000, size: 1 )

        XCTAssertThrowsError( try bus.writableDeviceForAddress( 0x4000 ) )
        XCTAssertThrowsError( try bus.writeUInt8( 0x42, at: 0x4000 ) )
    }

    func testReadAndWriteUInt8UseMappedOffset() throws
    {
        let bus = Bus()
        let ram = try RAM( capacity: .b( 4 ), options: [] )

        try bus.mapDevice( ram, at: 0x3000, size: 4 )

        try bus.writeUInt8( 0x42, at: 0x3002 )

        XCTAssertEqual( try ram.read( at: 0x0002 ), 0x42 )
        XCTAssertEqual( try bus.readUInt8( at: 0x3002 ), 0x42 )
    }

    func testReadUInt16WrapsAtAddressSpaceBoundary() throws
    {
        let bus = Bus()
        let low = try RAM( capacity: .b( 1 ), options: [] )
        let high = try RAM( capacity: .b( 1 ), options: [] )

        try bus.mapDevice( low,  at: 0xFFFF, size: 1 )
        try bus.mapDevice( high, at: 0x0000, size: 1 )

        try low.write( 0x34, at: 0 )
        try high.write( 0x12, at: 0 )

        XCTAssertEqual( try bus.readUInt16( at: 0xFFFF ), 0x1234 )
    }

    func testWriteUInt16WrapsAtAddressSpaceBoundary() throws
    {
        let bus = Bus()
        let low = try RAM( capacity: .b( 1 ), options: [] )
        let high = try RAM( capacity: .b( 1 ), options: [] )

        try bus.mapDevice( low,  at: 0xFFFF, size: 1 )
        try bus.mapDevice( high, at: 0x0000, size: 1 )

        try bus.writeUInt16( 0x1234, at: 0xFFFF )

        XCTAssertEqual( try low.read( at: 0 ), 0x34 )
        XCTAssertEqual( try high.read( at: 0 ), 0x12 )
    }

    func testReadUInt16AcrossMappedDeviceBoundary() throws
    {
        let bus = Bus()
        let r1  = try RAM( capacity: .b( 1 ), options: [] )
        let r2  = try RAM( capacity: .b( 1 ), options: [] )

        try bus.mapDevice( r1, at: 0x0000, size: 1 )
        try bus.mapDevice( r2, at: 0x0001, size: 1 )

        try r1.write( 0x34, at: 0 )
        try r2.write( 0x12, at: 0 )

        XCTAssertEqual( try bus.readUInt16( at: 0x0000 ), 0x1234 )
    }

    func testWriteUInt16AcrossMappedDeviceBoundary() throws
    {
        let bus = Bus()
        let r1  = try RAM( capacity: .b( 1 ), options: [] )
        let r2  = try RAM( capacity: .b( 1 ), options: [] )

        try bus.mapDevice( r1, at: 0x0000, size: 1 )
        try bus.mapDevice( r2, at: 0x0001, size: 1 )

        try bus.writeUInt16( 0x1234, at: 0x0000 )

        XCTAssertEqual( try r1.read( at: 0 ), 0x34 )
        XCTAssertEqual( try r2.read( at: 0 ), 0x12 )
    }

    func testLoggerPropagationForExistingAndNewDevices() throws
    {
        let bus          = Bus()
        let firstDevice  = LoggerAwareDevice()
        let secondDevice = LoggerAwareDevice()
        let logger       = TestLogger()

        try bus.mapDevice( firstDevice, at: 0x1000, size: 1 )

        bus.logger = logger

        XCTAssertTrue( ( firstDevice.logger as AnyObject? ) === logger )

        try bus.mapDevice( secondDevice, at: 0x1001, size: 1 )

        XCTAssertTrue( ( secondDevice.logger as AnyObject? ) === logger )
    }

    func testMapDevicePropagatesIRQHandler() throws
    {
        let bus    = Bus()
        let device = IRQAwareDevice()

        var didReceiveIRQ = false

        bus.sendIRQ =
        {
            callback in

            callback()
        }

        try bus.mapDevice( device, at: 0x5000, size: 1 )

        device.sendIRQ?
        {
            didReceiveIRQ = true
        }

        XCTAssertTrue( didReceiveIRQ )
    }

    func testResetCallsResetOnMappedResettableDevices() throws
    {
        let bus    = Bus()
        let first  = ResettableDevice()
        let second = ResettableDevice()

        try bus.mapDevice( first,  at: 0x6000, size: 1 )
        try bus.mapDevice( second, at: 0x6001, size: 1 )

        XCTAssertEqual( first.resetCount, 0 )
        XCTAssertEqual( second.resetCount, 0 )

        try bus.reset()

        XCTAssertEqual( first.resetCount, 1 )
        XCTAssertEqual( second.resetCount, 1 )
    }
}
