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

extension Bus: DebugAwareWriteableMemoryDevice
{
    public func debugRead( at address: UInt16 ) throws -> UInt8
    {
        let mapped = try self.deviceForAddress( address )

        if let debugAware = mapped.device as? DebugAwareMemoryDevice
        {
            return try debugAware.debugRead( at: mapped.address )
        }
        else
        {
            return try mapped.device.read( at: mapped.address )
        }
    }

    public func debugWrite( _ value: UInt8, at address: UInt16 ) throws
    {
        let mapped = try self.writeableDeviceForAddress( address )

        if let debugAware = mapped.device as? DebugAwareWriteableMemoryDevice
        {
            try debugAware.debugWrite( value, at: mapped.address )
        }
        else
        {
            try mapped.device.write( value, at: mapped.address )
        }
    }
}
