
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
			if ( winner == -1 ) { text << "Tie Game!! Noebody wins :(";
			} else { text << "Player " << winner << " won the Gaem!!1!"; }
			
			SDL_Color color{ 240, 240, 10 };
			SDL_Surface* image = TTF_RenderUTF8_Solid( font, text.str().c_str(), color );
			winText.createFromImageData( image );
			SDL_FreeSurface( image );
			assert( winText.getData() );
			std::cout << text.str() << "\n";
		  }
		}
		if ( quit && playAgain() ) {
			quit = false;
			doPlayAgain = false;
			if ( winner == -1 ) {
				if ( currentPlayer == 1 ) { currentPlayer = 2; }
				else { currentPlayer = 1; }
			} else if ( winner == 1 ) {
				currentPlayer = 2;
			} else {
				currentPlayer = 1;
			}
			winner = 0;
			board.fill( 0 );
			selectedColumn = std::ceil( board.getColumns() / 2 );
		}
	}
}


void Game::render()
{
	SDL_SetRenderDrawBlendMode( graphics->getRenderer(), SDL_BLENDMODE_BLEND );
	SDL_SetRenderDrawColor( graphics->getRenderer(), 32, 32, 32, 255 );
	SDL_SetRenderDrawColor( graphics->getRenderer(), 230, 230, 230, 255 );
	graphics->clear();
	
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
	
	for ( unsigned int c = 0; c < board.getColumns(); ++c ) {
	  for ( unsigned int r = 0; r < board.getRows(); ++r ) {
		unsigned int value = board.get( c, r );
		if ( value - 1 > playerSprite.size() ) { /* invalid player */ }
		else { playerSprite[ value-1 ].draw( board.getCellBox( c, r ) ); }
		if ( !winner && (c == selectedColumn) ) {
			selection.draw( board.getFullCellBox( c, r ) );
		} else {
			cell.draw( board.getFullCellBox( c, r ) );
		}
	  }
	}

	// Highlight the winning cells.
	if ( winner )
	{
		unsigned int c,r;
		c = board.getWinStartingCol();
		r = board.getWinStartingRow();
		int stepCol = -1;
		int stepRow = -1;		
		unsigned int winDir = board.getWinDirection();
		if ( winDir == Board::WinDirection::UpRight ) { stepCol = 1; }
		else if ( winDir == Board::WinDirection::Vertical ) { stepCol = 0; }
		else if ( winDir == Board::WinDirection::Horizontal ) { stepRow = 0; }
		
		while( board.valid( c, r ) && ((int)board.get( c, r ) == winner) ) {
			selection.draw( board.getFullCellBox( c, r ) );
			r += stepRow;
			c += stepCol;
		}
	}
	
	SDL_SetRenderDrawColor( graphics->getRenderer(), 50, 50, 200, 255 );	
	SDL_SetRenderDrawColor( graphics->getRenderer(), 0, 0, 0, 100 );
	//board.drawGrid( *graphics->getRenderer() );	
	
	if ( winner ) {
		// Make background faded.
		SDL_SetRenderDrawColor( graphics->getRenderer(), 0, 0, 0, 92 );
		Rect box = board.getBox();
		SDL_RenderFillRect( graphics->getRenderer(), (const SDL_Rect*)&box );
		
		dogeHead.draw( Rect( graphics->getWidth() / 2 - 200,
							graphics->getHeight() / 2 - 200,
							400, 400 ) );
		winText.draw( (graphics->getWidth() - winText.getClip().w) / 2, 80 );
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
		switch( e.key.keysym.sym ) {
		case SDLK_RETURN:
		case SDLK_SPACE:
			if ( winner ) { doPlayAgain = true; break; }
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
		if ( winner ) { quit = true; }
		break;
	default: break;
	}
  }
  return processedAnything;
}





