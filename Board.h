#ifndef BOARD_H
#define BOARD_H

#include "Rect.h"
#include "Utility.h"

//#include <iostream>
#include <vector>
#include <cassert>

namespace {
	class ostream;
}

struct SDL_Renderer;
typedef SDL_Renderer Renderer;


/// If I want animations I should draw based on the cell's data, but rather have
/// scene graph that contains the sprites...
class Board// : public Renderable
{
public:
	enum WinDirection {
		Horizontal = 1
		,UpLeft
		,UpRight
		,Vertical
	};
	
	Board( Rect rect, int columns, int rows );
	
	void drawGrid( Renderer& renderer );

	void set( int c, int r, unsigned int value ) {
		assert( valid( c, r ) );
		cells[c][r] = value;
	}
	
	int findWinner(); 
	
	void dropPiece( int value, unsigned int column );
	
	unsigned int get( int c, int r ) const {
		assert( valid( c, r ) );
		return cells.at( c ).at( r );
	}
	
	Rect getCellBox( int c, int r );
	
	Rect getFullCellBox( int c, int r );
	
	unsigned int getCellSize() const { return cellSize; }
	
	unsigned int getColumns() const { return columns; }
	
	unsigned int getRows() const { return rows; }
	
	/// Find a non-full Column. Returns -1 on error.
	int findOpenColumn( unsigned int current, int step ) const;
	
	unsigned int getWinStartingCol() const { return winStartingCol; }
	unsigned int getWinStartingRow() const { return winStartingRow; }
	unsigned int getWinDirection() const { return winDirection; }
	
	void fill( unsigned int value );
	
	friend std::ostream& operator<<( std::ostream&, const Board board );
	
	typedef typename std::vector<std::vector<int>>::iterator iterator;
	iterator begin() { return cells.begin(); }
	iterator end() { return cells.end(); }
	
	bool valid( unsigned int c, unsigned int r ) const {
		return ( c < columns ) && ( r < rows );
	}
	
private:
	std::vector< std::vector<int> > cells;
	Rect box;
	unsigned int cellSize = 0;
	unsigned int columns = 0;
	unsigned int rows = 0;
	int cellSpacing = 0;
	
	// Used to highlight the winning pieces.
	int winStartingCol = 0;
	int winStartingRow = 0;
	int winDirection = 0;
};



#endif //BOARD_H

