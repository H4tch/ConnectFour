#!/bin/sh

## This file gets SDL2's source and compiles it. A few things need to be tweak
## for it to be cross-platform.

OS=`uname -s`

OS="Linux"
LIBDIR=$PWD/lib
ARCHS="i386 x86_64"
TARGETARCH=""
LIBS="SDL2 SDL2_image SDL2_ttf SDL2_mixer"
VMAJOR=2
VMINOR=0
EXT=tar.gz
INSTALLDIR=$PWD/tools/third_party/SDL2/

mkdir -p tools/third_party/
cd tools/third_party/


# Download the source.
wget -c http://www.libsdl.org/release/SDL2-2.0.3.tar.gz -O SDL2-$VMAJOR.$VMINOR-src.$EXT
wget -c https://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.0.tar.gz -O SDL2_image-$VMAJOR.$VMINOR-src.$EXT
wget -c https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.12.tar.gz -O SDL2_ttf-$VMAJOR.$VMINOR-src.$EXT
wget -c http://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.0.tar.gz -O SDL2_mixer-$VMAJOR.$VMINOR-src.$EXT



mkdir -p SDL2
export PATH=$INSTALLDIR/bin:$PATH
export PKG_CONFIG_PATH=$INSTALLDIR/pkgconfig
export LD_LIBRARY_PATH=$INSTALLDIR/lib

for LIB in $LIBS; do
	echo $PWD
	tar -xzf $LIB-$VMAJOR.$VMINOR-src.$EXT
	mv $LIB-$VMAJOR.$VMINOR.[0-9]* $LIB-$VMAJOR.$VMINOR-src/
	cd $LIB-$VMAJOR.$VMINOR-src
	
	./autogen.sh
	./configure --prefix=$INSTALLDIR
	make -j2
	make install
	cd $INSTALLDIR/../
done


OS=`uname -s`
if [ "$OS" = "Darwin" ]; then
	OS="Mac"
fi

ARCH=`uname -m`
echo "Architecture: " $ARCH


cp $INSTALLDIR/lib/lib*so $LIBDIR/$OS"_"$ARCH/
cp $INSTALLDIR/lib/lib*so* $LIBDIR/$OS"_"$ARCH/


exit 0

echo "Getting installed system SDL2 libs and installing them locally in lib/"

for ARCH in $ARCHS; do
	TARGETARCH=$ARCH
	case $ARCH in
	i386|i486|i586|i686)
		TARGETARCH=x86
		;;
	esac
	for LIB in $LIBS; do
		# Install the libs from the system.
		cp -a /usr/lib/$ARCH-linux-gnu/lib$LIB-$VMAJOR.$VMINOR.so.$VMINOR \
			lib/$OS"_"$TARGETARCH/
	done
done



