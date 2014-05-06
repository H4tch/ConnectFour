#ifndef TEXTURE_H
#define TEXTURE_H

#include "Image.h"
#include "Rect.h"

#include "Graphics.h"
#include "Utility.h"


class Texture : public Renderable
{
public:
	
	Texture( PtrS( Renderer ) renderer, std::string filename )
		: renderer( renderer )
	{
		Image i( filename );
		createFromImage( i );
	}
	
	Texture( PtrS( Renderer ) renderer, Image& image )
		: renderer( renderer )
	{
		createFromImage( image );
		if ( !texture ) {
			std::cout << "Failed to create Texture of '" << image.getFilename()
					<< "' image.\n";
			return;
		}
	}
	
	bool createFromImage( Image& image )
	{
		if ( !image.getData() ) {
			return false;
		}
		if ( texture ) {
			SDL_DestroyTexture( texture );
			texture = nullptr;
			clip = Rect();
		}
		
		texture = SDL_CreateTextureFromSurface( renderer.lock().get(),
												image.getData() );
		if ( !texture ) { return false; }
		
		SDL_QueryTexture( texture, nullptr, nullptr, &clip.w, &clip.h );
		return true;
	}
	
	void draw( int x, int y) {
		SDL_Rect rect{ x, y, clip.w, clip.h };
		SDL_RenderCopy( renderer.lock().get(),
						texture, (const SDL_Rect*)&clip, &rect );
	}
	
	void draw( Rect rect ) {
		SDL_RenderCopy( renderer.lock().get(),
						texture, (const SDL_Rect*)&clip,
						(const SDL_Rect*)&rect );
	}
	
	void draw( Renderer& renderer ) { }
	
	void draw( RenderTarget& render ) { }
	
	Rect getClip() const { return clip; }
	
	SDL_Texture* getData() { return texture; }
	
private:
	PtrW( Renderer ) renderer;
	SDL_Texture* texture = nullptr;
	Rect clip = Rect();
};



#endif //TEXTURE_H

