#!/bin/sh

PARAM=${1+"$@"}

SCRIPT_FILE=`basename "$0"`
GGFBN_FILE="ggfbn.exe"
READLINK_PATH=`readlink -f "$0"`
SCRIPT_FOLDER=`dirname ${READLINK_PATH} || pwd`
START_SCRIPT="${SCRIPT_FOLDER}/${SCRIPT_FILE}"
FBA="${SCRIPT_FOLDER}/${GGFBN_FILE}"

if [ ! -x ${FBA} ]; then
    echo "ERROR: Can't find ${GGFBN_FILE}, please put this script in the same folder as the ${GGFBN_FILE} and run this script again."
    exit 1
fi

if [ -x /usr/bin/xdg-mime ]; then
	mkdir -p ~/.local/share/applications/
	echo "[Desktop Entry]
Type=Application
Encoding=UTF-8
Name=Red GGPO Emulator
Exec=${START_SCRIPT} %U
Terminal=false
MimeType=x-scheme-handler/ggpo
" > ~/.local/share/applications/red-ggpo-quark.desktop
    xdg-mime default red-ggpo-quark.desktop x-scheme-handler/ggpo
fi

if [ -x /usr/bin/gconftool-2 ]; then
	gconftool-2 -t string -s /desktop/gnome/url-handlers/ggpo/command "${START_SCRIPT} %s"
	gconftool-2 -t bool -s /desktop/gnome/url-handlers/ggpo/needs_terminal false
	gconftool-2 -t bool -s /desktop/gnome/url-handlers/ggpo/enabled true
fi

wine ${FBA} ${PARAM}