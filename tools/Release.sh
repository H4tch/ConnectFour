#!/bin/sh

export Cores=2
export OS=Linux
export ARCH=x86_64

make cleanAll

make -j$Cores release

export ARCH=x86
make -j$Cores release

export OS=Windows_NT
make -j$Cores release

export ARCH=x86_64
make -j$Cores release

make package

export OS=Linux

