#!/usr/bin/env bash

export WINEARCH=win32
export WINEDLLOVERRIDES="ieframe:native,builtin;winhttp,wininet:builtin,native"

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# WineHQ - .NET Framework 2.0
# https://appdb.winehq.org/objectManager.php?sClass=version&iId=3754
#winetricks dotnet20

# Ubuntu13.04(64bit)下用Wine安装百度云、360云、微云 - tomheaven的专栏 - CSDN博客
# https://blog.csdn.net/hanlin_tan/article/details/40226009
#winetricks wininet


winetricks ie8 vcrun2008 winhttp wininet

wine start ./wine_gecko-2.47-x86.msi

wine start ./wine-mono-4.7.3.msi

wine regedit ./OGL.reg

./set_chinese_for_wine.sh

#playonlinux

#wine installbackupandsync.exe
wine start gsync_enterprise.msi
#wine start google-drive-1-7-4018-3496-gsync.msi
#wine start Google_Drive_v2.34.5075.1619.msi
#wine start Google_Drive_v3.36.6721.3394.msi
#wine Backup_and_Sync_from_Google_3.43.1584.exe
