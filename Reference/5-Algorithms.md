MOS 6502 Reference
==================

Source: https://www.nesdev.org/obelisk-6502-guide/index.html

## Table of Contents

  1. [Architecture](https://github.com/macmade/MOS-6502-Emulator/blob/main/Reference/1-Architecture.md)
  2. [Registers](https://github.com/macmade/MOS-6502-Emulator/blob/main/Reference/2-Registers.md)
  3. [Instructions](https://github.com/macmade/MOS-6502-Emulator/blob/main/Reference/3-Instructions.md)
  4. [Addressing](https://github.com/macmade/MOS-6502-Emulator/blob/main/Reference/4-Addressing.md)
  5. [Algorithms](https://github.com/macmade/MOS-6502-Emulator/blob/main/Reference/5-Algorithms.md)
  6. [Reference](https://github.com/macmade/MOS-6502-Emulator/blob/main/Reference/6-Reference.md)

## Coding Algorithms

As you can see from the preceding descriptions the instruction set of the 6502
is quite basic, having only simple 8 bit operations. Complex operations such as
16 or 32 bit arithmetic and memory transfers have to be performed by executing
a sequence of simpler operations. This sections describes how to build these
algorithms and is based on code taken from my macro library.

If you find any bugs in the code, have routines to donate to the library,
or can suggest improvements then please mail me.

### Standard Conventions

The 6502 processor expects addresses to be stored in 'little endian' order,
with the least significant byte first and the most significant byte second.
If the value stored was just a number (e.g. game score, etc.) then we could
write code to store and manipulate it in 'big endian' order if we wished,
however the algorithms presented here always use 'little endian' order so that
they may be applied either to simple numeric values or addresses without
modification.

> The terms 'big endian' and 'little endian' come from Gulliver's Travels.
> The people of Lilliput and Blefuscu have been fighting a war over which end
> of an boiled egg one should crack to eat it. In computer terms it refers to
> whether the most or least significant  portion of a binary number is stored
> in the lower memory address.

To be safe the algorithms usually start by setting processor flags and registers
to safe initial values. If you need to squeeze a few extra bytes or cycles out
of the routine you might be able to remove some of these initializations
depending on the preceding instructions.
