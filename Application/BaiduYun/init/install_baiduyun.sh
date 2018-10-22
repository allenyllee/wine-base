#!/usr/bin/env bash

export WINEARCH=win32

# WineHQ - .NET Framework 2.0
# https://appdb.winehq.org/objectManager.php?sClass=version&iId=3754
winetricks dotnet20

# Ubuntu13.04(64bit)下用Wine安装百度云、360云、微云 - tomheaven的专栏 - CSDN博客
# https://blog.csdn.net/hanlin_tan/article/details/40226009
winetricks wininet


./set_chinese_for_wine.sh

wine BaiduYun_3.9.6.exe

