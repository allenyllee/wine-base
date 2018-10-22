#!/usr/bin/env bash

export BAIDUYUN_PATH="$HOME/.wine/drive_c/Program Files/baidu/BaiduYun"

wine "$BAIDUYUN_PATH/baiduyun.exe"

WAIT=wineserver; echo "Start waiting on $WAIT"; while pgrep -u `whoami` "$WAIT" > /dev/null; do echo "waiting ..." ; sleep 1; done ; echo "$WAIT completed"
