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

open class CPU: CustomStringConvertible
{
    public private( set ) var registers      = Registers()
    public private( set ) var cycles: UInt64 = 0

    private var memory: Memory

    public static let zeroPageStart: UInt64 = 0x0000
    public static let zeroPageEnd:   UInt64 = 0x00FF
    public static let zeroPageSize:  UInt64 = 0x00FF
    public static let stackStart:    UInt64 = 0x0100
    public static let stackEnd:      UInt64 = 0x01FF
    public static let stackSize:     UInt64 = 0x00FF
    public static let resetVector:   UInt64 = 0xFFFC
    public static let totalMemory:   UInt64 = 0xFFFF

    public convenience init() throws
    {
        try self.init( memory: try Memory( size: CPU.totalMemory, options: [ .wrapAround ], initializeTo: 0 ) )
    }

    public init( memory: Memory ) throws
    {
        if memory.size < CPU.totalMemory
        {
            throw RuntimeError( message: "Invalid memory size: must be at least 64KB" )
        }

        if memory.options.contains( .wrapAround ) == false
        {
            throw RuntimeError( message: "Invalid memory: the .wrapAround flag must be set" )
        }

        self.memory = memory

        try self.reset()
    }

    open func reset() throws
    {
        self.registers.PC = try self.memory.readUInt16( at: CPU.resetVector )
        self.registers.SP = 0
        self.registers.A  = 0
        self.registers.X  = 0
        self.registers.Y  = 0
        self.registers.PS = []
        self.cycles       = 0
    }

    open func run( cycles: UInt = 0 ) throws
    {
        while true
        {
            try self.decodeAndExecuteNextInstruction()

            if self.cycles >= cycles
            {
                break
            }
        }
    }

    open func decodeAndExecuteNextInstruction() throws
    {
        let instruction = try self.readUInt8FromMemoryAtPC()

        switch instruction
        {
            case Instructions.LDA_Immediate: try LDA.immediate( cpu: self )
            case Instructions.LDA_ZeroPage:  try LDA.zeroPage(  cpu: self )
            case Instructions.LDA_ZeroPageX: try LDA.zeroPageX( cpu: self )
            case Instructions.LDA_Absolute:  try LDA.absolute(  cpu: self )
            case Instructions.LDA_AbsoluteX: try LDA.absoluteX( cpu: self )
            case Instructions.LDA_AbsoluteY: try LDA.absoluteY( cpu: self )
            case Instructions.LDA_IndirectX: try LDA.indirectX( cpu: self )
            case Instructions.LDA_IndirectY: try LDA.indirectY( cpu: self )

            case Instructions.LDX_Immediate: try LDX.immediate( cpu: self )
            case Instructions.LDX_ZeroPage:  try LDX.zeroPage(  cpu: self )
            case Instructions.LDX_ZeroPageY: try LDX.zeroPageY( cpu: self )
            case Instructions.LDX_Absolute:  try LDX.absolute(  cpu: self )
            case Instructions.LDX_AbsoluteY: try LDX.absoluteY( cpu: self )

            case Instructions.LDY_Immediate: try LDY.immediate( cpu: self )
            case Instructions.LDY_ZeroPage:  try LDY.zeroPage(  cpu: self )
            case Instructions.LDY_ZeroPageX: try LDY.zeroPageX( cpu: self )
            case Instructions.LDY_Absolute:  try LDY.absolute(  cpu: self )
            case Instructions.LDY_AbsoluteX: try LDY.absoluteX( cpu: self )

            default: throw RuntimeError( message: "Unhandled instruction: \( instruction )" )
        }
    }

    open func readUInt8FromMemoryAtPC() throws -> UInt8
    {
        let value          = try self.readUInt8FromMemory( at: UInt64( self.registers.PC ) )
        self.registers.PC += 1

        return value
    }

    open func readUInt8FromMemory( at address: UInt64 ) throws -> UInt8
    {
        self.cycles += 1

        return try self.memory.readUInt8( at: address )
    }

    open func readUInt16FromMemory( at address: UInt64 ) throws -> UInt16
    {
        self.cycles += 2

        return try self.memory.readUInt16( at: address )
    }

    open func writeUInt8FromMemory( _ value: UInt8, at address: UInt64 ) throws
    {
        self.cycles += 1

        try self.memory.writeUInt8( value, at: address )
    }

    open func writeUInt16FromMemory( _ value: UInt16, at address: UInt64 ) throws
    {
        self.cycles += 2

        try self.memory.writeUInt16( value, at: address )
    }

    open var description: String
    {
        """
        MOS 6502
        {
            Cycles: \( self.cycles )
            {
                PC: \( self.registers.PC.asHex )
                SP: \( self.registers.SP.asHex )
                A:  \( self.registers.A.asHex )
                X:  \( self.registers.X.asHex )
                Y:  \( self.registers.Y.asHex )
                PS: \( self.registers.PS.rawValue.asHex ) (\( self.registers.PS ))
            }
        }
        """
    }
}
