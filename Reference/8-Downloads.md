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

## Downloads

This section contains tools and code that you can download from this site and
use in your own projects.

### Useful Tools

A quick search of the Internet yielded several 6502 macro assemblers of varying
degrees of quality. The one that I use was developed by Frank Vorstenbosch and
creates binary output files for ROMs that work perfectly in the pcBBC emulator.
Its also completely free.

  - [as65_111.zip](https://www.nesdev.org/obelisk-6502-guide/files/as65_111.zip)  
    A very good 6502 (and 65SC02) assembler, ideal for writing BBC Microcomputer
    ROMs.

Unfortunately Windows XP service pack 2 removed support for 16-bit MSDOS
applications. I persuaded Frank to port he's assembler to Win 32 and you can
down it (and others from here).

I have also been coding my own portable assembler development package
based on Java.  

  - [6502.zip](https://www.nesdev.org/obelisk-6502-guide/files/6502.zip)  
    JAVA based 6502/65C02/65816 Relocatable Macro Assembler and Linker.

### Source Code

Here are some 6502 assembly files that I've developed as part of my own
projects. This first set of files are operating system independent and have some
support for the 65SC02 processor.

  - [maclib.inc](https://www.nesdev.org/obelisk-6502-guide/files/maclib.inc)  
    Various general purpose algorithms (e.g. arithmetic, memory, etc.) coded
    in the form of macros so that they can be used either inline or expanded as
    subroutines. It has not been thoroughly debugged yet and some routines
    are missing.

The following source files are useful for developing BBC Microcomputer
applications or ROMs.

  - [bbc.inc](https://www.nesdev.org/obelisk-6502-guide/files/bbc.inc)  
    Symbol definitions for all the standard vector locations and operating
    system entry points.
  - [debug.inc](https://www.nesdev.org/obelisk-6502-guide/files/debug.inc)  
    A useful debugging routine that prints all the registers and status flags.
