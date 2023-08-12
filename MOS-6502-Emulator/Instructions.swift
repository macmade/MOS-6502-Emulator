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

public class Instructions
{
    private init()
    {}

    public static let CLD_Implicit  = Instruction( mnemonic: "CLD", opcode: 0xD8, size: 1, cycles: 2, addressingMode: .implicit,  execute: CLD.implicit )
    public static let CLI_Implicit  = Instruction( mnemonic: "CLI", opcode: 0x58, size: 1, cycles: 2, addressingMode: .implicit,  execute: CLI.implicit )

    public static let LDA_Immediate = Instruction( mnemonic: "LDA", opcode: 0xA9, size: 2, cycles: 2, addressingMode: .immediate, execute: LDA.immediate )
    public static let LDA_ZeroPage  = Instruction( mnemonic: "LDA", opcode: 0xA5, size: 2, cycles: 3, addressingMode: .zeroPage,  execute: LDA.zeroPage )
    public static let LDA_ZeroPageX = Instruction( mnemonic: "LDA", opcode: 0xB5, size: 2, cycles: 4, addressingMode: .zeroPageX, execute: LDA.zeroPageX )
    public static let LDA_Absolute  = Instruction( mnemonic: "LDA", opcode: 0xAD, size: 3, cycles: 4, addressingMode: .absolute,  execute: LDA.absolute )
    public static let LDA_AbsoluteX = Instruction( mnemonic: "LDA", opcode: 0xBD, size: 3, cycles: 4, addressingMode: .absoluteX, execute: LDA.absoluteX )
    public static let LDA_AbsoluteY = Instruction( mnemonic: "LDA", opcode: 0xB9, size: 3, cycles: 4, addressingMode: .absoluteY, execute: LDA.absoluteY )
    public static let LDA_IndirectX = Instruction( mnemonic: "LDA", opcode: 0xA1, size: 2, cycles: 6, addressingMode: .indirectX, execute: LDA.indirectX )
    public static let LDA_IndirectY = Instruction( mnemonic: "LDA", opcode: 0xB1, size: 2, cycles: 5, addressingMode: .indirectY, execute: LDA.indirectY )

    public static let LDX_Immediate = Instruction( mnemonic: "LDX", opcode: 0xA2, size: 2, cycles: 2, addressingMode: .immediate, execute: LDX.immediate )
    public static let LDX_ZeroPage  = Instruction( mnemonic: "LDX", opcode: 0xA6, size: 2, cycles: 3, addressingMode: .zeroPage,  execute: LDX.zeroPage )
    public static let LDX_ZeroPageY = Instruction( mnemonic: "LDX", opcode: 0xB6, size: 2, cycles: 4, addressingMode: .zeroPageY, execute: LDX.zeroPageY )
    public static let LDX_Absolute  = Instruction( mnemonic: "LDX", opcode: 0xAE, size: 3, cycles: 4, addressingMode: .absolute,  execute: LDX.absolute )
    public static let LDX_AbsoluteY = Instruction( mnemonic: "LDX", opcode: 0xBE, size: 3, cycles: 4, addressingMode: .absoluteY, execute: LDX.absoluteY )

    public static let LDY_Immediate = Instruction( mnemonic: "LDY", opcode: 0xA0, size: 2, cycles: 2, addressingMode: .immediate, execute: LDY.immediate )
    public static let LDY_ZeroPage  = Instruction( mnemonic: "LDY", opcode: 0xA4, size: 2, cycles: 3, addressingMode: .zeroPage,  execute: LDY.zeroPage )
    public static let LDY_ZeroPageX = Instruction( mnemonic: "LDY", opcode: 0xB4, size: 2, cycles: 4, addressingMode: .zeroPageX, execute: LDY.zeroPageX )
    public static let LDY_Absolute  = Instruction( mnemonic: "LDY", opcode: 0xAC, size: 3, cycles: 4, addressingMode: .absolute,  execute: LDY.absolute )
    public static let LDY_AbsoluteX = Instruction( mnemonic: "LDY", opcode: 0xBC, size: 3, cycles: 4, addressingMode: .absoluteX, execute: LDY.absoluteX )

    public static let STA_ZeroPage  = Instruction( mnemonic: "STA", opcode: 0x85, size: 2, cycles: 3, addressingMode: .zeroPage,  execute: STA.zeroPage )
    public static let STA_ZeroPageY = Instruction( mnemonic: "STA", opcode: 0x95, size: 2, cycles: 4, addressingMode: .zeroPageY, execute: STA.zeroPageY )
    public static let STA_Absolute  = Instruction( mnemonic: "STA", opcode: 0x8D, size: 3, cycles: 4, addressingMode: .absolute,  execute: STA.absolute )
    public static let STA_AbsoluteX = Instruction( mnemonic: "STA", opcode: 0x9D, size: 3, cycles: 5, addressingMode: .absoluteX, execute: STA.absoluteX )
    public static let STA_AbsoluteY = Instruction( mnemonic: "STA", opcode: 0x99, size: 3, cycles: 5, addressingMode: .absoluteY, execute: STA.absoluteY )
    public static let STA_IndirectX = Instruction( mnemonic: "STA", opcode: 0x81, size: 2, cycles: 6, addressingMode: .indirectX, execute: STA.indirectX )
    public static let STA_IndirectY = Instruction( mnemonic: "STA", opcode: 0x91, size: 2, cycles: 6, addressingMode: .indirectY, execute: STA.indirectY )

    public static let STX_ZeroPage  = Instruction( mnemonic: "STX", opcode: 0x86, size: 2, cycles: 2, addressingMode: .zeroPage,  execute: STX.zeroPage )
    public static let STX_ZeroPageY = Instruction( mnemonic: "STX", opcode: 0x96, size: 2, cycles: 4, addressingMode: .zeroPageY, execute: STX.zeroPageY )
    public static let STX_Absolute  = Instruction( mnemonic: "STX", opcode: 0x8E, size: 3, cycles: 4, addressingMode: .absolute,  execute: STX.absolute )

    public static let STY_ZeroPage  = Instruction( mnemonic: "STY", opcode: 0x84, size: 2, cycles: 2, addressingMode: .zeroPage,  execute: STY.zeroPage )
    public static let STY_ZeroPageX = Instruction( mnemonic: "STY", opcode: 0x94, size: 2, cycles: 4, addressingMode: .zeroPageX, execute: STY.zeroPageX )
    public static let STY_Absolute  = Instruction( mnemonic: "STY", opcode: 0x8C, size: 3, cycles: 4, addressingMode: .absolute,  execute: STY.absolute )

    public static let all: [ Instruction ] =
        [
            CLD_Implicit,
            CLI_Implicit,
            LDA_Immediate,
            LDA_ZeroPage,
            LDA_ZeroPageX,
            LDA_Absolute,
            LDA_AbsoluteX,
            LDA_AbsoluteY,
            LDA_IndirectX,
            LDA_IndirectY,
            LDX_Immediate,
            LDX_ZeroPage,
            LDX_ZeroPageY,
            LDX_Absolute,
            LDX_AbsoluteY,
            LDY_Immediate,
            LDY_ZeroPage,
            LDY_ZeroPageX,
            LDY_Absolute,
            LDY_AbsoluteX,
            STA_ZeroPage,
            STA_ZeroPageY,
            STA_Absolute,
            STA_AbsoluteX,
            STA_AbsoluteY,
            STA_IndirectX,
            STA_IndirectY,
            STX_ZeroPage,
            STX_ZeroPageY,
            STX_Absolute,
            STY_ZeroPage,
            STY_ZeroPageX,
            STY_Absolute,
        ]
}
