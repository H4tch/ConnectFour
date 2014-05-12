## Cross-Platform Makefile for Mac/Linux.
## You can cross-compile to other platforms and architectures by exporting
## OS and ARCH environment variables.
## TODO: Bultin Ability to cross-compile dependecies.


BIN 	:= game
EXT		:= # Set to '.exe' on Windows.
SRC 	:= $(PWD)/src
BUILDDIR:= $(PWD)/build
LIBDIR	:= $(PWD)/lib
SYSTEM	 = $(OS)_$(ARCH)
CC  	:= g++
CCFLAGS	:= -c -std=c++0x -Wall -pedantic `sdl2-config --cflags`
LINKERFLAGS = -fuse-ld=gold -Wl,-Bdynamic,-rpath,\$$ORIGIN/$(LIBDIR)
INCLUDES:= -Iinclude/
LIBS 	 = -L$(LIBDIR) -lSDL2 -lSDL2_image -lSDL2_ttf #-lGL #box2d #sfml
STATICLIBS := -Wl,-Bstatic -static-libgcc -static-libstdc++ 
WINLIBS	:= -lmingw32 -lSDL2main -mwindows -lwinmm
STATICWINLIBS := 
DEFINES	:= -DDATE='"'$$DATE'"'



#### BEGIN SECTION FOR DETECTING AND FIXING UP ARCH ####
# If we are on Linux cross-compiling to Windows, make sure ARCH is setup
# correctly. This means we can't test for Windows_NT directly.
# NOTE: WINDOWS ARCH VALUES CAN BE: AMD64 IA64 x86
ifeq ($(ARCH),)
	ifeq ($(PROCESSOR_ARCHITECTURE),)
		ARCH := $(shell uname -p)
	else
		ARCH := PROCESSOR_ARCHITECTURE
	endif
endif

# More robust architecture detection on Windows.
ifneq ($(PROCESSOR_ARCHITEW6432),)
	PROCESSOR_ARCHITECTURE = $(PROCESSOR_ARCHITEW6432)
endif

# If not on Windows. Use more advanced methods to fixup ARCH.
ifeq ($(PROCESSOR_ARCHITECTURE),)
	ifneq ($(filter x86_64%,$(ARCH)),)
		ARCH := x86_64
	else ifneq ($(filter %86,$(ARCH)),)
		ARCH := x86
	else ifneq ($(filter %arm,$(ARCH)),)
		ARCH := arm
	else ifneq ($(filter arm%,$(ARCH)),)
		ARCH := arm
	else ifneq ($(filter %ARM,$(ARCH)),)
		ARCH := arm
	else ifneq ($(filter ARM%,$(ARCH)),)
		ARCH := arm
	endif
endif

# Catch other possible ARCH values and correct it. 
ifeq ($(ARCH),ia32)
	ARCH := x86
else ifeq ($(ARCH),IA32)
	ARCH := x86
else ifeq ($(ARCH),ia64)
	ARCH := x86_64
else ifeq ($(ARCH),IA64)
	ARCH := x86_64
else ifeq ($(ARCH),amd64)
	ARCH := x86_64
else ifeq ($(ARCH),AMD64)
	ARCH := x86_64
else ifeq ($(ARCH),x64)
	ARCH := x86_64
else ifeq ($(ARCH),ARM)
	ARCH := arm
endif
#### DONE SETTING UP ARCH ####



#### DETECT OS AND SET UP COMPILER AND FLAGS ####
# TODO: Android build chain.
ifeq ($(OS),)
	OS := $(shell uname -s)
endif

ifeq ($(OS),Windows_NT)
	EXT 	:= .exe
	LIBS 	:= $(WINLIBS) $(LIBS)
	DEFINES	+= -DWIN32
else ifeq ($(OS),Linux)
	DEFINES	+= -DLINUX
else ifeq ($(OS), Darwin)
	DEFINES	+= -DOSX
endif

ifeq ($(ARCH),x86_64)
	ifeq ($(OS), Windows_NT)
		CC = x86_64-w64-mingw32-g++
		INCLUDES += -I/usr/x86_64-w64-mingw32/include/
		STATICLIBS += $(STATICWINLIBS)
	endif
	LIBDIR := $(LIBDIR)/x86_64/
	DEFINES += -DX86_64
else ifeq ($(ARCH),x86)
	ifeq ($(OS), Windows_NT)
		CC = i686-w64-mingw32-g++
		INCLUDES += -I/usr/i686-w64-mingw32/include/
	endif
	CCFLAGS += -m32
	LINKERFLAGS += -m32
	LIBDIR := $(LIBDIR)/x86/
	DEFINES += -DX86
else ifeq ($(ARCH),arm)
	ifeq ($(OS), Windows_NT)
		CC = NEED_MING_ARM_COMPILER
	else
		CC = NEED_ARM_COMPILER
	endif
	LIBDIR := $(LIBDIR)/arm/
	DEFINES += -DARM
endif
#### DONE SETTING UP COMPILER AND COMPILER FLAGS ####



SOURCES	:=	 				\
	$(SRC)/main.cpp 		\
	$(SRC)/Game.cpp			\
	$(SRC)/Board.cpp		

# This could probably be skipped.
OBJECTS	:= $(SOURCES:.cpp=.o)

BUILD_DEBUG	:= $(patsubst $(SRC)/%,$(BUILDDIR)/$(SYSTEM).debug/%,$(OBJECTS))
BUILD_RELEASE:= $(patsubst $(SRC)/%,$(BUILDDIR)/$(SYSTEM).release/%,$(OBJECTS))



all: debug

debug: initDebug $(BUILD_DEBUG)
	$(CC) $(STATICLIBS) $(LINKERFLAGS) $(BUILD_DEBUG) -o $(BUILDDIR)/$(BIN)_$(SYSTEM).debug$(EXT) $(LIBS)
	cp $(BUILDDIR)/$(BIN)_$(SYSTEM).debug$(EXT) $(BIN)$(EXT)

$(BUILD_DEBUG) : $(BUILDDIR)/$(SYSTEM).debug/%.o: $(SRC)/%.cpp
	$(CC) -g $(CCFLAGS) $(DEFINES) $< -o $@ $(INCLUDES)

release: initRelease $(BUILD_RELEASE)
	$(CC) $(STATICWINLIBS) $(LINKERFLAGS) $(BUILD_RELEASE) -o $(BUILDDIR)/$(BIN)_$(SYSTEM)$(EXT) $(LIBS)

$(BUILD_RELEASE) : $(BUILDDIR)/$(SYSTEM).release/%.o: $(SRC)/%.cpp
	$(CC) $(CCFLAGS) $(DEFINES) $< -o $@ $(INCLUDES)

initDebug:
	mkdir -p $(BUILDDIR)/$(SYSTEM).debug

initRelease:
	mkdir -p $(BUILDDIR)/$(SYSTEM).release

clean:
	mkdir -p $(BUILDDIR)
	rm -r $(BUILDDIR)


.PHONY: all
.PHONY: debug
.PHONY: release
.PHONY: initDebug
.PHONY: initRelease
.PHONY: clean


