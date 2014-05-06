#ifndef IMAGE_H
#define IMAGE_H

#include <string>
#include <iostream>


class Image
{
	std::string filename;
	SDL_Surface* image = nullptr;
	
public:
	
	static void init() {
		IMG_Init( IMG_INIT_JPG | IMG_INIT_PNG | IMG_INIT_TIF );
	}
	
	static void quit() { IMG_Quit(); }
	
	Image( std::string filename )
		: filename( filename )
	{
		image = IMG_Load( filename.c_str() );
	}

	~Image() { SDL_FreeSurface( image ); }
	
	std::string getFilename() const { return filename; }
	
	SDL_Surface* getData() { return image; }
};




#endif //IMAGE_H

