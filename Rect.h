#ifndef RECT_H
#define RECT_H

#include "SDL2/SDL_rect.h"

#include <iostream>


// Binary compatible with SDL_Rect.
struct Rect
{
	int x = 0;
	int y = 0;
	int w = 0;
	int h = 0;
	
	Rect() {}
	
	Rect( int x, int y )
		: x( x ), y( y )
	{}

	Rect( int x, int y, int w )
		: x( x ), y( y ), w( w ), h( w )
	{}

	Rect( int x, int y, int w, int h )
		: x( x ), y( y ), w( w ), h( h )
	{}
	
	
	Rect( SDL_Rect r )
		: x( r.x ), y( r.y ), w( r.w ), h( r.h )
	{}
	
	Rect centeredOn( Rect rect ) {
		return Rect( rect.x + (rect.w - w)/2, rect.y + (rect.h - h)/2, w, h );
	}
	
	friend std::ostream& operator<<( std::ostream& os, const Rect& rect ) {
		return os << "(" << rect.x << "," << rect.y << ")["
				<< rect.w << "x" << rect.h << "]"; 
	}
};




#endif //RECT_H
