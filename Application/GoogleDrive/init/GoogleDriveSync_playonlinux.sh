#!/bin/bash
# Date: 2016-1-9
# Author: MTres19
# Wine version used: 1.8
# Distribution used to test: Kubuntu 15.10 (amd64)
 
[ "$PLAYONLINUX" = "" ] && exit 0
source "$PLAYONLINUX/lib/sources"
 
TITLE="Google Drive Sync"
PREFIX="GoogleDriveSync"
WINEVERSION="3.0.3"
 
POL_SetupWindow_Init
POL_Debug_Init
 
POL_SetupWindow_presentation "$TITLE" "Google, Inc." "www.google.com" "MTres19" "$PREFIX"
 
POL_System_SetArch "x86"
POL_Wine_SelectPrefix "$PREFIX"
POL_Wine_PrefixCreate "$WINEVERSION"
 
POL_System_TmpCreate "$PREFIX"
cd "$POL_System_TmpDir"
 
POL_Call POL_Install_LunaTheme
# IE 8 required to be able to authenticate
POL_Call POL_Install_ie8
 
POL_Download "https://dl.google.com/drive/gsync_enterprise.msi"
POL_Wine start msiexec /i "gsync_enterprise.msi"
 
# The MSI installer automatically starts GoogleUpdate.exe, making a synchronous POL_Wine command impossible.
POL_SetupWindow_wait "$(eval_gettext 'Waiting for installation to finish')" "$TITLE"
sleep 10
 
POL_SetupWindow_message "$(eval_gettext 'The Google Drive systray icon will disappear the first time you run it, though the sync will continue in the background. Close and restart Google Drive Sync in the PlayOnLinux/PlayOnMac window to make the icon appear.')" "$TITLE"
 
POL_Shortcut "googledrivesync.exe" "$TITLE"
 
POL_System_TmpDelete
POL_SetupWindow_Close
exit 0