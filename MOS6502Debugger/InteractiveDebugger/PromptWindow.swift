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

public class PromptWindow: WindowBuilder
{
    public var desiredFame: Rect
    public var style:       ManagedWindow.Style

    public var priority: Int
    {
        1000
    }

    public private( set ) var computer: Computer

    private var isActive    = false
    private var completion:   ( ( PromptValue ) -> Void )?
    private var title:        String     = ""
    private var value:        String     = ""
    private var descriptions: [ String ] = []

    public init( computer: Computer, frame: Rect, style: ManagedWindow.Style )
    {
        self.computer    = computer
        self.desiredFame = frame
        self.style       = style
    }

    public func shouldBeRendered() -> Bool
    {
        self.isActive
    }

    public func render( on window: ManagedWindow )
    {
        if self.title.isEmpty == false
        {
            window.printLine( foreground: .blue, text: self.title )
            window.separator()
        }

        window.printLine( foreground: .yellow, text: self.value )

        if self.descriptions.isEmpty == false
        {
            window.separator()
            self.descriptions.forEach
            {
                window.printLine( text: $0 )
            }
        }
    }

    public func show( title: String, descriptions: [ String ]?, completion: @escaping ( PromptValue ) -> Void )
    {
        if self.isActive
        {
            return
        }

        self.isActive     = true
        self.completion   = completion
        self.title        = title
        self.value        = ""
        self.descriptions = descriptions ?? []

        let height = self.descriptions.isEmpty ? 5 : 6 + self.descriptions.count
        let width  = self.descriptions.reduce( self.title.count )
        {
            $0 < $1.count ? $1.count : $0
        }

        self.desiredFame = Rect( x: -1, y: -1, width: Int32( max( width + 4, 50 ) ), height: Int32( height ) )
    }

    public func handleKey( _ key: Int32 ) -> Bool
    {
        if self.isActive, isprint( key ) == 1 || key == 0x20
        {
            self.value.append( String( format: "%c", key ) )

            return true
        }
        else if self.isActive, key == 0x7F
        {
            if self.value.isEmpty == false
            {
                self.value = String( self.value.dropLast( 1 ) )
            }
        }
        else if self.isActive, ( key == 10 || key == 13 )
        {
            self.isActive = false

            self.completion?( PromptValue( string: self.value ) )

            return true
        }

        return false
    }
}
