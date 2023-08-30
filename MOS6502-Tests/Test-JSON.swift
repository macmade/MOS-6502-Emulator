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
import xasm65lib
import XCTest

struct JSONTestRAMValue: Decodable
{
    var address: UInt16
    var value:   UInt8

    init( from decoder: Decoder ) throws
    {
        var container = try decoder.unkeyedContainer()
        self.address  = try container.decode( UInt16.self )
        self.value    = try container.decode( UInt8.self )
    }
}

struct JSONTestCycle: Decodable
{
    var address:   UInt16
    var value:     UInt8
    var operation: String

    init( from decoder: Decoder ) throws
    {
        var container  = try decoder.unkeyedContainer()
        self.address   = try container.decode( UInt16.self )
        self.value     = try container.decode( UInt8.self )
        self.operation = try container.decode( String.self )
    }
}

struct JSONTestState: Decodable
{
    var pc:  UInt16
    var s:   UInt8
    var a:   UInt8
    var x:   UInt8
    var y:   UInt8
    var p:   UInt8
    var ram: [ JSONTestRAMValue ]
}

struct JSONTest: Decodable
{
    var name:    String
    var initial: JSONTestState
    var final:   JSONTestState
    var cycles:  [ JSONTestCycle ]
}

final class Test_JSON: XCTestCase
{
    override func setUp()
    {
        self.continueAfterFailure = false
    }

    func testJSON() throws
    {
        var isDir = ObjCBool( false )

        guard let url = Bundle( for: Test_JSON.self ).resourceURL?.appendingPathComponent( "Tests" ),
              FileManager.default.fileExists( atPath: url.path, isDirectory: &isDir ),
              isDir.boolValue
        else
        {
            XCTAssertTrue( false, "Cannot find the 'Tests' directory" )
            return
        }

        let files = try FileManager.default.contentsOfDirectory( atPath: url.path ).map
        {
            url.appendingPathComponent( $0 )
        }

        let json = files.filter
        {
            $0.pathExtension == "json"
        }

        let valid = json.filter
        {
            guard let byte = UInt8( $0.deletingPathExtension().lastPathComponent, radix: 16 )
            else
            {
                return false
            }

            return MOS6502.Instruction.all.contains
            {
                $0.opcode == byte
            }
        }

        try valid.forEach
        {
            url in try autoreleasepool
            {
                try self.executeJSONFile( url: url )
            }
        }
    }

    func executeJSONFile( url: URL ) throws
    {
        try JSONDecoder().decode( [ JSONTest ].self, from: try Data( contentsOf: url ) ).forEach
        {
            try self.executeJSONTest( $0 )
        }
    }

    func executeJSONTest( _ test: JSONTest ) throws
    {
        let bus = Bus()
        let cpu = CPU( bus: bus )
        let ram = try RAM( capacity: .kb( 64 ), options: [] )

        XCTAssertNoThrow( try bus.mapDevice( ram, at: 0x00, size: ram.capacity.bytes ) )
        XCTAssertNoThrow( try ram.reset( UInt8( 0 ) ) )

        XCTAssertNoThrow( try cpu.reset() )

        try test.initial.ram.forEach
        {
            try bus.write( $0.value, at: $0.address )
        }

        cpu.registers.PC = test.initial.pc
        cpu.registers.SP = test.initial.s
        cpu.registers.A  = test.initial.a
        cpu.registers.X  = test.initial.x
        cpu.registers.Y  = test.initial.y
        cpu.registers.P  = MOS6502.Registers.Flags( rawValue: test.initial.p )

        let instruction = try Disassembler.disassemble(
            stream:       MemoryDeviceStream( device: bus, offset: cpu.registers.PC ),
            origin:       cpu.registers.PC,
            instructions: 1,
            options:      [ .bytes, .disassembly ],
            separator:    ": "
        )

        XCTAssertNoThrow( try cpu.run( instructions: 1 ) )

        XCTAssertEqual( cpu.registers.PC, test.final.pc, "\( instruction ) - Register mismatch for PC" )
        XCTAssertEqual( cpu.registers.SP, test.final.s,  "\( instruction ) - Register mismatch for SP" )
        XCTAssertEqual( cpu.registers.A,  test.final.a,  "\( instruction ) - Register mismatch for A" )
        XCTAssertEqual( cpu.registers.X,  test.final.x,  "\( instruction ) - Register mismatch for X" )
        XCTAssertEqual( cpu.registers.Y,  test.final.y,  "\( instruction ) - Register mismatch for Y" )

        let flags = MOS6502.Registers.Flags( rawValue: test.final.p )

        XCTAssertEqual( flags.contains( .carryFlag        ), cpu.registers.P.contains( .carryFlag        ), "\( instruction ) - Register mismatch for PS: carry flag" )
        XCTAssertEqual( flags.contains( .zeroFlag         ), cpu.registers.P.contains( .zeroFlag         ), "\( instruction ) - Register mismatch for PS: zero flag" )
        XCTAssertEqual( flags.contains( .interruptDisable ), cpu.registers.P.contains( .interruptDisable ), "\( instruction ) - Register mismatch for PS: interrupt disable" )
        XCTAssertEqual( flags.contains( .decimalMode      ), cpu.registers.P.contains( .decimalMode      ), "\( instruction ) - Register mismatch for PS: decimal mode" )
        XCTAssertEqual( flags.contains( .breakCommand     ), cpu.registers.P.contains( .breakCommand     ), "\( instruction ) - Register mismatch for PS: break command" )
        XCTAssertEqual( flags.contains( .unused           ), cpu.registers.P.contains( .unused           ), "\( instruction ) - Register mismatch for PS: unused" )
        XCTAssertEqual( flags.contains( .overflowFlag     ), cpu.registers.P.contains( .overflowFlag     ), "\( instruction ) - Register mismatch for PS: overlfow flag" )
        XCTAssertEqual( flags.contains( .negativeFlag     ), cpu.registers.P.contains( .negativeFlag     ), "\( instruction ) - Register mismatch for PS: negative flag" )

        try test.final.ram.forEach
        {
            XCTAssertEqual( $0.value, try bus.read( at: $0.address ), "\( instruction ) - RAM mismatch at \( $0.address.asHex )" )
        }
    }
}
