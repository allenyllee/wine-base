#!/usr/bin/env bash

export WINEARCH=win32

# source directory of this script
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# base dir of this script to exclude
BASE_DIR="$(basename $SOURCE_DIR)"

"$SOURCE_DIR"/set_chinese_for_wine.sh

# # WineHQ - .NET Framework 2.0
# # https://appdb.winehq.org/objectManager.php?sClass=version&iId=3754
# winetricks -q dotnet20
# wine "$SOURCE_DIR"/ASUSWebStorageSyncAgent2.4.3.612.exe


# WineHQ - .NET Framework 4.0
# https://appdb.winehq.org/objectManager.php?sClass=version&iId=17886
winetricks -q dotnet40

# [SOLVED] Running a game [osu!] in Wine with .Net2.0 / Multimedia and Games / Arch Linux Forums
# https://bbs.archlinux.org/viewtopic.php?id=189137
#
# 0036:fixme:shell:URL_ParseUrl failed to parse L"InstallAction.resources"
#
# installing internet explorer in the same wineprefix solved it for me.
winetricks -q ie8

wine "$SOURCE_DIR"/WebStorageSyncAgent2.5.3.626.exe