#!/usr/bin/env bash

# Chinese fonts are not visible in programs installed in Wine - Ask Ubuntu
# https://askubuntu.com/questions/1019530/chinese-fonts-are-not-visible-in-programs-installed-in-wine

# copy chinese font to windows/Fonts
cp ./chinese_support/wqy-microhei.ttc ~/.wine/drive_c/windows/Fonts/

# add registry key
wine regedit ./chinese_support/chn_fonts.reg
