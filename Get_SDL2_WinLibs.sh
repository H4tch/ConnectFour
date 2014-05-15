
OS="Windows"
LIBS="SDL2 SDL2_image SDL2_ttf SDL2_mixer"
#ARCHS="i686 x86_64"
#COMPILER="w64-mingw32"
LIBDIR=`pwd`/lib
DIR=third_party
VERSION=2.0
ARCHIVE=tar.gz

mkdir -p $DIR
cd $DIR

wget -c http://www.libsdl.org/release/SDL2-devel-2.0.3-mingw.tar.gz -O SDL2-$VERSION-$ARCHIVE
wget -c https://www.libsdl.org/projects/SDL_image/release/SDL2_image-devel-2.0.0-mingw.tar.gz -O SDL2_image-$VERSION-$ARCHIVE
wget -c https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-devel-2.0.12-mingw.tar.gz -O SDL2_ttf-$VERSION-$ARCHIVE
wget -c http://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-devel-2.0.0-mingw.tar.gz -O SDL2_mixer-$VERSION-$ARCHIVE

for LIB in $LIBS; do
	tar -xzf $LIB-$VERSION-$ARCHIVE
	mv $LIB-$VERSION.* $LIB-$VERSION
	cp $LIB-$VERSION/Makefile $LIB-$VERSION/Makefile.bak
	cat $LIB-$VERSION/Makefile | sed s/"\$(CROSS_PATH)"/"\/"usr/g > $LIB-$VERSION/Makefile
done

mkdir -p $LIBDIR/$OS"_x86/"
mkdir -p $LIBDIR/$OS"_x86_64/"
for LIB in $LIBS; do
	cd $LIB-$VERSION && sudo make cross && cd ../
	cp $LIB-$VERSION/i686-w64-mingw32/bin/* $LIBDIR/$OS"_x86/"
	cp $LIB-$VERSION/x86_64-w64-mingw32/bin/* $LIBDIR/$OS"_x86_64/"
done

# These should be statically linked.
cp /usr/i686-w64-mingw32/lib/libwinpthread-1.dll $LIBDIR/$OS"_x86/"
cp /usr/x86_64-w64-mingw32/lib/libwinpthread-1.dll $LIBDIR/$OS"_x86_64/"



