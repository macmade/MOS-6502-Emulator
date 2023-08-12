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

open class Disassembler
{
    private var memory: Memory< UInt16 >
    private var offset: UInt64

    private init( memory: Memory< UInt16 >, offset: UInt16 )
    {
        self.memory = memory
        self.offset = UInt64( offset )
    }

    public class func disassemble( at address: UInt16, from memory: Memory< UInt16 >, instructions: UInt = 0, error: inout Error? ) -> String
    {
        let disassembler = Disassembler( memory: memory, offset: address )
        var count        = instructions
        var disassembly  = [ ( address: UInt16, bytes: [ UInt8 ], disassembly: String ) ]()

        while count > 0
        {
            count -= 1

            do
            {
                disassembly.append( try disassembler.disassembleNextInstruction() )
            }
            catch let e
            {
                error = e

                break
            }
        }

        return disassembler.format( instructions: disassembly )
    }

    public class func disassemble( at address: UInt16, from memory: Memory< UInt16 >, size: UInt16, error: inout Error? ) -> String
    {
        let disassembler = Disassembler( memory: memory, offset: address )
        var disassembly  = [ ( address: UInt16, bytes: [ UInt8 ], disassembly: String ) ]()

        while disassembler.offset < UInt64( address ) + UInt64( size )
        {
            do
            {
                disassembly.append( try disassembler.disassembleNextInstruction() )
            }
            catch let e
            {
                error = e

                break
            }
        }

        return disassembler.format( instructions: disassembly )
    }

    open func format( instructions: [ ( address: UInt16, bytes: [ UInt8 ], disassembly: String ) ] ) -> String
    {
        let maxBytes = instructions.reduce( 0 )
        {
            $0 < $1.bytes.count ? $1.bytes.count : $0
        }

        return instructions.map
        {
            let bytes = $0.bytes.map
            {
                String( format: "%02X", $0 )
            }
            .joined( separator: "" ).padding( toLength: maxBytes * 2, withPad: " ", startingAt: 0 )

            return "\( $0.address.asHex ): \( bytes ) \( $0.disassembly )"
        }
        .joined( separator: "\n" )
    }

    open func disassembleNextInstruction() throws -> ( address: UInt16, bytes: [ UInt8 ], disassembly: String )
    {
        if self.offset > UInt16.max
        {
            throw RuntimeError( message: "Cannot disassemble further: offset out of range" )
        }

        let start       = UInt16( self.offset )
        let opcode      = try self.readUInt8()
        var bytes       = [ opcode ]
        var disassembly = [ String ]()

        if let instruction = Instructions.all.first( where: { $0.opcode == opcode } )
        {
            switch instruction.addressingMode
            {
                case .implicit:

                    disassembly.append( instruction.mnemonic )

                case .accumulator:

                    disassembly.append( instruction.mnemonic )

                case .immediate:

                    let value = try self.readUInt8()

                    disassembly.append( instruction.mnemonic )
                    disassembly.append( String( format: "#$%02X", value ) )
                    bytes.append( value )

                case .zeroPage:

                    let value = try self.readUInt8()

                    disassembly.append( instruction.mnemonic )
                    disassembly.append( String( format: "$%02X", value ) )
                    bytes.append( value )

                case .zeroPageX:

                    let value = try self.readUInt8()

                    disassembly.append( instruction.mnemonic )
                    disassembly.append( String( format: "$%02X,X", value ) )
                    bytes.append( value )

                case .zeroPageY:

                    let value = try self.readUInt8()

                    disassembly.append( instruction.mnemonic )
                    disassembly.append( String( format: "$%02X,Y", value ) )
                    bytes.append( value )

                case .relative:

                    let value = try self.readUInt8()

                    disassembly.append( instruction.mnemonic )
                    disassembly.append( String( format: "$%02X", value ) )
                    bytes.append( value )

                case .absolute:

                    let value = try self.readUInt16()

                    disassembly.append( instruction.mnemonic )
                    disassembly.append( String( format: "$%04X", value ) )
                    bytes.append( contentsOf: value.bytes )

                case .absoluteX:

                    let value = try self.readUInt16()

                    disassembly.append( instruction.mnemonic )
                    disassembly.append( String( format: "$%04X,X", value ) )
                    bytes.append( contentsOf: value.bytes )

                case .absoluteY:

                    let value = try self.readUInt16()

                    disassembly.append( instruction.mnemonic )
                    disassembly.append( String( format: "$%04X,Y", value ) )
                    bytes.append( contentsOf: value.bytes )

                case .indirect:

                    let value = try self.readUInt16()

                    disassembly.append( instruction.mnemonic )
                    disassembly.append( String( format: "($%04X)", value ) )
                    bytes.append( contentsOf: value.bytes )

                case .indirectX:

                    let value = try self.readUInt8()

                    disassembly.append( instruction.mnemonic )
                    disassembly.append( String( format: "($%02X,X)", value ) )
                    bytes.append( value )

                case .indirectY:

                    let value = try self.readUInt16()

                    disassembly.append( instruction.mnemonic )
                    disassembly.append( String( format: "($%04X),Y", value ) )
                    bytes.append( contentsOf: value.bytes )
            }
        }
        else
        {
            disassembly.append( "???" )
        }

        return ( start, bytes, disassembly.joined( separator: " " ) )
    }

    open func readUInt8() throws -> UInt8
    {
        if self.offset > UInt16.max
        {
            throw RuntimeError( message: "Offset out of range" )
        }

        let u        = try self.memory.readUInt8( at: UInt16( self.offset ) )
        self.offset += 1

        return u
    }

    open func readUInt16() throws -> UInt16
    {
        if self.offset > UInt16.max
        {
            throw RuntimeError( message: "Offset out of range" )
        }

        let u        = try self.memory.readUInt16( at: UInt16( self.offset ) )
        self.offset += 2

        return u
    }
}
