#!/bin/sh

OS=`uname -s`
ARCH=`uname -m`

if [ "$OS" = "Darwin" ]; then
	OS="Mac"
fi

case $ARCH in
x86_64)
	ARCH=x86_64
	;;
i386|i486|i586|i686|ia32|x86)
	ARCH=x86
	;;
arm*|*arm|*arm*)
	echo "The ARM platform is not currently supported."
	exit 1
	;;
*)
	echo "Unknown Platform: " $ARCH
	exit 1
	;;
esac


export LD_PRELOAD="`ls -d -1 $PWD/lib/Linux_x86/*`" && \
	./"game_"$OS"_"$ARCH



