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

public class Registers: Equatable
{
    public var PC: UInt16 // Program Counter
    public var SP: UInt8  // Stack Pointer (256 bytes, 0x0100 to 0x01FF)
    public var A:  UInt8  // Accumulator
    public var X:  UInt8  // Index X Register
    public var Y:  UInt8  // Index Y Register
    public var PS: Flags  // Processor Status

    public struct Flags: OptionSet, CustomStringConvertible
    {
        public static let carryFlag        = Flags( rawValue: 1 << 0 ) // Set if the last operation caused an overflow from bit 7 or an underflow from bit 0
        public static let zeroFlag         = Flags( rawValue: 1 << 1 ) // Set if the result of the last operation was zero
        public static let interruptDisable = Flags( rawValue: 1 << 2 ) // Set with SEI, cleared with CLI
        public static let decimalMode      = Flags( rawValue: 1 << 3 ) // Set with SED, cleared with CLD
        public static let breakCommand     = Flags( rawValue: 1 << 4 ) // Set after BRK if an interrupt has been generated
        public static let overflowFlag     = Flags( rawValue: 1 << 6 ) // Set during arithmetic operations if the result has yielded an invalid 2's complement result
        public static let negativeFlag     = Flags( rawValue: 1 << 7 ) // Set if the result of the last operation had bit 7 set

        public let rawValue: UInt8

        public init( rawValue: UInt8 )
        {
            self.rawValue = rawValue
        }

        public var description: String
        {
            if self.isEmpty
            {
                return "--"
            }

            var s = ""

            if self.contains( .carryFlag        ) { s += "C" }
            if self.contains( .zeroFlag         ) { s += "Z" }
            if self.contains( .interruptDisable ) { s += "I" }
            if self.contains( .decimalMode      ) { s += "D" }
            if self.contains( .breakCommand     ) { s += "B" }
            if self.contains( .overflowFlag     ) { s += "V" }
            if self.contains( .negativeFlag     ) { s += "N" }

            return s
        }
    }

    public convenience init()
    {
        self.init( PC: 0, SP: 0, A: 0, X: 0, Y: 0, PS: [] )
    }

    public init( PC: UInt16, SP: UInt8, A: UInt8, X: UInt8, Y: UInt8, PS: Flags )
    {
        self.PC = PC
        self.SP = SP
        self.A  = A
        self.X  = X
        self.Y  = Y
        self.PS = PS
    }

    public static func == ( lhs: Registers, rhs: Registers ) -> Bool
    {
        if lhs.PC == rhs.PC,
           lhs.SP == rhs.SP,
           lhs.A  == rhs.A,
           lhs.X  == rhs.X,
           lhs.Y  == rhs.Y,
           lhs.PS == rhs.PS
        {
            return true
        }

        return false
    }
}
