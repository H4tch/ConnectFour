#ifndef GRAPHICS_H
#define GRAPHICS_H

#include "SDL2/SDL_events.h"
#include "SDL2/SDL_render.h"
#include "SDL2/SDL_ttf.h"

#include "Rect.h"
#include "Utility.h"

typedef SDL_Renderer Renderer;
typedef SDL_Window Window;

class RenderTarget {};


class Renderable
{
	//PtrW<Graphics> graphics;
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
	
	~Graphics() {}
	
	// Render whats on the screen.
	void display() { SDL_RenderPresent( renderer.get() ); }
	
	// Clear whats on the screen.
	void clear() { SDL_RenderClear( renderer.get() ); }
	
	SDL_Window* getWindow() { return window.get(); }
	
	SDL_Renderer* getRenderer() { return renderer.get(); }
	
	PtrS<SDL_Window> getWindowPtr() { return window; }
	
	PtrS<SDL_Renderer> getRendererPtr() { return renderer; }
	
	//void setWidth( int width ) {}
	//void setWidth( int width ) {}
	
	int getWidth() const { return width; }
	
	int getHeight() const { return height; }
	
private:
	
	SDL_Window* createWindow() {
		//std::cout << "Creating window: " << width << " " << height << "\n";
		return SDL_CreateWindow( "Game", 0, 0, width, height,
								SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE );
	}
	
	SDL_Renderer* createRenderer()
	{
		SDL_Renderer* renderer =
			SDL_CreateRenderer( window.get(), -1, SDL_RENDERER_ACCELERATED );
		SDL_SetRenderDrawColor( renderer, 0, 0, 0, 255 );
		SDL_RenderClear( renderer );
		return renderer;
	}
	
	int width = 770;
	int height = 660;
	
	PtrS<SDL_Window> window;
	PtrS<SDL_Renderer> renderer;
};



#endif //GRAPHICS_H

