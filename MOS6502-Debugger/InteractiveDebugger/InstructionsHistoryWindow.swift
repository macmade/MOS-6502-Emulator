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
import SwiftCurses
import xasm65lib

public class InstructionsHistoryWindow: InstructionsWindow
{
    private var show                     = false
    private var instructions             = [ [ ( color: Color?, text: String ) ] ]()
    private var lastInstruction:           [ ( color: Color?, text: String ) ]?
    private var beforeInstructionObserver: Any?
    private var afterInstructionObserver:  Any?

    public override init( computer: Computer, frame: Rect, style: ManagedWindow.Style, prompt: PromptWindow )
    {
        super.init( computer: computer, frame: frame, style: style, prompt: prompt )

        self.beforeInstructionObserver = computer.cpu.beforeInstruction.add
        {
            [ weak self ] in self?.beforeInstruction()
        }

        self.afterInstructionObserver = computer.cpu.afterInstruction.add
        {
            [ weak self ] in self?.afterInstruction()
        }
    }

    public override var priority: Int
    {
        50
    }

    public override func shouldBeRendered() -> Bool
    {
        self.show
    }

    public override func handleKey( _ key: Int32 ) -> Bool
    {
        if key == 0x24 // 6
        {
            self.show.toggle()
        }

        return false
    }

    public override func render( on window: ManagedWindow )
    {
        window.printLine( foreground: .blue, text: "Instructions History:" )
        window.separator()

        let lines = Int( window.bounds.size.height ) - 2

        guard lines > 2
        else
        {
            return
        }

        self.instructions = self.instructions.suffix( lines )

        self.alignInstructions( self.instructions ).forEach
        {
            self.printInstruction( window: window, instruction: $0 )
        }
    }

    private func beforeInstruction()
    {
        self.lastInstruction = self.getInstructions( lines: 1 ).first
    }

    public func afterInstruction()
    {
        if let last = self.lastInstruction
        {
            let text1 = last.reduce( into: "" ) { $0.append( $1.text ) }
            let text2 = self.instructions.last?.reduce( into: "" ) { $0.append( $1.text ) }

            if text1 != text2
            {
                self.instructions.append( last )
            }
        }
    }
}
