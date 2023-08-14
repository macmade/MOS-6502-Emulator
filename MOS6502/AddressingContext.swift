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

public class AddressingContext
{
    private var readValue:   ()        throws -> UInt8
    private var writeValue:  ( UInt8 ) throws -> Void
    private var cachedValue: UInt8?

    public init( read: @escaping () throws -> UInt8, write: @escaping ( UInt8 ) throws -> Void )
    {
        self.readValue  = read
        self.writeValue = write
    }

    public func read() throws -> UInt8
    {
        if let value = self.cachedValue
        {
            return value
        }

        let value        = try self.readValue()
        self.cachedValue = value

        return value
    }

    public func write( _ value: UInt8 ) throws
    {
        try self.writeValue( value )
    }

    public class func implied( cpu: CPU ) throws -> AddressingContext
    {
        AddressingContext
        {
            throw RuntimeError( message: "Reading not supported for implied addressing mode" )
        }
        write:
        {
            _  in throw RuntimeError( message: "Writing not supported for implied addressing mode" )
        }
    }

    public class func accumulator( cpu: CPU ) throws -> AddressingContext
    {
        AddressingContext
        {
            cpu.registers.A
        }
        write:
        {
            cpu.registers.A = $0
        }
    }

    public class func immediate( cpu: CPU ) throws -> AddressingContext
    {
        let value = try cpu.readUInt8FromMemoryAtPC()

        return AddressingContext
        {
            value
        }
        write:
        {
            _  in throw RuntimeError( message: "Writing not supported for immediate addressing mode" )
        }
    }

    public class func zeroPage( cpu: CPU ) throws -> AddressingContext
    {
        let address = UInt16( try cpu.readUInt8FromMemoryAtPC() )

        return AddressingContext
        {
            try cpu.readUInt8FromMemory( at: address )
        }
        write:
        {
            try cpu.writeUInt8ToMemory( $0, at: address )
        }
    }

    public class func zeroPageX( cpu: CPU ) throws -> AddressingContext
    {
        AddressingContext
        {
            throw RuntimeError( message: "Not implemented" )
        }
        write:
        {
            _ in throw RuntimeError( message: "Not implemented" )
        }
    }

    public class func zeroPageY( cpu: CPU ) throws -> AddressingContext
    {
        AddressingContext
        {
            throw RuntimeError( message: "Not implemented" )
        }
        write:
        {
            _ in throw RuntimeError( message: "Not implemented" )
        }
    }

    public class func relative( cpu: CPU ) throws -> AddressingContext
    {
        AddressingContext
        {
            throw RuntimeError( message: "Not implemented" )
        }
        write:
        {
            _ in throw RuntimeError( message: "Not implemented" )
        }
    }

    public class func absolute( cpu: CPU ) throws -> AddressingContext
    {
        let address = try cpu.readUInt16FromMemoryAtPC()

        return AddressingContext
        {
            try cpu.readUInt8FromMemory( at: address )
        }
        write:
        {
            try cpu.writeUInt8ToMemory( $0,  at: address )
        }
    }

    public class func absoluteX( cpu: CPU ) throws -> AddressingContext
    {
        AddressingContext
        {
            throw RuntimeError( message: "Not implemented" )
        }
        write:
        {
            _ in throw RuntimeError( message: "Not implemented" )
        }
    }

    public class func absoluteY( cpu: CPU ) throws -> AddressingContext
    {
        AddressingContext
        {
            throw RuntimeError( message: "Not implemented" )
        }
        write:
        {
            _ in throw RuntimeError( message: "Not implemented" )
        }
    }

    public class func indirect( cpu: CPU ) throws -> AddressingContext
    {
        AddressingContext
        {
            throw RuntimeError( message: "Not implemented" )
        }
        write:
        {
            _ in throw RuntimeError( message: "Not implemented" )
        }
    }

    public class func indirectX( cpu: CPU ) throws -> AddressingContext
    {
        AddressingContext
        {
            throw RuntimeError( message: "Not implemented" )
        }
        write:
        {
            _ in throw RuntimeError( message: "Not implemented" )
        }
    }

    public class func indirectY( cpu: CPU ) throws -> AddressingContext
    {
        AddressingContext
        {
            throw RuntimeError( message: "Not implemented" )
        }
        write:
        {
            _ in throw RuntimeError( message: "Not implemented" )
        }
    }
}