#!/usr/bin/env bash

export WEBSTORGE_PATH="$HOME/.wine/drive_c/Program Files/ASUS/WebStorage"
export WEBSTORGE_EXE_PATH=$(find "$WEBSTORGE_PATH" -name AsusWSPanel.exe)

wine "$WEBSTORGE_EXE_PATH"

WAIT=wineserver; echo "Start waiting on $WAIT"; while pgrep -u `whoami` "$WAIT" > /dev/null; do echo "waiting ..." ; sleep 1; done ; echo "$WAIT completed"
