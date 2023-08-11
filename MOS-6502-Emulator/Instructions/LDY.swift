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

public class LDY
{
    private init()
    {}

    public class func immediate( cpu: CPU ) throws
    {
        cpu.registers.Y = try cpu.readUInt8FromMemoryAtPC()

        LD.setStatus( for: cpu.registers.Y, cpu: cpu )
    }

    public class func zeroPage( cpu: CPU ) throws
    {
        let address     = try cpu.readUInt8FromMemoryAtPC()
        cpu.registers.Y = try cpu.readUInt8FromMemory( at: UInt64( address ) )

        LD.setStatus( for: cpu.registers.A, cpu: cpu )
    }

    public class func zeroPageX( cpu: CPU ) throws
    {}

    public class func absolute( cpu: CPU ) throws
    {}

    public class func absoluteX( cpu: CPU ) throws
    {}
}
