#!/bin/sh

echo "Getting installed system SDL2 libs and installing them locally in lib/"

OS="Linux"
ARCHS="i386 x86_64"
TARGETARCH=""
LIBS="SDL2 SDL2_image SDL2_ttf SDL2_mixer"
VMAJOR=2
VMINOR=0

for ARCH in $ARCHS; do
	TARGETARCH=$ARCH
	case $ARCH in
	i386|i486|i586|i686)
		TARGETARCH=x86
		;;
	esac
	for LIB in $LIBS; do
		cp /usr/lib/$ARCH-linux-gnu/lib$LIB-$VMAJOR.$VMINOR.so.$VMINOR \
			lib/$OS"_"$TARGETARCH/
	done
done



