#!/usr/bin/env bash

export GOOGLEDRIVE_PATH="$HOME/.wine/drive_c/Program Files/Google/Drive"
export WINEDLLOVERRIDES="ieframe:native,builtin;winhttp,wininet:builtin,native"

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

wine "$GOOGLEDRIVE_PATH/googledrivesync.exe"

WAIT=wineserver; echo "Start waiting on $WAIT"; while pgrep -u `whoami` "$WAIT" > /dev/null; do echo "waiting ..." ; sleep 1; done ; echo "$WAIT completed"
