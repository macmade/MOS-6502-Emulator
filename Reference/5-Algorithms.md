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

### Simple Memory Operations

Probably the most fundamental memory operation is clearing an area of memory to
an initial value, such as zero. As the 6502 cannot directly move values to
memory clearing even a small region of memory requires the use of a register.
Any of A, X or Y could be used to hold the initial value, but in practice A i
normally used because it can be quickly saved and restored (with `PHA` and
`PLA`) leaving X and Y free for application use.

    ; Clearing 16 bits of memory
    _CLR16  LDA #0          ; Load constant zero into A
            STA MEM+0       ; Then clear the least significant byte
            STA MEM+1       ; ... followed by the most significant
    
    ; Clearing 32 bits of memory
    _CLR32  LDA #0          ; Load constant zero into A
            STA MEM+0       ; Clear from the least significant byte
            STA MEM+1       ; ... up
            STA MEM+2       ; ... to
            STA MEM+3       ; ... the most significant

Moving a small quantity of data requires a register to act as a temporary
container during the transfer. Again any of A, X, or Y may be used, but as
before using A as the temporary register is often the most practical.

    ; Moving 16 bits of memory
    _XFR16  LDA SRC+0       ; Move the least significant byte
            STA DST+0
            LDA SRC+1       ; Then the most significant
            STA DST+1
    
    ; Moving 32 bits of memory
    _XFR32  LDA SRC+0       ; Move from least significant byte
            STA DST+0
            LDA SRC+1       ; ... up
            STA DST+1
            LDA SRC+2       ; ... to
            STA DST+2
            LDA SRC+3       ; ... the most significant
            STA DST+3
