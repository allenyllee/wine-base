# line-wine
#
# VERSION               0.0.1

FROM        allenyllee/wine-base:test
LABEL       maintainer="allen7575@gmail.com"

############
# update package list
############
RUN apt update

##############################
#########################
## Tools
#########################
##############################

##########
# install wget
##########
# in order to download LineInst.exe
RUN apt install -y wget

##########
# install xvfb
##########
# in order to initialize wine headless in docker build time
RUN apt install -y xvfb

##############################
#########################
## install LINE
#########################
##############################

# add user LINEer
# useradd - Ubuntu 14.04: New user created from command line has missing features - Ask Ubuntu
# https://askubuntu.com/questions/643411/ubuntu-14-04-new-user-created-from-command-line-has-missing-features
#
# You should run the command in the following manner:
# sudo useradd -m sam -s /bin/bash
#
#  -s, --shell SHELL
#       The name of the user's login shell.
#  -m, --create-home
#       Create the user's home directory if it does not exist.
#
RUN useradd -m LINEer -s /bin/bash

# change password with username:password
RUN echo LINEer:LINEer | chpasswd

# install sudo and make user LINEer as sudoer
#RUN apt-get install -y sudo && \
#    echo "LINEer       ALL=(ALL)          NOPASSWD: ALL" >> /etc/sudoers


# change user
USER LINEer

#
# download Line installer
# you can see the script on:
# Chocolatey Gallery | LINE 3.8.0.1350
# https://chocolatey.org/packages/line
#
# WineHQ - LINE (Powered by Naver)
# https://appdb.winehq.org/objectManager.php?sClass=application&iId=13986
#
RUN cd ~ && \
    wget http://dl.desktop.line.naver.jp/naver/LINE/win/LineInst.exe

#
# Generate wine settings, waiting for wineserver to finish
# https://github.com/gpavlidi/dockerfiles/blob/5272e34005c3aa4fe2c6a1c68a70e63e1f22b4e0/wine/Dockerfile#L56
#
#RUN xvfb-run wine "wineboot" && while pgrep -u `whoami` wineserver > /dev/null; do sleep 1; done

# Container from Dockerfile different than manually created · Issue #12795 · moby/moby
# https://github.com/moby/moby/issues/12795#issuecomment-97491100
#
# Finally found a way how to wait. Basically I'm waiting on the core process wineserver to be terminated by this script:
#
# #!/bin/sh
# #
# # inspired by http://stackoverflow.com/a/10407912
# #
# echo "Start waiting on $@"
# while pgrep -u xclient "$@" > /dev/null; do
#         echo "waiting ..."
#         sleep 1;
# done
# echo "$@ completed"
#
# Also inspired by:
# docker-compassxport/Dockerfile at master · phnmnl/docker-compassxport
# https://github.com/phnmnl/docker-compassxport/blob/master/Dockerfile#L57
#
# Run line installer silently
#
# shell - Bash executing multiple commands in background in same line - Stack Overflow
# https://stackoverflow.com/questions/22298199/bash-executing-multiple-commands-in-background-in-same-line
#
# You can see there that & isn't just something that runs a command in the background,
# it's actually a separator as well. Hence, you don't need a semicolon following it.
# In fact, it's actually invalid to try that, just the same as if you put two semicolons
# in sequence, the actual problem being that bash does not permit empty commands
#

# RUN Xvfb :99 & export DISPLAY=:99 && \
#     wineserver -d2 -f  || : && \
#     WAIT=wineserver; echo "Start waiting on $WAIT"; while pgrep -u `whoami` "$WAIT" > /dev/null; do echo "waiting ..." ; sleep 1; done ; echo "$WAIT completed"


RUN Xvfb :99 & export DISPLAY=:99 && \
    wine "/home/`whoami`/LineInst.exe" /s || : && \
    WAIT=wineserver; echo "Start waiting on $WAIT"; while pgrep -u `whoami` "$WAIT" > /dev/null; do echo "waiting ..." ; sleep 1; done ; echo "$WAIT completed"


# change user
USER root

#
# unix - How to set bash aliases for docker containers in Dockerfile? - Stack Overflow
# https://stackoverflow.com/questions/36388465/how-to-set-bash-aliases-for-docker-containers-in-dockerfile
#
# For non-interactive shells you should create a small script and put it in your path, i.e.:
# RUN echo -e '#!/bin/bash\necho hello' > /usr/bin/hi && \
# chmod +x /usr/bin/hi
#
RUN echo "#!/bin/bash\nexport LINE_PATH=\$HOME/.wine/drive_c/users/LINEer/Local\ Settings/Application\ Data/LINE/bin\nwine \"\$LINE_PATH\"/LineLauncher.exe\nWAIT=wineserver; echo \"Start waiting on \$WAIT\"; while pgrep -u \`whoami\` \"\$WAIT\" > /dev/null; do echo \"waiting ...\" ; sleep 1; done ; echo \"\$WAIT completed\"" | tee -a /usr/bin/Line && \
    chmod +x /usr/bin/Line

##############
# upgrade
##############
RUN apt upgrade -y

##############
# cleanup
##############
# debian - clear apt-get list - Unix & Linux Stack Exchange
# https://unix.stackexchange.com/questions/217369/clear-apt-get-list
#
# bash - autoremove option doesn't work with apt alias - Ask Ubuntu
# https://askubuntu.com/questions/573624/autoremove-option-doesnt-work-with-apt-alias
#
RUN apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


CMD    ["bash"]