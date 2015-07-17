#!/bin/sh

# Needs to be run within the Project's root directory.

Path=$PWD

exec echo -e -n "[Desktop Entry]\\nName=$$NAME\\nVersion=$$VERSION\\nType=$APP_TYPE\\nEncoding=UTF-8\\nPath=$Path\\nExec=./"'$$FILENAME.sh'"\\nIcon=$$ICON\\nCategories=$$CATEGORIES\\nComment=$$DESCRIPTION\\nStartupNotify=false\\nTerminal=$$RUN_IN_TERMINAL" > $$FILENAME.desktop



