#ifndef TEXTURE_H
#define TEXTURE_H

#include "Image.h"
#include "Rect.h"

#include "Graphics.h"
#include "Utility.h"


class Texture : public Renderable
{
public:
	Texture( PtrS<Renderer> renderer )
		: renderer( renderer )
	{}
	
	Texture( PtrS<Renderer> renderer, std::string filename )
		: renderer( renderer )
	{
		Image image( filename );
		createFromImage( image );
		if ( !texture ) {
			std::cout << "Failed to create Texture of '" << image.getFilename()
					<< "' image.\n";
			return;
		}
	}
	
	Texture( PtrS<Renderer> renderer, Image& image )
		: renderer( renderer )
	{
		createFromImage( image );
		if ( !texture ) {
			std::cout << "Failed to create Texture of '" << image.getFilename()
					<< "' image.\n";
			return;
		}
	}
	
	~Texture() {
		SDL_DestroyTexture( texture );
	}
	
	bool createFromImage( Image& image ) {
		return createFromImageData( image.getData() );
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
	
	void setClip( Rect rect ) { clip = rect; }
	
	Rect getClip() const { return clip; }
	
	void setAlpha( double alpha ) {
		unsigned char alpha8 = (alpha * 255);
		SDL_SetTextureAlphaMod( texture, alpha8 );
	}
	
	double getAlpha() const {
		unsigned char alpha;
		SDL_GetTextureAlphaMod( texture, &alpha );
		return (alpha / 255);
	}
	
	SDL_Texture* getData() { return texture; }
	
	bool createFromImageData( SDL_Surface* image )
	{
		if ( !image ) { return false; }
		if ( texture ) {
			SDL_DestroyTexture( texture );
			texture = nullptr;
			clip = Rect();
		}
		
		texture = SDL_CreateTextureFromSurface( renderer.lock().get(), image );
		if ( !texture ) { return false; }
		
		SDL_QueryTexture( texture, nullptr, nullptr, &clip.w, &clip.h );
		return true;
	}
	
private:
	PtrW<Renderer> renderer;
	// This should be a shared pointer.
	SDL_Texture* texture = nullptr;
	Rect clip = Rect();
};



#endif //TEXTURE_H

