
#include "SDL2/SDL_main.h"
#include "Game.h"

int main( int argc, char* argv[] ) {
	Game::init();
	Game game;
	game.run();
	Game::shutdown();
	return 0;
}



