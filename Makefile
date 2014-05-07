
BIN 	:= game
#BINDIR	:= $(PREFIX)/bin
CC  	:= g++
CFLAGS 	:= -g -c -std=c++0x -Wall -pedantic `sdl2-config --cflags`
LINKERFLAGS := -Wl,-rpath,\$$ORIGIN/lib/ -static-libgcc
INCLUDES:= -Iinclude/
LIBS 	:= -Llib/ -lSDL2 -lSDL2_image -lSDL2_ttf #-lGL #box2d #sfml
DEFINES	:= -DDATE='"'$$DATE'"'
SRC 	:= $(PWD)

SOURCES	:=	 				\
	$(SRC)/main.cpp 		\
	$(SRC)/Game.cpp			\
	$(SRC)/Board.cpp		

OBJECTS	:= $(SOURCES:.cpp=.o)


all: $(BIN)

$(BIN): $(OBJECTS)
	$(CC) $(LINKERFLAGS) $^ -o $@ $(LIBS)

.cpp.o:
	$(CC) $(CFLAGS) $(DEFINES) $< -o $@ $(INCLUDES)

clean:
	rm $(OBJECTS)


.PHONY: all
.PHONY: $(BIN)
.PHONY: .cpp.o
.PHONY: clean


