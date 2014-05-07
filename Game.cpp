
#include "Game.h"
#include "SDL2/SDL_timer.h"
#include "SDL2/SDL_ttf.h"

#include <cmath>
#include <sstream>


void Game::init() {
	SDL_Init( SDL_INIT_EVERYTHING );
	Image::init();
	TTF_Init();
}


void Game::shutdown() {
	TTF_Quit();
	Image::quit();
	SDL_Quit();
}


Game::Game()
	: graphics( new Graphics )
	,board( Rect( 0, 0, graphics->getWidth(), graphics->getHeight() ), 7, 6 )
	,playerSprite( { Texture( graphics->getRendererPtr(), "data/Bitcoin.png" ),
		 			Texture(graphics->getRendererPtr(), "data/Litecoin.png") } )
	//,litecoin( graphics->getRendererPtr(), "data/Litecoin.png" )
	,cell( graphics->getRendererPtr(), "data/Cell.png" )
	,selection( graphics->getRendererPtr(), "data/Selection.png" )
	,dogeHead( graphics->getRendererPtr(), "data/DogeHead.png" )
	,font( TTF_OpenFont( "data/ComicSans.ttf", 56 ) )
	,winText( graphics->getRendererPtr() )
{
	assert( font );
	selectedColumn = std::ceil( board.getColumns() / 2 );
	SDL_SetRenderDrawColor( graphics->getRenderer(), 200, 200, 200, 255 );
}


Game::~Game() {
	TTF_CloseFont( font );
}


void Game::update()
{}


void Game::run()
{
	while ( !quit ) {
		// Don't update the screen if nothing happened.
		// Keep checking for input.
		do {
			SDL_Delay( 60 );
		} while ( !handleEvents() );
		
		render();
		
		if ( !winner ) {
		  winner = board.findWinner();
		  if ( winner ) {
			std::stringstream text;
			text << "Player " << winner << " won the Gaem!!1!";
			SDL_Color color{ 220, 220, 10 };
			SDL_Surface* image = TTF_RenderUTF8_Solid( font, text.str().c_str(), color );
			winText.createFromImageData( image );
			SDL_FreeSurface( image );
			assert( winText.getData() );
			std::cout << text.str() << "\n";
		  }
		}
	}
}


void Game::render()
{
	SDL_SetRenderDrawColor( graphics->getRenderer(), 220, 220, 220, 255 );
	graphics->clear();
	
	for ( unsigned int c = 0; c < board.getColumns(); ++c ) {
		if ( !winner && (c == selectedColumn) ) {
			for ( unsigned int r = 0; r < board.getRows(); ++r ) {
				selection.draw( board.getFullCellBox( c, r ) );
			}
		} else {
			for ( unsigned int r = 0; r < board.getRows(); ++r ) {
				cell.draw( board.getFullCellBox( c, r ) );
			}
		}
	}
	
	// Highlight the winning cells.
	// TODO: Highlight matches greater than four. Add Boad::winningMatches
	if ( winner ) {
		unsigned int c,r;
		c = board.getWinStartingCol();
		r = board.getWinStartingRow();
		selection.draw( board.getFullCellBox( c, r ) );
		switch( board.getWinDirection() ) {
		case Board::WinDirection::Horizontal:
			selection.draw( board.getFullCellBox( c-1, r ) );
			selection.draw( board.getFullCellBox( c-2, r ) );
			selection.draw( board.getFullCellBox( c-3, r ) );
			break;
		case Board::WinDirection::UpLeft:
			selection.draw( board.getFullCellBox( c-1, r-1 ) );
			selection.draw( board.getFullCellBox( c-2, r-2 ) );
			selection.draw( board.getFullCellBox( c-3, r-3 ) );
			break;
		case Board::WinDirection::UpRight:
			selection.draw( board.getFullCellBox( c+1, r-1 ) );
			selection.draw( board.getFullCellBox( c+2, r-2 ) );
			selection.draw( board.getFullCellBox( c+3, r-3 ) );
			break;
		case Board::WinDirection::Vertical:
			selection.draw( board.getFullCellBox( c, r-1 ) );
			selection.draw( board.getFullCellBox( c, r-2 ) );
			selection.draw( board.getFullCellBox( c, r-3 ) );
			break;
		default: break;
		}
	}
	
	SDL_SetRenderDrawColor( graphics->getRenderer(), 255, 0, 255, 255 );
	board.drawGrid( *graphics->getRenderer() );
	
	unsigned int value = 0;
	for ( int c = board.getColumns()-1; c >= 0; --c ) {
		for ( int r = board.getRows()-1; r >= 0; --r ) {
			value = board.get( c, r );
			if ( value == 0 ) {
				break;
			}
			if ( value - 1 > playerSprite.size() ) {
				// draw invalid texture
			}
			playerSprite[ value-1 ].draw( board.getCellBox( c, r ) );
		}
	}
	
	if ( winner ) {
		// DOGE!!!
		dogeHead.draw( Rect( graphics->getWidth() / 2 - 200,
							graphics->getHeight() / 2 - 200,
							400, 400 ) );
		winText.draw( (graphics->getWidth() - winText.getClip().w) / 2, 80 );
	} else {
	
		if ( currentPlayer > playerSprite.size() ) {
			std::cout << "Player " << currentPlayer << " is not valid.\n";
			currentPlayer = playerSprite.size();
		}
	
		if ( selectedColumn != (unsigned int)-1 ) {
			playerSprite[ currentPlayer-1 ].setAlpha( .6 );
			playerSprite[ currentPlayer-1 ].
					draw( board.getCellBox( selectedColumn, 0 ) );
			playerSprite[ currentPlayer-1 ].setAlpha( 1 );
		}
	}
	
	graphics->display();
}


bool Game::handleEvents()
{
  bool processedAnything = false;
  SDL_Event e;
  while( SDL_PollEvent( &e ) ) {
  	processedAnything = true;
	switch( e.type ) {
	case SDL_QUIT:
		quit = true;
		break;
	case SDL_KEYDOWN:
		if ( winner ) { quit = true; break; }
		switch( e.key.keysym.sym ) {
		case SDLK_RETURN:
		case SDLK_SPACE:
			board.dropPiece( currentPlayer, selectedColumn );
			if ( currentPlayer == 1 ) { currentPlayer = 2; }
			else { currentPlayer = 1; }
			selectedColumn = std::ceil( board.getColumns() / 2 );
			selectedColumn -= 1;
			selectedColumn = board.findOpenColumn( selectedColumn, 1 );
			break;
		case SDLK_ESCAPE:
			quit = true;
			break;
		case SDLK_LEFT:
			selectedColumn = board.findOpenColumn( selectedColumn, -1 );
			break;
		case SDLK_RIGHT:
			selectedColumn = board.findOpenColumn( selectedColumn, 1 );
			break;
		default: break;
		}
		break;
	default: break;
	}
  }
  return processedAnything;
}





