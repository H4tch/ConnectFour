VERSION=2.0
ARCHIVE=tar.gz

# TODO: Copy Lib Licenses.

wget -c http://www.libsdl.org/release/SDL2-devel-2.0.3-mingw.tar.gz -O SDL2-$VERSION-$ARCHIVE
wget -c https://www.libsdl.org/projects/SDL_image/release/SDL2_image-devel-2.0.0-mingw.tar.gz -O SDL2_image-$VERSION-$ARCHIVE
wget -c https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-devel-2.0.12-mingw.tar.gz -O SDL2_ttf-$VERSION-$ARCHIVE
wget -c http://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-devel-2.0.0-mingw.tar.gz -O SDL2_mixer-$VERSION-$ARCHIVE


tar -xzf SDL2-$VERSION-$ARCHIVE
tar -xzf SDL2_image-$VERSION-$ARCHIVE
tar -xzf SDL2_ttf-$VERSION-$ARCHIVE
tar -xzf SDL2_mixer-$VERSION-$ARCHIVE

mv SDL2-2.0.* SDL2-2.0
mv SDL2_image-2.0.* SDL2_image-2.0
mv SDL2_mixer-2.0.* SDL2_mixer-2.0
mv SDL2_ttf-2.0.* SDL2_ttf-2.0


# For each file you'll need to replace "$(CROSS)/" with "/usr/" under the
# "cross" make rule. This will install the libs globally under MinGW's path.
gedit SDL2-2.0/Makefile
gedit SDL2_image-2.0/Makefile
gedit SDL2_ttf-2.0/Makefile
gedit SDL2_mixer-2.0/Makefile


exit 1


# Now you'll need to run these commands.

# Install globally.
cd SDL2-2.0 && sudo make cross && cd ../
cd SDL2_image-2.0 && sudo make cross && cd ../
cd SDL2_ttf-2.0 && sudo make cross && cd ../
cd SDL2_mixer-2.0 && sudo make cross && cd ../


# Install Locally.

mkdir -p winlib/x86/
mkdir -p winlib/x86_64/

cp SDL2-2.0/i686-w64-mingw32/bin/*.dll winlib/x86/
cp SDL2_image-2.0/i686-w64-mingw32/bin/*.dll winlib/x86/
cp SDL2_ttf-2.0/i686-w64-mingw32/bin/*.dll winlib/x86/
cp SDL2_mixer-2.0/i686-w64-mingw32/bin/*.dll winlib/x86/

cp SDL2-2.0/x86_64-w64-mingw32/bin/*.dll winlib/x86_64/
cp SDL2_image-2.0/x86_64-w64-mingw32/bin/*.dll winlib/x86_64/
cp SDL2_ttf-2.0/x86_64-w64-mingw32/bin/*.dll winlib/x86_64/
cp SDL2_mixer-2.0/x86_64-w64-mingw32/bin/*.dll winlib/x86_64/

# These probably don't belong here. I need to figure out how to statically link
# these into the binaries...
cp /usr/i686-w64-mingw32/lib/libwinpthread-1.dll winlib/x86/
cp /usr/x86_64-w64-mingw32/lib/libwinpthread-1.dll winlib/x86_64/




