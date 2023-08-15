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
import xasm65lib

public class Instruction
{
    typealias AddressingMode = xasm65lib.Instruction.AddressingMode

    public var mnemonic:       String
    public var opcode:         UInt8
    public var size:           UInt
    public var cycles:         UInt
    public var addressingMode: xasm65lib.Instruction.AddressingMode
    public var execute:        ( CPU, AddressingContext ) throws -> Void

    public init?( instruction: xasm65lib.Instruction )
    {
        self.mnemonic       = instruction.mnemonic
        self.opcode         = instruction.opcode
        self.size           = instruction.size
        self.cycles         = instruction.cycles
        self.addressingMode = instruction.addressingMode

        switch instruction.mnemonic
        {
            case "ADC": self.execute = ADC
            case "AND": self.execute = AND
            case "ASL": self.execute = ASL
            case "BCC": self.execute = BCC
            case "BCS": self.execute = BCS
            case "BEQ": self.execute = BEQ
            case "BIT": self.execute = BIT
            case "BMI": self.execute = BMI
            case "BNE": self.execute = BNE
            case "BPL": self.execute = BPL
            case "BRK": self.execute = BRK
            case "BVC": self.execute = BVC
            case "BVS": self.execute = BVS
            case "CLC": self.execute = CLC
            case "CLD": self.execute = CLD
            case "CLI": self.execute = CLI
            case "CLV": self.execute = CLV
            case "CMP": self.execute = CMP
            case "CPX": self.execute = CPX
            case "CPY": self.execute = CPY
            case "DEC": self.execute = DEC
            case "DEX": self.execute = DEX
            case "DEY": self.execute = DEY
            case "EOR": self.execute = EOR
            case "INC": self.execute = INC
            case "INX": self.execute = INX
            case "INY": self.execute = INY
            case "JMP": self.execute = JMP
            case "JSR": self.execute = JSR
            case "LDA": self.execute = LDA
            case "LDX": self.execute = LDX
            case "LDY": self.execute = LDY
            case "LSR": self.execute = LSR
            case "NOP": self.execute = NOP
            case "ORA": self.execute = ORA
            case "PHA": self.execute = PHA
            case "PHP": self.execute = PHP
            case "PLA": self.execute = PLA
            case "PLP": self.execute = PLP
            case "ROL": self.execute = ROL
            case "ROR": self.execute = ROR
            case "RTI": self.execute = RTI
            case "RTS": self.execute = RTS
            case "SBC": self.execute = SBC
            case "SEC": self.execute = SEC
            case "SED": self.execute = SED
            case "SEI": self.execute = SEI
            case "STA": self.execute = STA
            case "STX": self.execute = STX
            case "STY": self.execute = STY
            case "TAX": self.execute = TAX
            case "TAY": self.execute = TAY
            case "TSX": self.execute = TSX
            case "TXA": self.execute = TXA
            case "TXS": self.execute = TXS
            case "TYA": self.execute = TYA
            default:    return nil
        }
    }

    public static var all: [ Instruction ] = xasm65lib.Instruction.all.compactMap
    {
        Instruction( instruction: $0 )
    }
}
