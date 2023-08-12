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
Any of A, X or Y could be used to hold the initial value, but in practice A is
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

Provided the source and destination areas do not overlap then the order in which
the bytes are moved is irrelevant, but it usually pays to be consistent in your
approach to make mistakes easier to spot.

All of the preceding examples can be extended to apply to larger memory areas
but will generate increasingly larger code as the number of bytes involved
grows. Algorithms that iterate using a counter and use index addressing to
access memory will result in smaller code but will be slightly slower
to execute.

This trade off between speed and size is a common issue in assembly language
programming and there are times when one approach is clearly better than the
other (e.g. when trying to squeeze code into a fixed size ROM - `SIZE`,
or manipulate data during a video blanking period - `SPEED`).

    ; Clear 32 bits of memory iteratively
    _CLR32C LDX #3
            LDA #0
    _LOOP   STA MEM,X
            DEX
            BPL _LOOP
    
    ; Move 32 bits of memory iteratively
    _XFR32C LDX #3
    _LOOP   LDA SRC,X
            STA DST,X
            DEX
            BPL _LOOP

Another basic operation is setting a 16 bit word to an initial constant value.
The easiest way to do this is to load the low and high portions into A one at
a time and store them.

    ; Setting a 16 bit constant
    _SET16I LDA #LO NUM     ; Set the least significant byte of the constant
            STA MEM+0
            LDA #HI NUM     ; ... then the most significant byte
            STA MEM+1

### Logical Operations

The simplest forms of operation on binary values are the logical `AND`, logical
`OR` and exclusive `OR` illustrated by the following truth tables.

| Logical AND (AND)  | 0 | 1 |
|--------------------|---|---|
| 0                  | 0 | 0 |
| 1                  | 0 | 1 |

| Logical OR (ORA)   | 0 | 1 |
|--------------------|---|---|
| 0                  | 0 | 1 |
| 1                  | 1 | 1 |

| Exclusive OR (EOR) | 0 | 1 |
|--------------------|---|---|
| 0                  | 0 | 1 |
| 1                  | 1 | 0 |

These results can be summarized in English as:

  - The result of a logical `AND` is true (1) if and only if both inputs are
    true, otherwise it is false (0).
  - The result of a logical `OR` is true (1) if either of the inputs its true,
    otherwise it is false (0).
  - The result of an exclusive `OR` is true (1) if and only if one input is true
    and the other is false, otherwise it is false (0).

The tables show result of applying these operations on two one-bit values but
as the 6502 comprises of eight bit registers and memory each instruction will
operate on two eight bit values simultaneously as shown below.

| Logical AND (AND)  |   |   |   |   |   |   |   |   |
|--------------------|---|---|---|---|---|---|---|---|
| Value 1            | 0 | 0 | 1 | 1 | 0 | 0 | 1 | 1 |
| Value 2            | 0 | 1 | 0 | 1 | 0 | 1 | 0 | 1 |
| Result             | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 1 |

| Logical OR (ORA)   |   |   |   |   |   |   |   |   |
|--------------------|---|---|---|---|---|---|---|---|
| Value 1            | 0 | 0 | 1 | 1 | 0 | 0 | 1 | 1 |
| Value 2            | 0 | 1 | 0 | 1 | 0 | 1 | 0 | 1 |
| Result             | 0 | 1 | 1 | 1 | 0 | 1 | 1 | 1 |

| Exclusive OR (EOR) |   |   |   |   |   |   |   |   |
|--------------------|---|---|---|---|---|---|---|---|
| Value 1            | 0 | 0 | 1 | 1 | 0 | 0 | 1 | 1 |
| Value 2            | 0 | 1 | 0 | 1 | 0 | 1 | 0 | 1 |
| Result             | 0 | 1 | 1 | 0 | 0 | 1 | 1 | 0 |

It is important to understand the properties and practical applications of each
of these operations as they are extensively used in other algorithms.

  - Logical `AND` operates as a filter and is often used to select a subset of
    bits from a value (e.g. the status flags from a peripheral control chip).
  - Logical `OR` allows bits to be inserted into an existing value (e.g. to set
    control flags in a peripheral control chip).
  - Exclusive `OR` allows selected bits to be set or inverted.

In the 6502 these operations are implemented by the `AND`, `ORA` and `EOR`
instructions. One of the values to be operated on will be the current contents
of the accumulator, the other is in memory either as an immediate value or at
a specified location. The result of the operation is placed in the accumulator
and the zero and negative flags are set accordingly.

    ; Example logical operations
            AND #$0F        ; Filter out all but the least 4 bits
            ORA BITS,X      ; Insert some bits from a table
            EOR (DATA),Y    ; EOR against some data

A very common use of the `EOR` instruction is to calculate the 'complement'
(or logical `NOT`) of a value. This involves inverting every bit in the value
and is most easily calculated by exclusively ORing against an all ones value.

    ; Calculate the complement
            EOR #$FF

The macro library contains reference code for 16 and 32 bit `AND`, `ORA`, `EOR`
and `NOT` operations although there is very little use for them outside of
interpreters.
