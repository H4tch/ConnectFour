#!/bin/sh

# TODO: The Windows binaries need the DLLs in the same directory as the exe.
#		Should I make a script for Windows and Linux to launch the exe properly?

Cores=2
OS=Linux
ARCH=x86_64

make cleanAll

make -j$Cores release

ARCH=x86
make -j$Cores release

OS=Windows_NT
make -j$Cores release

ARCH=x86_64
make -j$Cores release

make package

OS=Linux

