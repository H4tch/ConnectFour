VERSION=2.0
ARCHIVE=tar.gz


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


# Now you'll need to run these commands.
#cd SDL2-2.0 && sudo make cross && cd ../
#cd SDL2_image-2.0 && sudo make cross && cd ../
#cd SDL2_ttf-2.0 && sudo make cross && cd ../
#cd SDL2_mixer-2.0 && sudo make cross && cd ../
