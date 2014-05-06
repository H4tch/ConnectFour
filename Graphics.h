#ifndef GRAPHICS_H
#define GRAPHICS_H

#include "Rect.h"
#include "Utility.h"


#define Renderer SDL_Renderer
#define Window SDL_Window

//typedef std::unique_ptr< SDL_Renderer, void (*)( SDL_Renderer* ) > Renderer;

/*Window window = newResource(
				SDL_CreateWindow( "Game", 0, 0, 800, 600,
							SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE ),
				SDL_DestroyWindow );

Renderer renderer = newResource(
					SDL_CreateRenderer( window.get(), -1,
						SDL_RENDERER_ACCELERATED ),
					SDL_DestroyRenderer );
*/



class RenderTarget
{};



class Renderable
{
	//PtrW( Graphics ) graphics;
public:
	virtual void draw( int x, int y ) = 0;
	virtual void draw( Rect rect ) = 0;
	virtual void draw( Renderer& renderer ) = 0;
	//virtual void draw( Graphics& graphics, int x, int y ) = 0;
	//virtual void draw( Graphics& graphics, Rect rect ) = 0;
	virtual void draw( RenderTarget& dest ) = 0;
	//virtual void draw( RenderTarget& dest, int x, int y ) = 0;
	//virtual void draw( RenderTarget& dest, int x, int y ) = 0;
};




class Graphics
{
public:
	Graphics()
		: window( createWindow(), SDL_DestroyWindow )
		,renderer( createRenderer(), SDL_DestroyRenderer )
	{}
	
	Graphics( SDL_Window* window )
		: window( window, SDL_DestroyWindow )
		,renderer( createRenderer(), SDL_DestroyRenderer )
	{}
	
	Graphics( SDL_Window* window, SDL_Renderer* renderer )
		: window( window, SDL_DestroyWindow )
		,renderer( renderer, SDL_DestroyRenderer )
	{}
	
	~Graphics() {
		SDL_DestroyRenderer( renderer.get() );
		SDL_DestroyWindow( window.get() );
	}
	
	SDL_Window* getWindow() { return window.get(); }
	
	SDL_Renderer* getRenderer() { return renderer.get(); }
	
	PtrS( SDL_Window ) getWindowPtr() { return window; }
	
	PtrS( SDL_Renderer ) getRendererPtr() { return renderer; }
	
private:
	
	SDL_Window* createWindow() {
		return SDL_CreateWindow( "Game", 0, 0, 800, 600,
								SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE );
	}
	
	SDL_Renderer* createRenderer() {
		return SDL_CreateRenderer( window.get(), -1, SDL_RENDERER_ACCELERATED );
	}
	
	PtrS( SDL_Window ) window;
	PtrS( SDL_Renderer ) renderer;
};



#endif //GRAPHICS_H

