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
	
	bool playAgain() const { return doPlayAgain; }
	
private:
	void update();
	void render();
	bool handleEvents();
	
	// This shouldn't be shared.
	PtrS<Graphics> graphics;
	Board board;
	std::array<Texture, 2> playerSprite;
	Texture cell;
	Texture selection;
	
	Texture dogeHead;
	// Todo: Roate and scale in-out the dogeHead.
	double dogeRot = 0;
	double dogeScale = 0;
	
	TTF_Font* font = nullptr;
	Texture winText;
	
	unsigned int selectedColumn = 0;
	unsigned int currentPlayer = 1;
	int winner = 0;
	bool quit = false;
	bool doPlayAgain = false;
	//enum GameType { Best2Of3 = 1 };
	//unsigned int gametype = 1;
	//std::array<2, unsigned int> scores;
};



#endif //GAME_H

