## Cross-Platform Makefile for Mac/Linux.
## MIT Licensed. Created by Dan H4tch.
## 
## Supported OS values are: Windows_NT, Linux, Darwin (osx).
## Supported ARCH values are: x86, x86_64, arm (compiler not implemented).
## 
## Make Commands:
## 	make - Builds a debug version for the current OS and ARCH.
## 	make debug - same as above.
## 	make release - Builds a release version for the current OS and ARCH.
##	make package - Creates a Zip archive in the build direction of all compiled
##					executables, data assets, and libraries.
##	make clean - Remove debug and release builds for current OS and ARCH. 
##	make cleanAll - Remove the build directory completely.



BIN 	:= game
VERSION	:= v1.0
DATA	:= data
EXT		:= # Set to '.exe' on Windows.
SRC 	:= $(PWD)/src
BUILDDIR:= $(PWD)/build
LIBDIR	:= lib
SYSTEM	 = $(OS)_$(ARCH)
CC  	:= g++
CCFLAGS	:= -c -std=c++0x -Wall -pedantic `sdl2-config --cflags`
LINKERFLAGS = -fuse-ld=gold -Wl,-Bdynamic,-rpath,\$$ORIGIN/$(LIBDIR)
INCLUDES:= -Iinclude/
LIBS 	 = -L$(LIBDIR)/$(ARCH)/ -lSDL2 -lSDL2_image -lSDL2_ttf #-lGL #box2d #sfml
STATICLIBS := -Wl,-Bstatic -static-libgcc -static-libstdc++
WINLIBS	:= -lmingw32 -lSDL2main #-lwinpthread -mwindows -lwinmm 
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
	DEFINES += -DX86_64
else ifeq ($(ARCH),x86)
	ifeq ($(OS), Windows_NT)
		CC = i686-w64-mingw32-g++
		INCLUDES += -I/usr/i686-w64-mingw32/include/
	endif
	CCFLAGS += -m32
	LINKERFLAGS += -m32
	DEFINES += -DX86
else ifeq ($(ARCH),arm)
	ifeq ($(OS), Windows_NT)
		CC = NEED_MING_ARM_COMPILER
	else
		CC = NEED_ARM_COMPILER
	endif
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

debug: init initDebug $(BUILD_DEBUG)
	$(CC) $(STATICLIBS) $(LINKERFLAGS) $(BUILD_DEBUG) -o $(BUILDDIR)/$(BIN)_$(SYSTEM).debug$(EXT) $(LIBS)
	cp $(BUILDDIR)/$(BIN)_$(SYSTEM).debug$(EXT) $(BIN)$(EXT)

$(BUILD_DEBUG) : $(BUILDDIR)/$(SYSTEM).debug/%.o: $(SRC)/%.cpp
	$(CC) -g $(CCFLAGS) $(DEFINES) $< -o $@ $(INCLUDES)

release: init initRelease $(BUILD_RELEASE)
	$(CC) $(STATICWINLIBS) $(LINKERFLAGS) $(BUILD_RELEASE) -o $(BUILDDIR)/$(BIN)_$(SYSTEM)$(EXT) $(LIBS)

$(BUILD_RELEASE) : $(BUILDDIR)/$(SYSTEM).release/%.o: $(SRC)/%.cpp
	$(CC) $(CCFLAGS) $(DEFINES) $< -o $@ $(INCLUDES)

package:
	mkdir -p $(BUILDDIR)/$(BIN)_$(VERSION)
	cp -a $(DATA) $(BUILDDIR)/$(BIN)_$(VERSION)/
	cp -a $(LIBDIR) $(BUILDDIR)/$(BIN)_$(VERSION)/
	@for binary in $(shell find build/ -maxdepth 1 -type f -printf '%f\n'); do \
		cp $(BUILDDIR)/$$binary $(BUILDDIR)/$(BIN)_$(VERSION)/; \
	done
	-@rm $(BIN)_$(VERSION).zip
	-cd $(BUILDDIR)/ && zip -r ../$(BIN)_$(VERSION).zip $(BIN)_$(VERSION)/; cd ../

init:
	mkdir -p $(LIBDIR)/$(ARCH)/
	
initDebug:
	mkdir -p $(BUILDDIR)/$(SYSTEM).debug

initRelease:
	mkdir -p $(BUILDDIR)/$(SYSTEM).release

clean:
	-@rm -rf $(BUILDDIR)/$(SYSTEM).debug/ > /dev/null 2>&1
	-@rm $(BUILDDIR)/$(BIN)_$(SYSTEM).debug$(EXT) > /dev/null 2>&1
	-@rm -rf $(BUILDDIR)/$(SYSTEM).release/ > /dev/null 2>&1
	-@rm $(BUILDDIR)/$(BIN)_$(SYSTEM)$(EXT) > /dev/null 2>&1
	-@rmdir $(BUILDDIR)/ > /dev/null 2>&1

cleanAll:
	-@rm -r $(BUILDDIR) > /dev/null 2>&1


.PHONY: all
.PHONY: debug
.PHONY: release
.PHONY: package
.PHONY: init
.PHONY: initDebug
.PHONY: initRelease
.PHONY: clean
.PHONY: cleanAll


