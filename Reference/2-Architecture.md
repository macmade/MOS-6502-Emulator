MOS 6502 Reference
==================

  - Source: https://www.nesdev.org/obelisk-6502-guide/index.html
  - Author: Andrew Jacobs (BitWise)

> **Disclaimer**  
> Andrew Jacobs unfortunately passed away on 8 January 2021.  
> His 6502 reference has been archived here for convenience and to ensure the
> content he created remains available.

## Table of Contents

  1. [Introduction](https://github.com/macmade/MOS-6502-Emulator/blob/main/Reference/1-Introduction.md)
  2. [Architecture](https://github.com/macmade/MOS-6502-Emulator/blob/main/Reference/2-Architecture.md)
  3. [Registers](https://github.com/macmade/MOS-6502-Emulator/blob/main/Reference/3-Registers.md)
  4. [Instructions](https://github.com/macmade/MOS-6502-Emulator/blob/main/Reference/4-Instructions.md)
  5. [Addressing](https://github.com/macmade/MOS-6502-Emulator/blob/main/Reference/5-Addressing.md)
  6. [Algorithms](https://github.com/macmade/MOS-6502-Emulator/blob/main/Reference/6-Algorithms.md)
  7. [Reference](https://github.com/macmade/MOS-6502-Emulator/blob/main/Reference/7-Reference.md)
  8. [Downloads](https://github.com/macmade/MOS-6502-Emulator/blob/main/Reference/8-Downloads.md)
  9. [Links](https://github.com/macmade/MOS-6502-Emulator/blob/main/Reference/9-Links.md)

## Basic Architecture

The 6502 microprocessor is a relatively simple 8 bit CPU with only a few
internal registers capable of addressing at most 64Kb of memory via its 16 bit
address bus. The processor is little endian and expects addresses to be stored
in memory least significant byte first.

The first 256 byte page of memory (`$0000-$00FF`) is referred to as 'Zero Page'
and is the focus of a number of special addressing modes that result in shorter
(and quicker) instructions or allow indirect access to the memory. The second
page of memory (`$0100-$01FF`) is reserved for the system stack and which cannot
be relocated.

The only other reserved locations in the memory map are the very last 6 bytes
of memory `$FFFA` to `$FFFF` which must be programmed with the addresses of the
non-maskable interrupt handler (`$FFFA/B`), the power on reset location
(`$FFFC/D`) and the BRK/interrupt request handler (`$FFFE/F`) respectively.

The 6502 does not have any special support of hardware devices so they must be
mapped to regions of memory in order to exchange data with the hardware latches.
