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
import MOS6502

public class Apple1WozMonitor: ROM
{
    public init()
    {}

    public var name   = "Apple 1 Woz Monitor ROM"
    public var origin = UInt16( 0xFF00 )

    public var data = Data(
        [
            0xD8, 0x58, 0xA0, 0x7F, 0x8C, 0x12, 0xD0, 0xA9, 0xA7, 0x8D,
            0x11, 0xD0, 0x8D, 0x13, 0xD0, 0xC9, 0xDF, 0xF0, 0x13, 0xC9,
            0x9B, 0xF0, 0x03, 0xC8, 0x10, 0x0F, 0xA9, 0xDC, 0x20, 0xEF,
            0xFF, 0xA9, 0x8D, 0x20, 0xEF, 0xFF, 0xA0, 0x01, 0x88, 0x30,
            0xF6, 0xAD, 0x11, 0xD0, 0x10, 0xFB, 0xAD, 0x10, 0xD0, 0x99,
            0x00, 0x02, 0x20, 0xEF, 0xFF, 0xC9, 0x8D, 0xD0, 0xD4, 0xA0,
            0xFF, 0xA9, 0x00, 0xAA, 0x0A, 0x85, 0x2B, 0xC8, 0xB9, 0x00,
            0x02, 0xC9, 0x8D, 0xF0, 0xD4, 0xC9, 0xAE, 0x90, 0xF4, 0xF0,
            0xF0, 0xC9, 0xBA, 0xF0, 0xEB, 0xC9, 0xD2, 0xF0, 0x3B, 0x86,
            0x28, 0x86, 0x29, 0x84, 0x2A, 0xB9, 0x00, 0x02, 0x49, 0xB0,
            0xC9, 0x0A, 0x90, 0x06, 0x69, 0x88, 0xC9, 0xFA, 0x90, 0x11,
            0x0A, 0x0A, 0x0A, 0x0A, 0xA2, 0x04, 0x0A, 0x26, 0x28, 0x26,
            0x29, 0xCA, 0xD0, 0xF8, 0xC8, 0xD0, 0xE0, 0xC4, 0x2A, 0xF0,
            0x97, 0x24, 0x2B, 0x50, 0x10, 0xA5, 0x28, 0x81, 0x26, 0xE6,
            0x26, 0xD0, 0xB5, 0xE6, 0x27, 0x4C, 0x44, 0xFF, 0x6C, 0x24,
            0x00, 0x30, 0x2B, 0xA2, 0x02, 0xB5, 0x27, 0x95, 0x25, 0x95,
            0x23, 0xCA, 0xD0, 0xF7, 0xD0, 0x14, 0xA9, 0x8D, 0x20, 0xEF,
            0xFF, 0xA5, 0x25, 0x20, 0xDC, 0xFF, 0xA5, 0x24, 0x20, 0xDC,
            0xFF, 0xA9, 0xBA, 0x20, 0xEF, 0xFF, 0xA9, 0xA0, 0x20, 0xEF,
            0xFF, 0xA1, 0x24, 0x20, 0xDC, 0xFF, 0x86, 0x2B, 0xA5, 0x24,
            0xC5, 0x28, 0xA5, 0x25, 0xE5, 0x29, 0xB0, 0xC1, 0xE6, 0x24,
            0xD0, 0x02, 0xE6, 0x25, 0xA5, 0x24, 0x29, 0x07, 0x10, 0xC8,
            0x48, 0x4A, 0x4A, 0x4A, 0x4A, 0x20, 0xE5, 0xFF, 0x68, 0x29,
            0x0F, 0x09, 0xB0, 0xC9, 0xBA, 0x90, 0x02, 0x69, 0x06, 0x2C,
            0x12, 0xD0, 0x30, 0xFB, 0x8D, 0x12, 0xD0, 0x60, 0x00, 0x00,
            0x00, 0x0F, 0x00, 0xFF, 0x00, 0x00,
        ]
    )

    public var comments: [ UInt16: String ]
    {
        [
            0xFF00: "Clear decimal arithmetic mode.",
            0xFF02: "Mask for DSP data direction register.",
            0xFF04: "Set it up.",
            0xFF07: "KBD and DSP control register mask.",
            0xFF09: "Enable interrupts, set CA1, CB1, for",
            0xFF0C: " positive edge sense/output mode.",
            0xFF0F: "\" <- \"?",
            0xFF11: "Yes.",
            0xFF13: "ESC?",
            0xFF15: "Yes.",
            0xFF17: "Advance text index.",
            0xFF18: "Auto ESC if > 127.",
            0xFF1A: "\" \\ \".",
            0xFF1C: "Output it.",
            0xFF1F: "CR.",
            0xFF21: "Output it.",
            0xFF24: "Initiallize text index.",
            0xFF26: "Backup text index.",
            0xFF27: "Beyond start of line, reinitialize.",
            0xFF29: "Key ready?",
            0xFF2C: "Loop until ready.",
            0xFF2E: "Load character. B7 should be '1'.",
            0xFF31: "Add to text buffer.",
            0xFF34: "Display character.",
            0xFF37: "CR?",
            0xFF39: "No.",
            0xFF3B: "Reset text index.",
            0xFF3D: "For XAM mode.",
            0xFF3F: "0->X.",
            0xFF40: "Leaves $7B if setting STOR mode.",
            0xFF41: "$00 = XAM, $7B = STOR, $AE = BLOK XAM.",
            0xFF43: "Advance text index.",
            0xFF44: "Get character.",
            0xFF47: "CR?",
            0xFF49: "Yes, done this line.",
            0xFF4B: "\".\"?",
            0xFF4D: "Skip delimiter.",
            0xFF4F: "Set BLOCK XAM mode.",
            0xFF51: "\":\"?",
            0xFF53: "Yes, set STOR mode.",
            0xFF55: "\"R\"?",
            0xFF57: "Yes, run user program.",
            0xFF59: "$00->L.",
            0xFF5B: " and H.",
            0xFF5D: "Save Y for comparison.",
            0xFF5F: "Get character for hex test.",
            0xFF62: "Map digits to $0-9.",
            0xFF64: "Digit?",
            0xFF66: "Yes.",
            0xFF68: "Map letter \"A\"—\"F\" to $FA—FF.",
            0xFF6A: "Hex letter?",
            0xFF6C: "No, character not hex.",
            0xFF6F: "Hex digit to MSD of A.",
            0xFF72: "Shift count.",
            0xFF74: "Hex digit left, MSB to carry.",
            0xFF75: "Rotate into LSD.",
            0xFF77: "Rotate into MSD's.",
            0xFF70: "Done 4 shifts?",
            0xFF7A: "No, loop.",
            0xFF7C: "Advence text index.",
            0xFF7D: "Always taken. Check next character for hex.",
            0xFF7F: "Check if L, H empty (no hex digits).",
            0xFF81: "Yes, generate ESC sequence.",
            0xFF83: "Test MODE byte.",
            0xFF85: "B6 = 0 for STOR, 1 for XAM and BLOCK XAM",
            0xFF87: "LSD's of hex data.",
            0xFF89: "Store at current 'store index'.",
            0xFF8B: "Increment store index.",
            0xFFBD: "Get next item. (no carry).",
            0xFF8F: "Add carry to 'store index' high order.",
            0xFF91: "Get next command item.",
            0xFF94: "Run at current XAM index.",
            0xFF97: "B7 = 0 for XAM, 1 for BLOCK XAM.",
            0xFF99: "Byte count.",
            0xFF9B: "Copy hex data to",
            0xFF9D: " 'store index'.",
            0xFF9F: "And to 'XAM index'.",
            0xFFA1: "Next of 2 bytes.",
            0xFFA2: "Loop unless X = 0.",
            0xFFA4: "NE means no address to print.",
            0xFFA7: "CR.",
            0xFFA8: "Output it.",
            0xFFAB: "'Examine index' high-order byte.",
            0xFFAD: "Output it in hex format.",
            0xFFB0: "Low-order 'examine index' byte.",
            0xFFB2: "Output it in hex format.",
            0xFFB5: "\":\".",
            0xFFB7: "Output it.",
            0xFFBA: "Blank.",
            0xFFBC: "Output it.",
            0xFFBF: "Get data byte at 'examine index'.",
            0xFFC1: "Output it in hex format.",
            0xFFC4: "0-> MODE (XAM mode).",
            0xFFC8: "Compare 'examine index' to hex data.",
            0xFFCE: "Not less, so no more data to output.",
            0xFFD2: "Increment 'examine index'.",
            0xFFD6: "Check low-order 'examine index' byte",
            0xFFD7: " For MOD 8 = 0",
            0xFFDA: "Always taken.",
            0xFFDC: "Save A for LSD.",
            0xFFDF: "MSD to LSD position.",
            0xFFE1: "Output hex digit.",
            0xFFE4: "Restore A.",
            0xFFE5: "Mask LSD for hex print.",
            0xFFE7: "Add \"0\".",
            0xFFE9: "Digit?",
            0xFFEB: "Yes, output it.",
            0xFFED: "Add offset for letter.",
            0xFFEF: "DA bit (B7) cleared yet?",
            0xFFF2: "No, wait for display.",
            0xFFF4: "Output character. Sets DA.",
            0xFFF7: "Return.",
            0xFFF8: "(unused)",
            0xFFF9: "(unused)",
        ]
    }

    public var labels: [ UInt16: String ]
    {
        [
            0xFF00: "RESET",
            0xFF0F: "NOTCR",
            0xFF1A: "ESCAPE",
            0xFF1F: "GETLINE",
            0xFF26: "BACKSPACE",
            0xFF29: "NEXTCHAR",
            0xFF40: "SETSTOR",
            0xFF41: "SETMODE",
            0xFF43: "BLSKIP",
            0xFF44: "NEXT ITEM",
            0xFF5F: "NEXTHEX",
            0xFF6E: "DIG",
            0xFF74: "HEXSHIFT",
            0xFF7F: "NOTHEX",
            0xFF91: "TONEXTITEM",
            0xFF94: "RUN",
            0xFF97: "NOTSTOR",
            0xFF9B: "SETADR",
            0xFFA4: "NXTPRNT",
            0xFFBA: "PRDATA",
            0xFFC4: "XAMNEXT",
            0xFFD6: "MOD8CHK",
            0xFFDC: "PRBYTE",
            0xFFE5: "PRHEX",
            0xFFEF: "ECHO",
        ]
    }
}
