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
    private var memory: Memory
    private var offset: UInt64

    private init( memory: Memory, offset: UInt64 )
    {
        self.memory = memory
        self.offset = offset
    }

    public class func disassemble( at address: UInt64, from memory: Memory, instructions: UInt64 = 0, error: inout Error? ) -> String
    {
        let disassembler = Disassembler( memory: memory, offset: address )
        var count        = instructions
        var disassembly  = [ ( address: UInt64, bytes: [ UInt8 ], disassembly: String ) ]()

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

    public class func disassemble( at address: UInt64, from memory: Memory, size: UInt64, error: inout Error? ) -> String
    {
        let disassembler = Disassembler( memory: memory, offset: address )
        var disassembly  = [ ( address: UInt64, bytes: [ UInt8 ], disassembly: String ) ]()

        while disassembler.offset < address + size
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

    open func format( instructions: [ ( address: UInt64, bytes: [ UInt8 ], disassembly: String ) ] ) -> String
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

    open func disassembleNextInstruction() throws -> ( address: UInt64, bytes: [ UInt8 ], disassembly: String )
    {
        let start       = self.offset
        let instruction = try self.readUInt8()
        var bytes       = [ instruction ]
        var disassembly = [ String ]()

        switch instruction
        {
            case Instructions.CLD:

                try self.cld( instruction: instruction, bytes: &bytes, disassembly: &disassembly )

            case Instructions.CLI:

                try self.cli( instruction: instruction, bytes: &bytes, disassembly: &disassembly )

            case Instructions.LDA_Immediate,
                 Instructions.LDA_ZeroPage,
                 Instructions.LDA_ZeroPageX,
                 Instructions.LDA_Absolute,
                 Instructions.LDA_AbsoluteX,
                 Instructions.LDA_AbsoluteY,
                 Instructions.LDA_IndirectX,
                 Instructions.LDA_IndirectY:

                try self.lda( instruction: instruction, bytes: &bytes, disassembly: &disassembly )

            case Instructions.LDX_Immediate,
                 Instructions.LDX_ZeroPage,
                 Instructions.LDX_ZeroPageY,
                 Instructions.LDX_Absolute,
                 Instructions.LDX_AbsoluteY:

                try self.ldx( instruction: instruction, bytes: &bytes, disassembly: &disassembly )

            case Instructions.LDY_Immediate,
                 Instructions.LDY_ZeroPage,
                 Instructions.LDY_ZeroPageX,
                 Instructions.LDY_Absolute,
                 Instructions.LDY_AbsoluteX:

                try self.ldy( instruction: instruction, bytes: &bytes, disassembly: &disassembly )

            default:

                throw RuntimeError( message: "Unhandled instruction: \( instruction.asHex )" )
        }

        return ( start, bytes, disassembly.joined( separator: " " ) )
    }

    open func cld( instruction: UInt8, bytes: inout [ UInt8 ], disassembly: inout [ String ] ) throws
    {
        disassembly.append( "CLD" )
    }

    open func cli( instruction: UInt8, bytes: inout [ UInt8 ], disassembly: inout [ String ] ) throws
    {
        disassembly.append( "CLI" )
    }

    open func lda( instruction: UInt8, bytes: inout [ UInt8 ], disassembly: inout [ String ] ) throws
    {
        throw RuntimeError( message: "Unhandled instruction: \( instruction.asHex )" )
    }

    open func ldx( instruction: UInt8, bytes: inout [ UInt8 ], disassembly: inout [ String ] ) throws
    {
        throw RuntimeError( message: "Unhandled instruction: \( instruction.asHex )" )
    }

    open func ldy( instruction: UInt8, bytes: inout [ UInt8 ], disassembly: inout [ String ] ) throws
    {
        if instruction == Instructions.LDY_Immediate
        {
            let n = try self.readUInt8()

            bytes.append( n )
            disassembly.append( "LDY" )
            disassembly.append( n.asHex )
        }
        else
        {
            throw RuntimeError( message: "Unhandled instruction: \( instruction.asHex )" )
        }
    }

    open func readUInt8() throws -> UInt8
    {
        let u        = try self.memory.readUInt8( at: self.offset )
        self.offset += 1

        return u
    }

    open func readUInt16() throws -> UInt16
    {
        let u        = try self.memory.readUInt16( at: self.offset )
        self.offset += 2

        return u
    }
}
