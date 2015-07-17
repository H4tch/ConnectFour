#!/bin/sh

# TODO

# Setup project structure.
#	Use the project's name as the 'src' directory?
# 	doc
#	lib
#	data
# Replace scripts with correct values. Can this be included within a single file?
# Fix LaunchOnWindows.bat and LaunchOnLinux.sh to point to correct lib dir.
# Copy over Scripts.
# Setup Makefile with correct values.
# Setup Doxygen with corrent values.
# Generate NSIS file.

. ./Project.sh

SCRIPT_FILES=""


Replace()
{
	if [ $# -lt 2 ]; then
		exit 1
	fi
}


GenerateDoxygenFile()
{
	Replace "\$\$NAME" $NAME
	Replace "\$\$VERSION" $VERSION
	Replace "\$\$DESCRIPTION" $DESCRIPTION
	Replace "\$\$ICON" $ICON
}




