## 
## Cross-Platform Makefile for Mac/Linux.
## MIT Licensed. Created by Dan H4tch.
## 
## Supported OS values are: Windows_NT, Windows, Linux, and Darwin (osx).
## Supported ARCH values are: x86, x86_64, arm (compiler not implemented).
## 	Note: These will be automatically determined if not set.
## 
## Make Commands:
## 	make - Builds a debug version for the current OS and ARCH.
## 	make debug - same as above.
## 	make release - Builds a release version for the current OS and ARCH.
##	make package - Creates a Zip archive in the build direction of all compiled
##					executables, data assets, and libraries.
##					Note: Removes debug build files.
##	make clean - Remove debug and release builds for current OS and ARCH. 
##	make cleanDebug - Remove debug build files.
##	make cleanAll - Remove the build directory completely.
## 

 
## TODO:
##	Metadata for built packages.
##	Look into NSIS for a Windows installer. 
##	Add optimization options to compiler for "release" builds.
##	Android build chain.
##	Make BUILDDIR configurable.
##	Change OS and ARCH to produce more "friendly" named files?
##		Something like this: game_Linux_32, game_Windows_64, game_Mac_32
## 		Arm would be "_arm32" and "_arm64", not counting the different ABIs.
##	More Platforms: x64, ia32, etc?
##	Basic Test suite.
##		`make test`
##		`make testrun`
##	ERROR out if ARCH is invalid. For OS, default to Linux? Add Unix?
## 	Make the Zip file(s) a target. Each platform has a zip target.
##		The zip needs build/$(SYSTEM).release as a dependency. 
##	Move compile Linux binary to bin/lb folder.


NAME	:= ConnectFour
BIN 	:= game
VERSION	:= v1.0
DATA	:= data
EXT		:= # Set to '.exe' on Windows. I might set to '.bin' for Unixes.
SRC 	:= src
BUILDDIR:= build
LIBDIR	:= lib
SYSTEM	 = $(OS)_$(ARCH)
CC  	:= g++
CCFLAGS	:= -c -std=c++0x -Wall -pedantic `sdl2-config --cflags`
LDFLAGS	= -fuse-ld=gold -Wl,-Bdynamic,-rpath,\$$ORIGIN/$(LIBDIR)/$(SYSTEM)
INCLUDES:= -Iinclude/
LIBS 	 = -L$(LIBDIR)/$(SYSTEM)/ -lSDL2 -lSDL2_image -lSDL2_ttf #-lGL -lbox2d
STATICLIBS := -static-libstdc++ -static-libgcc -Wl,-Bstatic
WINLIBS	:= -lmingw32 -lSDL2main #-lwinpthread -mwindows -lwinmm 
STATICWINLIBS :=  
DEFINES	:= -DDATE='"'$$DATE'"'


#OSS 	= "Linux Mac Windows"
#ARCHS	= "arm x86 x86_64"
 

#### BEGIN SECTION FOR DETECTING AND FIXING UP ARCH ####
# NOTE: WINDOWS ARCH VALUES CAN BE: AMD64 IA64 x86
# If we are on Linux cross-compiling to Windows, use Unix tools to find ARCH.
ifeq ($(ARCH),)
	ifeq ($(PROCESSOR_ARCHITECTURE),)
		ARCH := $(shell uname -p)
	else
		ARCH := PROCESSOR_ARCHITECTURE
	endif
endif

# Better architecture detection on Windows.
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
ifeq ($(OS),)
	OS := $(shell uname -s)
endif

ifeq ($(OS),Windows_NT)
	OS := Windows
endif

ifeq ($(OS),Windows)
	EXT 	:= .exe
	LIBS 	:= $(WINLIBS) $(LIBS)
	DEFINES	+= -DWIN32
else ifeq ($(OS),Linux)
	DEFINES	+= -DLINUX
else ifeq ($(OS), Darwin)
	DEFINES	+= -DOSX
endif

ifeq ($(ARCH),x86_64)
	BITS = 64
	ifeq ($(OS), Windows)
		CC = x86_64-w64-mingw32-g++
		INCLUDES += -I/usr/x86_64-w64-mingw32/include/
		STATICLIBS += $(STATICWINLIBS)
	endif
	DEFINES += -DX86_64
else ifeq ($(ARCH),x86)
	BITS = 32
	ifeq ($(OS), Windows)
		CC = i686-w64-mingw32-g++
		INCLUDES += -I/usr/i686-w64-mingw32/include/
	endif
	CCFLAGS += -m32
	LDFLAGS += -m32
	DEFINES += -DX86
else ifeq ($(ARCH),arm)
	BITS = 32
	ifeq ($(OS), Windows)
		CC = NEED_MING_ARM_COMPILER
	else
		CC = NEED_ARM_COMPILER
	endif
	DEFINES += -DARM
endif
#### DONE SETTING UP VARIABLES AND COMPILER FLAGS ####



SOURCES	:=	 				\
	$(SRC)/main.cpp 		\
	$(SRC)/Game.cpp			\
	$(SRC)/Board.cpp		

OBJECTS	:= $(SOURCES:.cpp=.o)

BUILD_DEBUG	:= $(patsubst $(SRC)/%,$(BUILDDIR)/$(SYSTEM).debug/%,$(OBJECTS))
BUILD_RELEASE:= $(patsubst $(SRC)/%,$(BUILDDIR)/$(SYSTEM).release/%,$(OBJECTS))



all: debug


debug: init initDebug $(BUILD_DEBUG)
	$(CC) -g $(STATICLIBS) $(LDFLAGS) $(BUILD_DEBUG) \
		-o $(BUILDDIR)/$(BIN)_$(SYSTEM).debug$(EXT) $(LIBS)
	cp $(BUILDDIR)/$(BIN)_$(SYSTEM).debug$(EXT) $(BIN)$(EXT)


$(BUILD_DEBUG) : $(BUILDDIR)/$(SYSTEM).debug/%.o: $(SRC)/%.cpp
	$(CC) -g $(CCFLAGS) -DDEBUG $(DEFINES) $< -o $@ $(INCLUDES)


release: init initRelease $(BUILD_RELEASE)
	$(CC) $(STATICLIBS) $(LDFLAGS) $(BUILD_RELEASE) \
		-o $(BUILDDIR)/$(BIN)_$(SYSTEM)$(EXT) $(LIBS)
	cp $(BUILDDIR)/$(BIN)_$(SYSTEM)$(EXT) $(BIN)$(EXT)


$(BUILD_RELEASE) : $(BUILDDIR)/$(SYSTEM).release/%.o: $(SRC)/%.cpp
	$(CC) $(CCFLAGS) -DNDEBUG $(DEFINES) $< -o $@ $(INCLUDES)


PACKAGEDIR := $(BUILDDIR)/$(NAME)_$(VERSION)
package: cleanDebug
	mkdir -p $(PACKAGEDIR)/$(LIBDIR)/
	cp -a $(DATA) $(PACKAGEDIR)/
	cp -a $(LIBDIR)/* $(PACKAGEDIR)/$(LIBDIR)/
	# For each compiled binary, copy it into the package.
	@for binary in $(shell find $(BUILDDIR) -maxdepth 1 -type f -printf '%f\n'); do \
		echo $$binary | grep Windows; \
		# If it is a Windows binary, copy it into the Windows bin folder. \
		if [ $$? -eq 0 ]; then \
			# Strip the bin name, extension, and build path from the binary. \
			export DEST=`echo $$binary | sed s/$(BIN)_//g | sed s/.exe//g`; \
			cp $(BUILDDIR)/$$binary $(PACKAGEDIR)/$(LIBDIR)/$$DEST/$(BIN).exe; \
			cp tools/LaunchOnWindows.bat $(PACKAGEDIR)/$(BIN).bat; \
		else \
			cp $(BUILDDIR)/$$binary $(PACKAGEDIR)/; \
			cp tools/LaunchOnLinux.sh $(PACKAGEDIR)/$(BIN).sh; \
		fi; \
	done
	-@rm $(NAME)_$(VERSION).zip
	-cd $(BUILDDIR)/ && \
	zip -r ../$(NAME)_$(VERSION).zip $(NAME)_$(VERSION)/;	


init:
	#mkdir -p $(LIBDIR)/$(SYSTEM)/


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


cleanDebug:
	-@rm -rf $(BUILDDIR)/*.debug
	-@rm $(BUILDDIR)/*.debug*


cleanAll:
	-@rm -r $(BUILDDIR) > /dev/null 2>&1



.PHONY: all
.PHONY: debug
.PHONY: release
.PHONY: package
.PHONY: packageLinux
.PHONY: packageWindows
.PHONY: init
.PHONY: initDebug
.PHONY: initRelease
.PHONY: clean
.PHONY: cleanDebug
.PHONY: cleanAll

