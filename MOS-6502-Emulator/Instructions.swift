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

    public static let ADC_Absolute    = Instruction( mnemonic: "ADC", opcode: 0x6D, size: 3, cycles: 4, addressingMode: .absolute,    execute: ADC.absolute )
    public static let ADC_AbsoluteX   = Instruction( mnemonic: "ADC", opcode: 0x7D, size: 3, cycles: 4, addressingMode: .absoluteX,   execute: ADC.absoluteX )
    public static let ADC_AbsoluteY   = Instruction( mnemonic: "ADC", opcode: 0x79, size: 3, cycles: 4, addressingMode: .absoluteY,   execute: ADC.absoluteY )
    public static let ADC_Immediate   = Instruction( mnemonic: "ADC", opcode: 0x69, size: 2, cycles: 2, addressingMode: .immediate,   execute: ADC.immediate )
    public static let ADC_IndirectX   = Instruction( mnemonic: "ADC", opcode: 0x61, size: 2, cycles: 6, addressingMode: .indirectX,   execute: ADC.indirectX )
    public static let ADC_IndirectY   = Instruction( mnemonic: "ADC", opcode: 0x71, size: 2, cycles: 5, addressingMode: .indirectY,   execute: ADC.indirectY )
    public static let ADC_ZeroPage    = Instruction( mnemonic: "ADC", opcode: 0x65, size: 2, cycles: 3, addressingMode: .zeroPage,    execute: ADC.zeroPage )
    public static let ADC_ZeroPageX   = Instruction( mnemonic: "ADC", opcode: 0x75, size: 2, cycles: 4, addressingMode: .zeroPageX,   execute: ADC.zeroPageX )
    public static let AND_Absolute    = Instruction( mnemonic: "AND", opcode: 0x2D, size: 3, cycles: 4, addressingMode: .absolute,    execute: AND.absolute )
    public static let AND_AbsoluteX   = Instruction( mnemonic: "AND", opcode: 0x3D, size: 3, cycles: 4, addressingMode: .absoluteX,   execute: AND.absoluteX )
    public static let AND_AbsoluteY   = Instruction( mnemonic: "AND", opcode: 0x39, size: 3, cycles: 4, addressingMode: .absoluteY,   execute: AND.absoluteY )
    public static let AND_Immediate   = Instruction( mnemonic: "AND", opcode: 0x29, size: 2, cycles: 2, addressingMode: .immediate,   execute: AND.immediate )
    public static let AND_IndirectX   = Instruction( mnemonic: "AND", opcode: 0x21, size: 2, cycles: 6, addressingMode: .indirectX,   execute: AND.indirectX )
    public static let AND_IndirectY   = Instruction( mnemonic: "AND", opcode: 0x31, size: 2, cycles: 5, addressingMode: .indirectY,   execute: AND.indirectY )
    public static let AND_ZeroPage    = Instruction( mnemonic: "AND", opcode: 0x25, size: 2, cycles: 3, addressingMode: .zeroPage,    execute: AND.zeroPage )
    public static let AND_ZeroPageX   = Instruction( mnemonic: "AND", opcode: 0x35, size: 2, cycles: 4, addressingMode: .zeroPageX,   execute: AND.zeroPageX )
    public static let ASL_Absolute    = Instruction( mnemonic: "ASL", opcode: 0x0E, size: 3, cycles: 6, addressingMode: .absolute,    execute: ASL.absolute )
    public static let ASL_AbsoluteX   = Instruction( mnemonic: "ASL", opcode: 0x1E, size: 3, cycles: 7, addressingMode: .absoluteX,   execute: ASL.absoluteX )
    public static let ASL_Accumulator = Instruction( mnemonic: "ASL", opcode: 0x0A, size: 1, cycles: 2, addressingMode: .accumulator, execute: ASL.accumulator )
    public static let ASL_ZeroPage    = Instruction( mnemonic: "ASL", opcode: 0x06, size: 2, cycles: 5, addressingMode: .zeroPage,    execute: ASL.zeroPage )
    public static let ASL_ZeroPageX   = Instruction( mnemonic: "ASL", opcode: 0x16, size: 2, cycles: 6, addressingMode: .zeroPageX,   execute: ASL.zeroPageX )
    public static let BCC_Relative    = Instruction( mnemonic: "BCC", opcode: 0x90, size: 2, cycles: 2, addressingMode: .relative,    execute: BCC.relative )
    public static let BCS_Relative    = Instruction( mnemonic: "BCS", opcode: 0xB0, size: 2, cycles: 2, addressingMode: .relative,    execute: BCS.relative )
    public static let BEQ_Relative    = Instruction( mnemonic: "BEQ", opcode: 0xF0, size: 2, cycles: 2, addressingMode: .relative,    execute: BEQ.relative )
    public static let BIT_Absolute    = Instruction( mnemonic: "BIT", opcode: 0x2C, size: 3, cycles: 4, addressingMode: .absolute,    execute: BIT.absolute )
    public static let BIT_ZeroPage    = Instruction( mnemonic: "BIT", opcode: 0x24, size: 2, cycles: 3, addressingMode: .zeroPage,    execute: BIT.zeroPage )
    public static let BMI_Relative    = Instruction( mnemonic: "BMI", opcode: 0x30, size: 2, cycles: 2, addressingMode: .relative,    execute: BMI.relative )
    public static let BNE_Relative    = Instruction( mnemonic: "BNE", opcode: 0xD0, size: 2, cycles: 2, addressingMode: .relative,    execute: BNE.relative )
    public static let BPL_Relative    = Instruction( mnemonic: "BPL", opcode: 0x10, size: 2, cycles: 2, addressingMode: .relative,    execute: BPL.relative )
    public static let BRK_Implicit    = Instruction( mnemonic: "BRK", opcode: 0x00, size: 1, cycles: 7, addressingMode: .implicit,    execute: BRK.implicit )
    public static let BVC_Relative    = Instruction( mnemonic: "BVC", opcode: 0x50, size: 2, cycles: 2, addressingMode: .relative,    execute: BVC.relative )
    public static let BVS_Relative    = Instruction( mnemonic: "BVS", opcode: 0x70, size: 2, cycles: 2, addressingMode: .relative,    execute: BVS.relative )
    public static let CLC_Implicit    = Instruction( mnemonic: "CLC", opcode: 0x18, size: 1, cycles: 2, addressingMode: .implicit,    execute: CLC.implicit )
    public static let CLD_Implicit    = Instruction( mnemonic: "CLD", opcode: 0xD8, size: 1, cycles: 2, addressingMode: .implicit,    execute: CLD.implicit )
    public static let CLI_Implicit    = Instruction( mnemonic: "CLI", opcode: 0x58, size: 1, cycles: 2, addressingMode: .implicit,    execute: CLI.implicit )
    public static let CLV_Implicit    = Instruction( mnemonic: "CLV", opcode: 0xB8, size: 1, cycles: 2, addressingMode: .implicit,    execute: CLV.implicit )
    public static let CMP_Absolute    = Instruction( mnemonic: "CMP", opcode: 0xCD, size: 3, cycles: 4, addressingMode: .absolute,    execute: CMP.absolute )
    public static let CMP_AbsoluteX   = Instruction( mnemonic: "CMP", opcode: 0xDD, size: 3, cycles: 4, addressingMode: .absoluteX,   execute: CMP.absoluteX )
    public static let CMP_AbsoluteY   = Instruction( mnemonic: "CMP", opcode: 0xD9, size: 3, cycles: 4, addressingMode: .absoluteY,   execute: CMP.absoluteY )
    public static let CMP_Immediate   = Instruction( mnemonic: "CMP", opcode: 0xC9, size: 2, cycles: 2, addressingMode: .immediate,   execute: CMP.immediate )
    public static let CMP_IndirectX   = Instruction( mnemonic: "CMP", opcode: 0xC1, size: 2, cycles: 6, addressingMode: .indirectX,   execute: CMP.indirectX )
    public static let CMP_IndirectY   = Instruction( mnemonic: "CMP", opcode: 0xD1, size: 2, cycles: 5, addressingMode: .indirectY,   execute: CMP.indirectY )
    public static let CMP_ZeroPage    = Instruction( mnemonic: "CMP", opcode: 0xC5, size: 2, cycles: 3, addressingMode: .zeroPage,    execute: CMP.zeroPage )
    public static let CMP_ZeroPageX   = Instruction( mnemonic: "CMP", opcode: 0xD5, size: 2, cycles: 4, addressingMode: .zeroPageX,   execute: CMP.zeroPageX )
    public static let CPX_Absolute    = Instruction( mnemonic: "CPX", opcode: 0xEC, size: 3, cycles: 4, addressingMode: .absolute,    execute: CPX.absolute )
    public static let CPX_Immediate   = Instruction( mnemonic: "CPX", opcode: 0xE0, size: 2, cycles: 2, addressingMode: .immediate,   execute: CPX.immediate )
    public static let CPX_ZeroPage    = Instruction( mnemonic: "CPX", opcode: 0xE4, size: 2, cycles: 3, addressingMode: .zeroPage,    execute: CPX.zeroPage )
    public static let CPY_Absolute    = Instruction( mnemonic: "CPY", opcode: 0xCC, size: 3, cycles: 4, addressingMode: .absolute,    execute: CPY.absolute )
    public static let CPY_Immediate   = Instruction( mnemonic: "CPY", opcode: 0xC0, size: 2, cycles: 2, addressingMode: .immediate,   execute: CPY.immediate )
    public static let CPY_ZeroPage    = Instruction( mnemonic: "CPY", opcode: 0xC4, size: 2, cycles: 3, addressingMode: .zeroPage,    execute: CPY.zeroPage )
    public static let DEC_Absolute    = Instruction( mnemonic: "DEC", opcode: 0xCE, size: 3, cycles: 6, addressingMode: .absolute,    execute: DEC.absolute )
    public static let DEC_AbsoluteX   = Instruction( mnemonic: "DEC", opcode: 0xDE, size: 3, cycles: 7, addressingMode: .absoluteX,   execute: DEC.absoluteX )
    public static let DEC_ZeroPage    = Instruction( mnemonic: "DEC", opcode: 0xC6, size: 2, cycles: 5, addressingMode: .zeroPage,    execute: DEC.zeroPage )
    public static let DEC_ZeroPageX   = Instruction( mnemonic: "DEC", opcode: 0xD6, size: 2, cycles: 6, addressingMode: .zeroPageX,   execute: DEC.zeroPageX )
    public static let DEX_Implicit    = Instruction( mnemonic: "DEX", opcode: 0xCA, size: 1, cycles: 2, addressingMode: .implicit,    execute: DEX.implicit )
    public static let DEY_Implicit    = Instruction( mnemonic: "DEY", opcode: 0x88, size: 1, cycles: 2, addressingMode: .implicit,    execute: DEY.implicit )
    public static let EOR_Absolute    = Instruction( mnemonic: "EOR", opcode: 0x4D, size: 3, cycles: 4, addressingMode: .absolute,    execute: EOR.absolute )
    public static let EOR_AbsoluteX   = Instruction( mnemonic: "EOR", opcode: 0x5D, size: 3, cycles: 4, addressingMode: .absoluteX,   execute: EOR.absoluteX )
    public static let EOR_AbsoluteY   = Instruction( mnemonic: "EOR", opcode: 0x59, size: 3, cycles: 4, addressingMode: .absoluteY,   execute: EOR.absoluteY )
    public static let EOR_Immediate   = Instruction( mnemonic: "EOR", opcode: 0x49, size: 2, cycles: 2, addressingMode: .immediate,   execute: EOR.immediate )
    public static let EOR_IndirectX   = Instruction( mnemonic: "EOR", opcode: 0x41, size: 2, cycles: 6, addressingMode: .indirectX,   execute: EOR.indirectX )
    public static let EOR_IndirectY   = Instruction( mnemonic: "EOR", opcode: 0x51, size: 2, cycles: 5, addressingMode: .indirectY,   execute: EOR.indirectY )
    public static let EOR_ZeroPage    = Instruction( mnemonic: "EOR", opcode: 0x45, size: 2, cycles: 3, addressingMode: .zeroPage,    execute: EOR.zeroPage )
    public static let EOR_ZeroPageX   = Instruction( mnemonic: "EOR", opcode: 0x55, size: 2, cycles: 4, addressingMode: .zeroPageX,   execute: EOR.zeroPageX )
    public static let INC_Absolute    = Instruction( mnemonic: "INC", opcode: 0xEE, size: 3, cycles: 6, addressingMode: .absolute,    execute: INC.absolute )
    public static let INC_AbsoluteX   = Instruction( mnemonic: "INC", opcode: 0xFE, size: 3, cycles: 7, addressingMode: .absoluteX,   execute: INC.absoluteX )
    public static let INC_ZeroPage    = Instruction( mnemonic: "INC", opcode: 0xE6, size: 2, cycles: 5, addressingMode: .zeroPage,    execute: INC.zeroPage )
    public static let INC_ZeroPageX   = Instruction( mnemonic: "INC", opcode: 0xF6, size: 2, cycles: 6, addressingMode: .zeroPageX,   execute: INC.zeroPageX )
    public static let INX_Implicit    = Instruction( mnemonic: "INX", opcode: 0xE8, size: 1, cycles: 2, addressingMode: .implicit,    execute: INX.implicit )
    public static let INY_Implicit    = Instruction( mnemonic: "INY", opcode: 0xC8, size: 1, cycles: 2, addressingMode: .implicit,    execute: INY.implicit )
    public static let JMP_Absolute    = Instruction( mnemonic: "XXX", opcode: 0x4C, size: 3, cycles: 3, addressingMode: .absolute,    execute: JMP.absolute )
    public static let JMP_Indirect    = Instruction( mnemonic: "XXX", opcode: 0x6C, size: 3, cycles: 5, addressingMode: .indirect,    execute: JMP.indirect )
    public static let JSR_Absolute    = Instruction( mnemonic: "JSR", opcode: 0x20, size: 3, cycles: 6, addressingMode: .absolute,    execute: JSR.absolute )
    public static let LDA_Absolute    = Instruction( mnemonic: "LDA", opcode: 0xAD, size: 3, cycles: 4, addressingMode: .absolute,    execute: LDA.absolute )
    public static let LDA_AbsoluteX   = Instruction( mnemonic: "LDA", opcode: 0xBD, size: 3, cycles: 4, addressingMode: .absoluteX,   execute: LDA.absoluteX )
    public static let LDA_AbsoluteY   = Instruction( mnemonic: "LDA", opcode: 0xB9, size: 3, cycles: 4, addressingMode: .absoluteY,   execute: LDA.absoluteY )
    public static let LDA_Immediate   = Instruction( mnemonic: "LDA", opcode: 0xA9, size: 2, cycles: 2, addressingMode: .immediate,   execute: LDA.immediate )
    public static let LDA_IndirectX   = Instruction( mnemonic: "LDA", opcode: 0xA1, size: 2, cycles: 6, addressingMode: .indirectX,   execute: LDA.indirectX )
    public static let LDA_IndirectY   = Instruction( mnemonic: "LDA", opcode: 0xB1, size: 2, cycles: 5, addressingMode: .indirectY,   execute: LDA.indirectY )
    public static let LDA_ZeroPage    = Instruction( mnemonic: "LDA", opcode: 0xA5, size: 2, cycles: 3, addressingMode: .zeroPage,    execute: LDA.zeroPage )
    public static let LDA_ZeroPageX   = Instruction( mnemonic: "LDA", opcode: 0xB5, size: 2, cycles: 4, addressingMode: .zeroPageX,   execute: LDA.zeroPageX )
    public static let LDX_Absolute    = Instruction( mnemonic: "LDX", opcode: 0xAE, size: 3, cycles: 4, addressingMode: .absolute,    execute: LDX.absolute )
    public static let LDX_AbsoluteY   = Instruction( mnemonic: "LDX", opcode: 0xBE, size: 3, cycles: 4, addressingMode: .absoluteY,   execute: LDX.absoluteY )
    public static let LDX_Immediate   = Instruction( mnemonic: "LDX", opcode: 0xA2, size: 2, cycles: 2, addressingMode: .immediate,   execute: LDX.immediate )
    public static let LDX_ZeroPage    = Instruction( mnemonic: "LDX", opcode: 0xA6, size: 2, cycles: 3, addressingMode: .zeroPage,    execute: LDX.zeroPage )
    public static let LDX_ZeroPageY   = Instruction( mnemonic: "LDX", opcode: 0xB6, size: 2, cycles: 4, addressingMode: .zeroPageY,   execute: LDX.zeroPageY )
    public static let LDY_Absolute    = Instruction( mnemonic: "LDY", opcode: 0xAC, size: 3, cycles: 4, addressingMode: .absolute,    execute: LDY.absolute )
    public static let LDY_AbsoluteX   = Instruction( mnemonic: "LDY", opcode: 0xBC, size: 3, cycles: 4, addressingMode: .absoluteX,   execute: LDY.absoluteX )
    public static let LDY_Immediate   = Instruction( mnemonic: "LDY", opcode: 0xA0, size: 2, cycles: 2, addressingMode: .immediate,   execute: LDY.immediate )
    public static let LDY_ZeroPage    = Instruction( mnemonic: "LDY", opcode: 0xA4, size: 2, cycles: 3, addressingMode: .zeroPage,    execute: LDY.zeroPage )
    public static let LDY_ZeroPageX   = Instruction( mnemonic: "LDY", opcode: 0xB4, size: 2, cycles: 4, addressingMode: .zeroPageX,   execute: LDY.zeroPageX )
    public static let LSR_Absolute    = Instruction( mnemonic: "LSR", opcode: 0x4E, size: 3, cycles: 6, addressingMode: .absolute,    execute: LSR.absolute )
    public static let LSR_AbsoluteX   = Instruction( mnemonic: "LSR", opcode: 0x5E, size: 3, cycles: 7, addressingMode: .absoluteX,   execute: LSR.absoluteX )
    public static let LSR_Accumulator = Instruction( mnemonic: "LSR", opcode: 0x4A, size: 1, cycles: 2, addressingMode: .accumulator, execute: LSR.accumulator )
    public static let LSR_ZeroPage    = Instruction( mnemonic: "LSR", opcode: 0x46, size: 2, cycles: 5, addressingMode: .zeroPage,    execute: LSR.zeroPage )
    public static let LSR_ZeroPageX   = Instruction( mnemonic: "LSR", opcode: 0x56, size: 2, cycles: 6, addressingMode: .zeroPageX,   execute: LSR.zeroPageX )
    public static let NOP_Implicit    = Instruction( mnemonic: "NOP", opcode: 0xEA, size: 1, cycles: 2, addressingMode: .implicit,    execute: NOP.implicit )
    public static let ORA_Absolute    = Instruction( mnemonic: "ORA", opcode: 0x0D, size: 3, cycles: 4, addressingMode: .absolute,    execute: ORA.absolute )
    public static let ORA_AbsoluteX   = Instruction( mnemonic: "ORA", opcode: 0x1D, size: 3, cycles: 4, addressingMode: .absoluteX,   execute: ORA.absoluteX )
    public static let ORA_AbsoluteY   = Instruction( mnemonic: "ORA", opcode: 0x19, size: 3, cycles: 4, addressingMode: .absoluteY,   execute: ORA.absoluteY )
    public static let ORA_Immediate   = Instruction( mnemonic: "ORA", opcode: 0x09, size: 2, cycles: 2, addressingMode: .immediate,   execute: ORA.immediate )
    public static let ORA_IndirectX   = Instruction( mnemonic: "ORA", opcode: 0x01, size: 2, cycles: 6, addressingMode: .indirectX,   execute: ORA.indirectX )
    public static let ORA_IndirectY   = Instruction( mnemonic: "ORA", opcode: 0x11, size: 2, cycles: 5, addressingMode: .indirectY,   execute: ORA.indirectY )
    public static let ORA_ZeroPage    = Instruction( mnemonic: "ORA", opcode: 0x05, size: 2, cycles: 3, addressingMode: .zeroPage,    execute: ORA.zeroPage )
    public static let ORA_ZeroPageX   = Instruction( mnemonic: "ORA", opcode: 0x15, size: 2, cycles: 4, addressingMode: .zeroPageX,   execute: ORA.zeroPageX )
    public static let PHA_Implicit    = Instruction( mnemonic: "PHA", opcode: 0x48, size: 1, cycles: 3, addressingMode: .implicit,    execute: PHA.implicit )
    public static let PHP_Implicit    = Instruction( mnemonic: "PHP", opcode: 0x08, size: 1, cycles: 3, addressingMode: .implicit,    execute: PHP.implicit )
    public static let PLA_Implicit    = Instruction( mnemonic: "PLA", opcode: 0x68, size: 1, cycles: 4, addressingMode: .implicit,    execute: PLA.implicit )
    public static let PLP_Implicit    = Instruction( mnemonic: "PLP", opcode: 0x28, size: 1, cycles: 4, addressingMode: .implicit,    execute: PLP.implicit )
    public static let ROL_Absolute    = Instruction( mnemonic: "ROL", opcode: 0x2E, size: 3, cycles: 6, addressingMode: .absolute,    execute: ROL.absolute )
    public static let ROL_AbsoluteX   = Instruction( mnemonic: "ROL", opcode: 0x3E, size: 3, cycles: 7, addressingMode: .absoluteX,   execute: ROL.absoluteX )
    public static let ROL_Accumulator = Instruction( mnemonic: "ROL", opcode: 0x2A, size: 1, cycles: 2, addressingMode: .accumulator, execute: ROL.accumulator )
    public static let ROL_ZeroPage    = Instruction( mnemonic: "ROL", opcode: 0x26, size: 2, cycles: 5, addressingMode: .zeroPage,    execute: ROL.zeroPage )
    public static let ROL_ZeroPageX   = Instruction( mnemonic: "ROL", opcode: 0x36, size: 2, cycles: 6, addressingMode: .zeroPageX,   execute: ROL.zeroPageX )
    public static let ROR_Absolute    = Instruction( mnemonic: "ROR", opcode: 0x6E, size: 3, cycles: 6, addressingMode: .absolute,    execute: ROR.absolute )
    public static let ROR_AbsoluteX   = Instruction( mnemonic: "ROR", opcode: 0x7E, size: 3, cycles: 7, addressingMode: .absoluteX,   execute: ROR.absoluteX )
    public static let ROR_Accumulator = Instruction( mnemonic: "ROR", opcode: 0x6A, size: 1, cycles: 2, addressingMode: .accumulator, execute: ROR.accumulator )
    public static let ROR_ZeroPage    = Instruction( mnemonic: "ROR", opcode: 0x66, size: 2, cycles: 5, addressingMode: .zeroPage,    execute: ROR.zeroPage )
    public static let ROR_ZeroPageX   = Instruction( mnemonic: "ROR", opcode: 0x76, size: 2, cycles: 6, addressingMode: .zeroPageX,   execute: ROR.zeroPageX )
    public static let RTI_Implicit    = Instruction( mnemonic: "RTI", opcode: 0x40, size: 1, cycles: 6, addressingMode: .implicit,    execute: RTI.implicit )
    public static let RTS_Implicit    = Instruction( mnemonic: "RTS", opcode: 0x60, size: 1, cycles: 6, addressingMode: .implicit,    execute: RTS.implicit )
    public static let SBC_Absolute    = Instruction( mnemonic: "SBC", opcode: 0xED, size: 3, cycles: 4, addressingMode: .absolute,    execute: SBC.absolute )
    public static let SBC_AbsoluteX   = Instruction( mnemonic: "SBC", opcode: 0xFD, size: 3, cycles: 4, addressingMode: .absoluteX,   execute: SBC.absoluteX )
    public static let SBC_AbsoluteY   = Instruction( mnemonic: "SBC", opcode: 0xF9, size: 3, cycles: 4, addressingMode: .absoluteY,   execute: SBC.absoluteY )
    public static let SBC_Immediate   = Instruction( mnemonic: "SBC", opcode: 0xE9, size: 2, cycles: 2, addressingMode: .immediate,   execute: SBC.immediate )
    public static let SBC_IndirectX   = Instruction( mnemonic: "SBC", opcode: 0xE1, size: 2, cycles: 6, addressingMode: .indirectX,   execute: SBC.indirectX )
    public static let SBC_IndirectY   = Instruction( mnemonic: "SBC", opcode: 0xF1, size: 2, cycles: 5, addressingMode: .indirectY,   execute: SBC.indirectY )
    public static let SBC_ZeroPage    = Instruction( mnemonic: "SBC", opcode: 0xE5, size: 2, cycles: 3, addressingMode: .zeroPage,    execute: SBC.zeroPage )
    public static let SBC_ZeroPageX   = Instruction( mnemonic: "SBC", opcode: 0xF5, size: 2, cycles: 4, addressingMode: .zeroPageX,   execute: SBC.zeroPageX )
    public static let SEC_Implicit    = Instruction( mnemonic: "SEC", opcode: 0x38, size: 1, cycles: 2, addressingMode: .implicit,    execute: SEC.implicit )
    public static let SED_Implicit    = Instruction( mnemonic: "SED", opcode: 0xF8, size: 1, cycles: 2, addressingMode: .implicit,    execute: SED.implicit )
    public static let SEI_Implicit    = Instruction( mnemonic: "SEI", opcode: 0x78, size: 1, cycles: 2, addressingMode: .implicit,    execute: SEI.implicit )
    public static let STA_Absolute    = Instruction( mnemonic: "STA", opcode: 0x8D, size: 3, cycles: 4, addressingMode: .absolute,    execute: STA.absolute )
    public static let STA_AbsoluteX   = Instruction( mnemonic: "STA", opcode: 0x9D, size: 3, cycles: 5, addressingMode: .absoluteX,   execute: STA.absoluteX )
    public static let STA_AbsoluteY   = Instruction( mnemonic: "STA", opcode: 0x99, size: 3, cycles: 5, addressingMode: .absoluteY,   execute: STA.absoluteY )
    public static let STA_IndirectX   = Instruction( mnemonic: "STA", opcode: 0x81, size: 2, cycles: 6, addressingMode: .indirectX,   execute: STA.indirectX )
    public static let STA_IndirectY   = Instruction( mnemonic: "STA", opcode: 0x91, size: 2, cycles: 6, addressingMode: .indirectY,   execute: STA.indirectY )
    public static let STA_ZeroPage    = Instruction( mnemonic: "STA", opcode: 0x85, size: 2, cycles: 3, addressingMode: .zeroPage,    execute: STA.zeroPage )
    public static let STA_ZeroPageY   = Instruction( mnemonic: "STA", opcode: 0x95, size: 2, cycles: 4, addressingMode: .zeroPageY,   execute: STA.zeroPageY )
    public static let STX_Absolute    = Instruction( mnemonic: "STX", opcode: 0x8E, size: 3, cycles: 4, addressingMode: .absolute,    execute: STX.absolute )
    public static let STX_ZeroPage    = Instruction( mnemonic: "STX", opcode: 0x86, size: 2, cycles: 2, addressingMode: .zeroPage,    execute: STX.zeroPage )
    public static let STX_ZeroPageY   = Instruction( mnemonic: "STX", opcode: 0x96, size: 2, cycles: 4, addressingMode: .zeroPageY,   execute: STX.zeroPageY )
    public static let STY_Absolute    = Instruction( mnemonic: "STY", opcode: 0x8C, size: 3, cycles: 4, addressingMode: .absolute,    execute: STY.absolute )
    public static let STY_ZeroPage    = Instruction( mnemonic: "STY", opcode: 0x84, size: 2, cycles: 2, addressingMode: .zeroPage,    execute: STY.zeroPage )
    public static let STY_ZeroPageX   = Instruction( mnemonic: "STY", opcode: 0x94, size: 2, cycles: 4, addressingMode: .zeroPageX,   execute: STY.zeroPageX )
    public static let TAX_Implicit    = Instruction( mnemonic: "TAX", opcode: 0xAA, size: 1, cycles: 2, addressingMode: .implicit,    execute: TAX.implicit )
    public static let TAY_Implicit    = Instruction( mnemonic: "TAY", opcode: 0xA8, size: 1, cycles: 2, addressingMode: .implicit,    execute: TAY.implicit )
    public static let TSX_Implicit    = Instruction( mnemonic: "TSX", opcode: 0xBA, size: 1, cycles: 2, addressingMode: .implicit,    execute: TSX.implicit )
    public static let TXA_Implicit    = Instruction( mnemonic: "TXA", opcode: 0x8A, size: 1, cycles: 2, addressingMode: .implicit,    execute: TXA.implicit )
    public static let TXS_Implicit    = Instruction( mnemonic: "TXS", opcode: 0x9A, size: 1, cycles: 2, addressingMode: .implicit,    execute: TXS.implicit )
    public static let TYA_Implicit    = Instruction( mnemonic: "TYA", opcode: 0x98, size: 1, cycles: 2, addressingMode: .implicit,    execute: TYA.implicit )

    public static var all: [ Instruction ] =
        [
            ADC_Absolute,
            ADC_AbsoluteX,
            ADC_AbsoluteY,
            ADC_Immediate,
            ADC_IndirectX,
            ADC_IndirectY,
            ADC_ZeroPage,
            ADC_ZeroPageX,
            AND_Absolute,
            AND_AbsoluteX,
            AND_AbsoluteY,
            AND_Immediate,
            AND_IndirectX,
            AND_IndirectY,
            AND_ZeroPage,
            AND_ZeroPageX,
            ASL_Absolute,
            ASL_AbsoluteX,
            ASL_Accumulator,
            ASL_ZeroPage,
            ASL_ZeroPageX,
            BCC_Relative,
            BCS_Relative,
            BEQ_Relative,
            BIT_Absolute,
            BIT_ZeroPage,
            BMI_Relative,
            BNE_Relative,
            BPL_Relative,
            BRK_Implicit,
            BVC_Relative,
            BVS_Relative,
            CLC_Implicit,
            CLD_Implicit,
            CLI_Implicit,
            CLV_Implicit,
            CMP_Absolute,
            CMP_AbsoluteX,
            CMP_AbsoluteY,
            CMP_Immediate,
            CMP_IndirectX,
            CMP_IndirectY,
            CMP_ZeroPage,
            CMP_ZeroPageX,
            CPX_Absolute,
            CPX_Immediate,
            CPX_ZeroPage,
            CPY_Absolute,
            CPY_Immediate,
            CPY_ZeroPage,
            DEC_Absolute,
            DEC_AbsoluteX,
            DEC_ZeroPage,
            DEC_ZeroPageX,
            DEX_Implicit,
            DEY_Implicit,
            EOR_Absolute,
            EOR_AbsoluteX,
            EOR_AbsoluteY,
            EOR_Immediate,
            EOR_IndirectX,
            EOR_IndirectY,
            EOR_ZeroPage,
            EOR_ZeroPageX,
            INC_Absolute,
            INC_AbsoluteX,
            INC_ZeroPage,
            INC_ZeroPageX,
            INX_Implicit,
            INY_Implicit,
            JMP_Absolute,
            JMP_Indirect,
            JSR_Absolute,
            LDA_Absolute,
            LDA_AbsoluteX,
            LDA_AbsoluteY,
            LDA_Immediate,
            LDA_IndirectX,
            LDA_IndirectY,
            LDA_ZeroPage,
            LDA_ZeroPageX,
            LDX_Absolute,
            LDX_AbsoluteY,
            LDX_Immediate,
            LDX_ZeroPage,
            LDX_ZeroPageY,
            LDY_Absolute,
            LDY_AbsoluteX,
            LDY_Immediate,
            LDY_ZeroPage,
            LDY_ZeroPageX,
            LSR_Absolute,
            LSR_AbsoluteX,
            LSR_Accumulator,
            LSR_ZeroPage,
            LSR_ZeroPageX,
            NOP_Implicit,
            ORA_Absolute,
            ORA_AbsoluteX,
            ORA_AbsoluteY,
            ORA_Immediate,
            ORA_IndirectX,
            ORA_IndirectY,
            ORA_ZeroPage,
            ORA_ZeroPageX,
            PHA_Implicit,
            PHP_Implicit,
            PLA_Implicit,
            PLP_Implicit,
            ROL_Absolute,
            ROL_AbsoluteX,
            ROL_Accumulator,
            ROL_ZeroPage,
            ROL_ZeroPageX,
            ROR_Absolute,
            ROR_AbsoluteX,
            ROR_Accumulator,
            ROR_ZeroPage,
            ROR_ZeroPageX,
            RTI_Implicit,
            RTS_Implicit,
            SBC_Absolute,
            SBC_AbsoluteX,
            SBC_AbsoluteY,
            SBC_Immediate,
            SBC_IndirectX,
            SBC_IndirectY,
            SBC_ZeroPage,
            SBC_ZeroPageX,
            SEC_Implicit,
            SED_Implicit,
            SEI_Implicit,
            STA_Absolute,
            STA_AbsoluteX,
            STA_AbsoluteY,
            STA_IndirectX,
            STA_IndirectY,
            STA_ZeroPage,
            STA_ZeroPageY,
            STX_Absolute,
            STX_ZeroPage,
            STX_ZeroPageY,
            STY_Absolute,
            STY_ZeroPage,
            STY_ZeroPageX,
            TAX_Implicit,
            TAY_Implicit,
            TSX_Implicit,
            TXA_Implicit,
            TXS_Implicit,
            TYA_Implicit,
        ]
}
