#!/bin/sh

Name="Game"
FileName="game"
Version=.1
Type=Application
Encoding=UTF-8
Path=$PWD
Exec=./"'$FileName.sh'"
Icon=$Path/icon.png
Categories="Game;ActionGame;"
Comment=""
StartupNotify=false
Terminal=false

exec echo -e -n "[Desktop Entry]\\nName=$Name\\nVersion=$Version\\nType=$Type\\nEncoding=$Encoding\\nPath=$Path\\nExec=$Exec\\nIcon=$Icon\\nCategories=$Categories\\nComment=$Comment\\nStartupNotify=$StartupNotify\\nTerminal=$Terminal" > $FileName.desktop



