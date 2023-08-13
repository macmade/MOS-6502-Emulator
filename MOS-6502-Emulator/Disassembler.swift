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
    private var source: MemoryDevice
    private var offset: UInt64

    private init( source: MemoryDevice, offset: UInt16 )
    {
        self.source = source
        self.offset = UInt64( offset )
    }

    public class func disassemble( at address: UInt16, from source: MemoryDevice, offset: UInt16, instructions: UInt = 0, comments: [ UInt16: String ] ) throws -> String
    {
        let disassembler = Disassembler( source: source, offset: address )
        var count        = instructions
        var disassembly  = [ ( address: UInt16, bytes: [ UInt8 ], disassembly: String, comment: String ) ]()

        while count > 0
        {
            count -= 1

            disassembly.append( try disassembler.disassembleNextInstruction( offset: offset, comments: comments ) )
        }

        return disassembler.format( instructions: disassembly )
    }

    public class func disassemble( at address: UInt16, from source: MemoryDevice, offset: UInt16, size: UInt16, comments: [ UInt16: String ] ) throws -> String
    {
        let disassembler = Disassembler( source: source, offset: address )
        var disassembly  = [ ( address: UInt16, bytes: [ UInt8 ], disassembly: String, comment: String ) ]()

        while disassembler.offset < UInt64( address ) + UInt64( size )
        {
            disassembly.append( try disassembler.disassembleNextInstruction( offset: offset, comments: comments ) )
        }

        return disassembler.format( instructions: disassembly )
    }

    open func format( instructions: [ ( address: UInt16, bytes: [ UInt8 ], disassembly: String, comment: String ) ] ) -> String
    {
        let maxBytes = instructions.reduce( 0 )
        {
            $0 < $1.bytes.count ? $1.bytes.count : $0
        }

        let maxDisassembly = instructions.reduce( 0 )
        {
            $0 < $1.disassembly.count ? $1.disassembly.count : $0
        }

        return instructions.map
        {
            let bytes = $0.bytes.map
            {
                String( format: "%02X", $0 )
            }
            .joined( separator: "" ).padding( toLength: maxBytes * 2, withPad: " ", startingAt: 0 )

            let disassembly = $0.comment.isEmpty ? $0.disassembly : $0.disassembly.padding( toLength: maxDisassembly, withPad: " ", startingAt: 0 )
            let comment     = $0.comment.isEmpty ? "" : " ; \( $0.comment )"

            return "\( $0.address.asHex ): \( bytes ) \( disassembly ) \( comment )"
        }
        .joined( separator: "\n" )
    }

    open func disassembleNextInstruction( offset: UInt16, comments: [ UInt16: String ] ) throws -> ( address: UInt16, bytes: [ UInt8 ], disassembly: String, comment: String )
    {
        if self.offset > UInt16.max
        {
            throw RuntimeError( message: "Cannot disassemble further: offset out of range" )
        }

        let start       = UInt16( self.offset ) + offset
        var bytes       = [ UInt8 ]()
        var disassembly = [ String ]()

        if start == UInt64( CPU.nmi )
        {
            bytes.append( contentsOf: try self.readUInt16().bytes )
            disassembly.append( "(NMI)" )
        }
        else if start == UInt64( CPU.resetVector )
        {
            bytes.append( contentsOf: try self.readUInt16().bytes )
            disassembly.append( "(RESET)" )
        }
        else if start == UInt64( CPU.irq )
        {
            bytes.append( contentsOf: try self.readUInt16().bytes )
            disassembly.append( "(IRQ)" )
        }
        else
        {
            let opcode = try self.readUInt8()

            bytes.append( opcode )

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
        }

        return ( start, bytes, disassembly.joined( separator: " " ), comments[ start ] ?? "" )
    }

    open func readUInt8() throws -> UInt8
    {
        if self.offset > UInt16.max
        {
            throw RuntimeError( message: "Offset out of range" )
        }

        let u        = try self.source.read( at: UInt16( self.offset ) )
        self.offset += 1

        return u
    }

    open func readUInt16() throws -> UInt16
    {
        if self.offset > UInt16.max
        {
            throw RuntimeError( message: "Offset out of range" )
        }

        let u1      = UInt16( try self.source.read( at: UInt16( self.offset ) ) )
        let u2      = UInt16( try self.source.read( at: UInt16( self.offset + 1 ) ) )
        self.offset += 2

        return ( u2 << 8 ) | u1
    }

    public class func disassembleROM( _ rom: ROM ) throws -> String
    {
        let disassembly = try Disassembler.disassemble( at: 0, from: rom, offset: rom.origin, size: UInt16( rom.data.count ), comments: rom.comments )

        return disassembly.components( separatedBy: "\n" ).map { "    \( $0 )" }.joined( separator: "\n" )
    }
}
