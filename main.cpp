

#include "SDL2/SDL_render.h"
#include "SDL2/SDL_timer.h"
#include "SDL2/SDL_ttf.h"
#include "SDL2/SDL_image.h"
#include "SDL2/SDL_rect.h"
#include "SDL2/SDL_events.h"
#include "SDL2/SDL_main.h"

#include "Graphics.h"
#include "Texture.h"
#include "Image.h"

#include <iostream>
#include <cassert>


// Make this binary compatible with SDL_Rect so I can reinterpret_cast<> it?
//struct Rect { int x,y,w,h; };



int main( int argc, char* argv[] )
{
	SDL_Init( SDL_INIT_EVERYTHING );
	Image::init();
	
	int winW = 800;
	int winH = 600;
	
	PtrS( Graphics ) graphics( new Graphics );
	
	Image bcI("data/Bitcoin.png");
	Image lcI("data/Litecoin.png");
	
	Texture bcT( graphics->getRendererPtr(), bcI );
	Texture lcT( graphics->getRendererPtr(), lcI );
	
	PtrW( Renderer ) testRenderer = graphics->getRendererPtr();
	
	//assert( bcT.getData() ); assert( lcT.getData() );
	
	SDL_SetRenderDrawColor( graphics->getRenderer(), 200, 200, 200, 255 );
	
	SDL_RenderClear( graphics->getRenderer() );
	
		
	Rect rect( winW/2 - 50, winH/2 - 100, 100, 100 );
	
	bcT.draw( rect );
	
	rect.y = (winH/2);
	
	lcT.draw( rect );
	
	SDL_RenderPresent( graphics->getRenderer() );
	
	
	SDL_Event e;
	bool quit = false;
	
	while( !quit ) {
		while( SDL_PollEvent( &e ) ) {
			switch( e.type ) {
			case SDL_QUIT:
				quit = true;
				break;
			case SDL_KEYDOWN:
				switch( e.key.keysym.sym ) {
				case SDLK_ESCAPE:
					quit = true;
					break;
				default: break;
				}
				break;
			default: break;
			}
		}
 	}
	
	//SDL_Delay( 2000 );
	
	Image::quit();
	SDL_Quit();
	return 0;
}



