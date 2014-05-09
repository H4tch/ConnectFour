
#include "SDL2/SDL_main.h"
#include "Game.h"


int main( int argc, char* argv[] ) {
	Game::init();
	Game* game = new Game();
	game->run();
	// Game must be deleted and resources freed, before the
	// libraries are shutdown.
	delete game;
	Game::shutdown();
	return 0;
}



