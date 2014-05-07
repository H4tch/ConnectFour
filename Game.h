#ifndef GAME_H
#define GAME_H

#include "Graphics.h"
#include "Texture.h"
#include "Board.h"

#include <array>


class Game
{
public:
	static void init();
	static void shutdown();
	
	Game();
	~Game();
	void run();
	unsigned int getWinner() const { return winner; }
	unsigned int getCurrentPlayer() const { return currentPlayer; }

private:
	void update();
	void render();
	//void renderWinScreen();
	bool handleEvents();
	
	PtrS( Graphics ) graphics;
	Board board;
	std::array<Texture, 2> playerSprite;
	Texture cell;
	Texture selection;
	
	Texture dogeHead;
	double dogeRot = 0;
	double dogeScale = 0;
	
	TTF_Font* font = nullptr;
	Texture winText;
	
	unsigned int selectedColumn = 0;
	unsigned int currentPlayer = 1;
	unsigned int winner = 0;
	bool quit = false;
};



#endif //GAME_H

