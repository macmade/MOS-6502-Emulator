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

    func executeJSON( id: String ) throws
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

        let file = url.appendingPathComponent( id ).appendingPathExtension( "json" )

        guard FileManager.default.fileExists( atPath: file.path )
        else
        {
            XCTAssertTrue( false, "Cannot find the JSON file for test \( id )" )
            return
        }

        try self.executeJSONFile( url: file )
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

        XCTAssertEqual( cpu.registers.PC, test.final.pc, "\( test.name ): \( instruction ) - Register mismatch for PC" )
        XCTAssertEqual( cpu.registers.SP, test.final.s,  "\( test.name ): \( instruction ) - Register mismatch for SP" )
        XCTAssertEqual( cpu.registers.A,  test.final.a,  "\( test.name ): \( instruction ) - Register mismatch for A" )
        XCTAssertEqual( cpu.registers.X,  test.final.x,  "\( test.name ): \( instruction ) - Register mismatch for X" )
        XCTAssertEqual( cpu.registers.Y,  test.final.y,  "\( test.name ): \( instruction ) - Register mismatch for Y" )

        let flags = MOS6502.Registers.Flags( rawValue: test.final.p )

        XCTAssertEqual( flags.contains( .carryFlag        ), cpu.registers.P.contains( .carryFlag        ), "\( test.name ): \( instruction ) - Register mismatch for PS: carry flag" )
        XCTAssertEqual( flags.contains( .zeroFlag         ), cpu.registers.P.contains( .zeroFlag         ), "\( test.name ): \( instruction ) - Register mismatch for PS: zero flag" )
        XCTAssertEqual( flags.contains( .interruptDisable ), cpu.registers.P.contains( .interruptDisable ), "\( test.name ): \( instruction ) - Register mismatch for PS: interrupt disable" )
        XCTAssertEqual( flags.contains( .decimalMode      ), cpu.registers.P.contains( .decimalMode      ), "\( test.name ): \( instruction ) - Register mismatch for PS: decimal mode" )
        XCTAssertEqual( flags.contains( .breakCommand     ), cpu.registers.P.contains( .breakCommand     ), "\( test.name ): \( instruction ) - Register mismatch for PS: break command" )
        XCTAssertEqual( flags.contains( .unused           ), cpu.registers.P.contains( .unused           ), "\( test.name ): \( instruction ) - Register mismatch for PS: unused" )
        XCTAssertEqual( flags.contains( .overflowFlag     ), cpu.registers.P.contains( .overflowFlag     ), "\( test.name ): \( instruction ) - Register mismatch for PS: overlfow flag" )
        XCTAssertEqual( flags.contains( .negativeFlag     ), cpu.registers.P.contains( .negativeFlag     ), "\( test.name ): \( instruction ) - Register mismatch for PS: negative flag" )

        try test.final.ram.forEach
        {
            XCTAssertEqual( $0.value, try bus.read( at: $0.address ), "\( test.name ): \( instruction ) - RAM mismatch at \( $0.address.asHex )" )
        }
    }
    
    func test00() throws
    {
        try self.executeJSON( id: "00" )
    }
    
    func test01() throws
    {
        try self.executeJSON( id: "01" )
    }
    
    func test05() throws
    {
        try self.executeJSON( id: "05" )
    }
    
    func test06() throws
    {
        try self.executeJSON( id: "06" )
    }
    
    func test08() throws
    {
        try self.executeJSON( id: "08" )
    }
    
    func test09() throws
    {
        try self.executeJSON( id: "09" )
    }
    
    func test0A() throws
    {
        try self.executeJSON( id: "0a" )
    }
    
    func test0D() throws
    {
        try self.executeJSON( id: "0d" )
    }
    
    func test0E() throws
    {
        try self.executeJSON( id: "0e" )
    }
    
    func test10() throws
    {
        try self.executeJSON( id: "10" )
    }
    
    func test11() throws
    {
        try self.executeJSON( id: "11" )
    }
    
    func test15() throws
    {
        try self.executeJSON( id: "15" )
    }
    
    func test16() throws
    {
        try self.executeJSON( id: "16" )
    }
    
    func test18() throws
    {
        try self.executeJSON( id: "18" )
    }
    
    func test19() throws
    {
        try self.executeJSON( id: "19" )
    }
    
    func test1D() throws
    {
        try self.executeJSON( id: "1d" )
    }
    
    func test1E() throws
    {
        try self.executeJSON( id: "1e" )
    }
    
    func test20() throws
    {
        try self.executeJSON( id: "20" )
    }
    
    func test21() throws
    {
        try self.executeJSON( id: "21" )
    }
    
    func test24() throws
    {
        try self.executeJSON( id: "24" )
    }
    
    func test25() throws
    {
        try self.executeJSON( id: "25" )
    }
    
    func test26() throws
    {
        try self.executeJSON( id: "26" )
    }
    
    func test28() throws
    {
        try self.executeJSON( id: "28" )
    }
    
    func test29() throws
    {
        try self.executeJSON( id: "29" )
    }
    
    func test2A() throws
    {
        try self.executeJSON( id: "2a" )
    }
    
    func test2C() throws
    {
        try self.executeJSON( id: "2c" )
    }
    
    func test2D() throws
    {
        try self.executeJSON( id: "2d" )
    }
    
    func test2E() throws
    {
        try self.executeJSON( id: "2e" )
    }
    
    func test30() throws
    {
        try self.executeJSON( id: "30" )
    }
    
    func test31() throws
    {
        try self.executeJSON( id: "31" )
    }
    
    func test35() throws
    {
        try self.executeJSON( id: "35" )
    }
    
    func test36() throws
    {
        try self.executeJSON( id: "36" )
    }
    
    func test38() throws
    {
        try self.executeJSON( id: "38" )
    }
    
    func test39() throws
    {
        try self.executeJSON( id: "39" )
    }
    
    func test3D() throws
    {
        try self.executeJSON( id: "3d" )
    }
    
    func test3E() throws
    {
        try self.executeJSON( id: "3e" )
    }
    
    func test40() throws
    {
        try self.executeJSON( id: "40" )
    }
    
    func test41() throws
    {
        try self.executeJSON( id: "41" )
    }
    
    func test45() throws
    {
        try self.executeJSON( id: "45" )
    }
    
    func test46() throws
    {
        try self.executeJSON( id: "46" )
    }
    
    func test48() throws
    {
        try self.executeJSON( id: "48" )
    }
    
    func test49() throws
    {
        try self.executeJSON( id: "49" )
    }
    
    func test4A() throws
    {
        try self.executeJSON( id: "4a" )
    }
    
    func test4C() throws
    {
        try self.executeJSON( id: "4c" )
    }
    
    func test4D() throws
    {
        try self.executeJSON( id: "4d" )
    }
    
    func test4E() throws
    {
        try self.executeJSON( id: "4e" )
    }
    
    func test50() throws
    {
        try self.executeJSON( id: "50" )
    }
    
    func test51() throws
    {
        try self.executeJSON( id: "51" )
    }
    
    func test55() throws
    {
        try self.executeJSON( id: "55" )
    }
    
    func test56() throws
    {
        try self.executeJSON( id: "56" )
    }
    
    func test58() throws
    {
        try self.executeJSON( id: "58" )
    }
    
    func test59() throws
    {
        try self.executeJSON( id: "59" )
    }
    
    func test5D() throws
    {
        try self.executeJSON( id: "5d" )
    }
    
    func test5E() throws
    {
        try self.executeJSON( id: "5e" )
    }
    
    func test60() throws
    {
        try self.executeJSON( id: "60" )
    }
    
    func test61() throws
    {
        try self.executeJSON( id: "61" )
    }
    
    func test65() throws
    {
        try self.executeJSON( id: "65" )
    }
    
    func test66() throws
    {
        try self.executeJSON( id: "66" )
    }
    
    func test68() throws
    {
        try self.executeJSON( id: "68" )
    }
    
    func test69() throws
    {
        try self.executeJSON( id: "69" )
    }
    
    func test6A() throws
    {
        try self.executeJSON( id: "6a" )
    }
    
    func test6C() throws
    {
        try self.executeJSON( id: "6c" )
    }
    
    func test6D() throws
    {
        try self.executeJSON( id: "6d" )
    }
    
    func test6E() throws
    {
        try self.executeJSON( id: "6e" )
    }
    
    func test70() throws
    {
        try self.executeJSON( id: "70" )
    }
    
    func test71() throws
    {
        try self.executeJSON( id: "71" )
    }
    
    func test75() throws
    {
        try self.executeJSON( id: "75" )
    }
    
    func test76() throws
    {
        try self.executeJSON( id: "76" )
    }
    
    func test78() throws
    {
        try self.executeJSON( id: "78" )
    }
    
    func test79() throws
    {
        try self.executeJSON( id: "79" )
    }
    
    func test7D() throws
    {
        try self.executeJSON( id: "7d" )
    }
    
    func test7E() throws
    {
        try self.executeJSON( id: "7e" )
    }
    
    func test81() throws
    {
        try self.executeJSON( id: "81" )
    }
    
    func test84() throws
    {
        try self.executeJSON( id: "84" )
    }
    
    func test85() throws
    {
        try self.executeJSON( id: "85" )
    }
    
    func test86() throws
    {
        try self.executeJSON( id: "86" )
    }
    
    func test88() throws
    {
        try self.executeJSON( id: "88" )
    }
    
    func test8A() throws
    {
        try self.executeJSON( id: "8a" )
    }
    
    func test8C() throws
    {
        try self.executeJSON( id: "8c" )
    }
    
    func test8D() throws
    {
        try self.executeJSON( id: "8d" )
    }
    
    func test8E() throws
    {
        try self.executeJSON( id: "8e" )
    }
    
    func test90() throws
    {
        try self.executeJSON( id: "90" )
    }
    
    func test91() throws
    {
        try self.executeJSON( id: "91" )
    }
    
    func test94() throws
    {
        try self.executeJSON( id: "94" )
    }
    
    func test95() throws
    {
        try self.executeJSON( id: "95" )
    }
    
    func test96() throws
    {
        try self.executeJSON( id: "96" )
    }
    
    func test98() throws
    {
        try self.executeJSON( id: "98" )
    }
    
    func test99() throws
    {
        try self.executeJSON( id: "99" )
    }
    
    func test9A() throws
    {
        try self.executeJSON( id: "9a" )
    }
    
    func test9D() throws
    {
        try self.executeJSON( id: "9d" )
    }
    
    func testA0() throws
    {
        try self.executeJSON( id: "a0" )
    }
    
    func testA1() throws
    {
        try self.executeJSON( id: "a1" )
    }
    
    func testA2() throws
    {
        try self.executeJSON( id: "a2" )
    }
    
    func testA4() throws
    {
        try self.executeJSON( id: "a4" )
    }
    
    func testA5() throws
    {
        try self.executeJSON( id: "a5" )
    }
    
    func testA6() throws
    {
        try self.executeJSON( id: "a6" )
    }
    
    func testA8() throws
    {
        try self.executeJSON( id: "a8" )
    }
    
    func testA9() throws
    {
        try self.executeJSON( id: "a9" )
    }
    
    func testAA() throws
    {
        try self.executeJSON( id: "aa" )
    }
    
    func testAC() throws
    {
        try self.executeJSON( id: "ac" )
    }
    
    func testAD() throws
    {
        try self.executeJSON( id: "ad" )
    }
    
    func testAE() throws
    {
        try self.executeJSON( id: "ae" )
    }
    
    func testB0() throws
    {
        try self.executeJSON( id: "b0" )
    }
    
    func testB1() throws
    {
        try self.executeJSON( id: "b1" )
    }
    
    func testB4() throws
    {
        try self.executeJSON( id: "b4" )
    }
    
    func testB5() throws
    {
        try self.executeJSON( id: "b5" )
    }
    
    func testB6() throws
    {
        try self.executeJSON( id: "b6" )
    }
    
    func testB8() throws
    {
        try self.executeJSON( id: "b8" )
    }
    
    func testB9() throws
    {
        try self.executeJSON( id: "b9" )
    }
    
    func testBA() throws
    {
        try self.executeJSON( id: "ba" )
    }
    
    func testBC() throws
    {
        try self.executeJSON( id: "bc" )
    }
    
    func testBD() throws
    {
        try self.executeJSON( id: "bd" )
    }
    
    func testBE() throws
    {
        try self.executeJSON( id: "be" )
    }
    
    func testC0() throws
    {
        try self.executeJSON( id: "c0" )
    }
    
    func testC1() throws
    {
        try self.executeJSON( id: "c1" )
    }
    
    func testC4() throws
    {
        try self.executeJSON( id: "c4" )
    }
    
    func testC5() throws
    {
        try self.executeJSON( id: "c5" )
    }
    
    func testC6() throws
    {
        try self.executeJSON( id: "c6" )
    }
    
    func testC8() throws
    {
        try self.executeJSON( id: "c8" )
    }
    
    func testC9() throws
    {
        try self.executeJSON( id: "c9" )
    }
    
    func testCA() throws
    {
        try self.executeJSON( id: "ca" )
    }
    
    func testCC() throws
    {
        try self.executeJSON( id: "cc" )
    }
    
    func testCD() throws
    {
        try self.executeJSON( id: "cd" )
    }
    
    func testCE() throws
    {
        try self.executeJSON( id: "ce" )
    }
    
    func testD0() throws
    {
        try self.executeJSON( id: "d0" )
    }
    
    func testD1() throws
    {
        try self.executeJSON( id: "d1" )
    }
    
    func testD5() throws
    {
        try self.executeJSON( id: "d5" )
    }
    
    func testD6() throws
    {
        try self.executeJSON( id: "d6" )
    }
    
    func testD8() throws
    {
        try self.executeJSON( id: "d8" )
    }
    
    func testD9() throws
    {
        try self.executeJSON( id: "d9" )
    }
    
    func testDD() throws
    {
        try self.executeJSON( id: "dd" )
    }
    
    func testDE() throws
    {
        try self.executeJSON( id: "de" )
    }
    
    func testE0() throws
    {
        try self.executeJSON( id: "e0" )
    }
    
    func testE1() throws
    {
        try self.executeJSON( id: "e1" )
    }
    
    func testE4() throws
    {
        try self.executeJSON( id: "e4" )
    }
    
    func testE5() throws
    {
        try self.executeJSON( id: "e5" )
    }
    
    func testE6() throws
    {
        try self.executeJSON( id: "e6" )
    }
    
    func testE8() throws
    {
        try self.executeJSON( id: "e8" )
    }
    
    func testE9() throws
    {
        try self.executeJSON( id: "e9" )
    }
    
    func testEA() throws
    {
        try self.executeJSON( id: "ea" )
    }
    
    func testEC() throws
    {
        try self.executeJSON( id: "ec" )
    }
    
    func testED() throws
    {
        try self.executeJSON( id: "ed" )
    }
    
    func testEE() throws
    {
        try self.executeJSON( id: "ee" )
    }
    
    func testF0() throws
    {
        try self.executeJSON( id: "f0" )
    }
    
    func testF1() throws
    {
        try self.executeJSON( id: "f1" )
    }
    
    func testF5() throws
    {
        try self.executeJSON( id: "f5" )
    }
    
    func testF6() throws
    {
        try self.executeJSON( id: "f6" )
    }
    
    func testF8() throws
    {
        try self.executeJSON( id: "f8" )
    }
    
    func testF9() throws
    {
        try self.executeJSON( id: "f9" )
    }
    
    func testFD() throws
    {
        try self.executeJSON( id: "fd" )
    }
    
    func testFE() throws
    {
        try self.executeJSON( id: "fe" )
    }
}
