#!/usr/bin/env bash

# source directory of this script
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# base dir of this script to exclude
BASE_DIR="$(basename $SOURCE_DIR)"

# Chinese fonts are not visible in programs installed in Wine - Ask Ubuntu
# https://askubuntu.com/questions/1019530/chinese-fonts-are-not-visible-in-programs-installed-in-wine

# copy chinese font to windows/Fonts
cp "$SOURCE_DIR"/chinese_support/wqy-microhei.ttc ~/.wine/drive_c/windows/Fonts/

# add registry key
wine regedit "$SOURCE_DIR"/chinese_support/chn_fonts.reg
