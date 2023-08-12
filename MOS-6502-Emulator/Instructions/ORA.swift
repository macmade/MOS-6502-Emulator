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

/*
 * ORA - ...
 *
 * ...
 *
 * Flags:
 *     - Carry Flag:           N/A
 *     - Zero Flag:            N/A
 *     - Interrupt Disable:    N/A
 *     - Decimal Mode:         N/A
 *     - Break Command:        N/A
 *     - Overflow Flag:        N/A
 *     - Negative Flag:        N/A
 */
public class ORA
{
    private init()
    {}
    
    public class func absolute( cpu: CPU ) throws
    {
        throw RuntimeError( message: "Not implemented" )
    }
    
    public class func absoluteX( cpu: CPU ) throws
    {
        throw RuntimeError( message: "Not implemented" )
    }
    
    public class func absoluteY( cpu: CPU ) throws
    {
        throw RuntimeError( message: "Not implemented" )
    }
    
    public class func immediate( cpu: CPU ) throws
    {
        throw RuntimeError( message: "Not implemented" )
    }
    
    public class func indirectX( cpu: CPU ) throws
    {
        throw RuntimeError( message: "Not implemented" )
    }
    
    public class func indirectY( cpu: CPU ) throws
    {
        throw RuntimeError( message: "Not implemented" )
    }
    
    public class func zeroPage( cpu: CPU ) throws
    {
        throw RuntimeError( message: "Not implemented" )
    }
    
    public class func zeroPageX( cpu: CPU ) throws
    {
        throw RuntimeError( message: "Not implemented" )
    }
}
