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

public class MC6820Peripheral: CustomStringConvertible
{
    public var ready: Bool = false
    {
        didSet
        {
            self.readyChanged?( self )
        }
    }

    public var acknowledge: Bool = false
    {
        didSet
        {
            self.ready = false
        }
    }

    public var data: UInt8 = 0
    {
        didSet
        {
            self.ready = true
        }
    }

    public var readyChanged: ( ( MC6820Peripheral ) -> Void )?

    private var queue = DispatchQueue( label: "MC6820PeripheralQueue", qos: .userInitiated, attributes: [] )

    public init()
    {}

    public func setData( _ data: UInt8 )
    {
        self.queue.async
        {
            while self.ready
            {}

            self.data        = data
            self.acknowledge = false
            self.ready       = true
        }
    }

    public var description: String
    {
        "Unknown Peripheral"
    }
}
