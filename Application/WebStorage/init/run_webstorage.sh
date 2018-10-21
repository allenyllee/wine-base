#!/usr/bin/env bash

export WEBSTORGE_PATH="$HOME/.wine/drive_c/Program Files/ASUS/WebStorage"

wine "$WEBSTORGE_PATH/launch.exe"

WAIT=wineserver; echo "Start waiting on $WAIT"; while pgrep -u `whoami` "$WAIT" > /dev/null; do echo "waiting ..." ; sleep 1; done ; echo "$WAIT completed"
