
#include "Board.h"
#include "Graphics.h"

#include <iostream>
#include <cmath>

Board::Board( Rect rect, int columns, int rows )
	: cells( columns, std::vector<int>( rows ) ), box( rect )
	,columns( columns ), rows( rows )
	
{
	assert( columns );
	assert( rows );
	cellSize = std::min( rect.w/columns, rect.h/rows );
	cellSpacing = std::floor(cellSize / 10.1);
	cellSize -= cellSpacing;
	//std::cout << "width: " << box.w << "  height: " << box.h << "\n";
	//std::cout << "columns: " << columns << "  rows: " << rows << "\n";
	//std::cout << "cellsize: " << cellSize
	//		<< "  spacing: " << cellSpacing << "\n";
}


unsigned int Board::findWinner()
{
	unsigned int match = 0;
	unsigned int matches = 1;
	unsigned checkCol = 0;
	unsigned checkRow = 0;
	
	for ( int c = columns - 1; c >= 0; --c )
	{
	  for ( int r = rows - 1; r >= 0; --r )
	  {
		match = get( c, r );
		if ( !match ) { break; }
		matches = 1;

		// ### Check horizontal matches. ###
		checkCol = c-1;
		if ( checkCol < 2 ) { goto secondCheck; }
		while ( valid( checkCol, r ) && get( checkCol, r ) == match ) {
			++matches;
			--checkCol;
		}
		if ( matches == 4 ) {
			winDirection = WinDirection::Horizontal;
			winStartingCol = c;
			winStartingRow = r;
			return match;
		}

		
		// ### Check upper-left diagonal matches. ###
	  secondCheck:
		matches = 1;
		checkCol = c-1;
		checkRow = r-1;
		if ( checkCol < 2 ) { goto thirdCheck; }
		if ( checkRow < 2 ) { goto thirdCheck; }
		while ( valid( checkCol, checkRow )
				&& get( checkCol, checkRow ) == match )
		{
			++matches;
			--checkCol;
			--checkRow;
		}
		if ( matches == 4 ) {
			winDirection = WinDirection::UpLeft;
			winStartingCol = c;
			winStartingRow = r;
			return match;
		}
		
		// ### Check upper-right diagonal matches. ###
	  thirdCheck:
		matches = 1;
		checkCol = c+1;
		checkRow = r-1;
		if ( checkCol >= columns - 2 ) { goto finalCheck; }
		while ( valid( checkCol, checkRow )
				&& get( checkCol, checkRow ) == match )
		{
			++matches;
			++checkCol;
			--checkRow;
		}
		if ( matches == 4 ) {
			winDirection = WinDirection::UpRight;
			winStartingCol = c;
			winStartingRow = r;
			return match;
		}
		
		
		// ### Check vertical matches. ###
	  finalCheck:
		matches = 1;
		checkRow = r-1;
		// No more chips in this column, skip rest of the rows.
		if ( !valid( c, checkRow ) ) { break; }
		
		while ( valid( c, checkRow ) && get( c, checkRow ) == match ) {
			++matches;
			--checkRow;
		}
		
		//std::cout << "Found " << matches << " matches\n";
		if ( matches == 4 ) {
			winDirection = WinDirection::Vertical;
			winStartingCol = c;
			winStartingRow = r;
			return match;
		}
	  }
	}
	return 0;
}


void Board::dropPiece( int value, unsigned int column ) {
	if ( column >= getColumns() ) { return; }
	for ( int i = rows-1; i >= 0; --i ) {
		if ( !get( column, i ) ) {
			set( column, i, value );
			std::cout << value << " Inserted"
					<< " at (" << column << "," << i << ")\n";
			break;
		}
	}
}


Rect Board::getCellBox( int c, int r ) {
	assert( valid( c, r ) );
	return Rect( box.x + (c * (cellSize + cellSpacing)) + cellSpacing/2,
				 box.y + (r * (cellSize + cellSpacing)) + cellSpacing/2,
				 cellSize, cellSize );
}

Rect Board::getFullCellBox( int c, int r ) {
	assert( valid( c, r ) );
	return Rect( box.x + (c * (cellSize + cellSpacing)),
				 box.y + (r * (cellSize + cellSpacing)),
				 cellSize + cellSpacing, cellSize + cellSpacing );
}


void Board::drawGrid( Renderer& renderer )
{
	SDL_SetRenderDrawColor( &renderer, 50, 50, 200, 255 );
	Rect b = box;
	
	// Draw vertical lines.
	for ( ; b.x <= box.x + box.w; b.x += cellSize + cellSpacing ) {
		SDL_RenderDrawLine( &renderer, b.x, box.y, b.x, box.y + box.h );
	}
	
	// Draw horizontal lines.
	for ( ; b.y <= box.y + box.h; b.y += cellSize + cellSpacing ) {
		SDL_RenderDrawLine( &renderer, box.x, b.y, box.x + box.w, b.y );
	}
}


int Board::findOpenColumn( unsigned int current, int step ) const
{
	unsigned int started = current;
	current += step;
	if ( current == getColumns() ) { current = 0; }
	current = clamp( current, 0U, getColumns()-1 );
	while ( get( current, 0 ) ) {
		if ( current == started ) { return -1; }
		current += step;
		if ( current == getColumns() ) { current = 0; }
		current = clamp( current, 0U, getColumns()-1 );
	}
	return current;
}


std::ostream& operator<<( std::ostream& os, const Board board ) {
	std::cout << "Todo: print out the board\n";
	return os;	
}



