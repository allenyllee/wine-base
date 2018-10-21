#!/usr/bin/env bash

export WINEARCH=win32

# WineHQ - .NET Framework 2.0
# https://appdb.winehq.org/objectManager.php?sClass=version&iId=3754
winetricks dotnet20

wine ASUSWebStorageSyncAgent2.4.3.612.exe

