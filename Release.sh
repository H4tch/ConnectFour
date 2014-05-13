#!/bin/sh

Cores=2

OS=Linux
ARCH=x86_64
make -j$(Cores) release

ARCH=x86
make -j$(Cores) release

OS=Windows_NT
make -j$(Cores) release

ARCH=x86_64
make -j$(Cores) release

OS=Linux

