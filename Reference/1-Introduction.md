MOS 6502 Reference
==================

  - Source: https://www.nesdev.org/obelisk-6502-guide/index.html
  - Author: Andrew Jacobs (BitWise)
  - Date:   27th March 2009

**Disclaimer**

> Andrew Jacobs unfortunately passed away on 8th January 2021.  
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

## Introduction

My first computer, a BBC Microcomputer Model B, was powered by a 6502 processor
and I spent many hours writing and debugging assembly language programs for it
(I was the author of CodeKit, co-author of SupaStore and lots of other stuff).
I managed to hold on to my BBC until 1989 when my wife insisted that I got rid
of it before I bought my first Intel based PC.

Sometime in 1998 I found an emulator called 'pcBBC' on the web. It was very good
BBC emulator and it reawakened my interest in 6502 assembly programming.
Unfortunate pcBBC did not survive the various updates to Microsoft Windows and
now I use BeebEm.

The assembler that I started with (AS65) runs under DOS (or in a DOS window)
and can assemble a 16Kb ROM almost instantly (on a Pentium III 500Mhz).
When I was developing on my BBC I used to break for a cup of tea (or two)
when the assembler was running!

More recently I have written my own Java based 6502 assembler which supports
relocatable code and some simple structured programming constructs
(e.g. if/then/else).
