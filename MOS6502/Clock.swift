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

public class Clock
{
    public enum Frequency
    {
        case hz( UInt )
        case mhz( UInt )

        public var nanoseconds: Int
        {
            switch self
            {
                case .hz(  let hz ):  return Int( ( 1.0 / Double( hz         ) ) * 1000000000 )
                case .mhz( let mhz ): return Int( ( 1.0 / Double( mhz * 1000 ) ) * 1000000000 )
            }
        }
    }

    public private( set ) var frequency: Frequency

    private var onCycle: () throws -> Void

    public init( frequency: Frequency, onCycle: @escaping () throws -> Void )
    {
        self.frequency = frequency
        self.onCycle   = onCycle
    }

    public func run() throws
    {
        while true
        {
            let start = try self.now()

            try self.onCycle()

            let elapsed = try self.now() - start

            if elapsed <= Int.max, elapsed < self.frequency.nanoseconds
            {
                self.sleep( nanoseconds: self.frequency.nanoseconds - Int( elapsed ) )
            }
        }
    }

    private func sleep( nanoseconds: Int )
    {
        var ts = timespec( tv_sec: 0, tv_nsec: nanoseconds )

        nanosleep( &ts, nil )
    }

    private func now() throws -> UInt64
    {
        var info = mach_timebase_info()

        guard mach_timebase_info( &info ) == KERN_SUCCESS
        else
        {
            throw RuntimeError( message: "Cannot get absolute time" )
        }

        let currentTime = mach_absolute_time()

        return currentTime * UInt64( info.numer ) / UInt64( info.denom )
    }
}
