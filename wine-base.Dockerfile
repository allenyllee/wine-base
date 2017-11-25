# wine_X_docker
#
# VERSION               0.0.1

FROM        ubuntu:16.04
LABEL       maintainer="allen7575@gmail.com"

##
## Ubuntu - Packages - Search
## https://packages.ubuntu.com/search?suite=xenial&section=all&arch=amd64&searchon=contents&keywords=Search
##

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
# install vim
##########
RUN apt install -y vim


##############################
#########################
## nvidia-docker
#########################
##############################

####################
# nvidia-docker links
####################
# Image inspection · NVIDIA/nvidia-docker Wiki
# https://github.com/NVIDIA/nvidia-docker/wiki/Image-inspection#nvidia-docker
# when nvidia-docker run is used, we inspect the image specified on the command-line. In this image,
# we lookup the presence and the value of the label com.nvidia.volumes.needed

# if you are using nvidia driver, you need to add this to avoid
# libGL error: failed to load driver: swrast
LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV PATH /usr/local/nvidia/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

# set PATH & LD_LIBRARY_PATH env variable for ssh login session
# Env variable cannot be passed to container - General Discussions - Docker Forums
# https://forums.docker.com/t/env-variable-cannot-be-passed-to-container/5298/6
RUN echo 'export PATH=/usr/local/nvidia/bin:$PATH' >> /etc/profile.d/nvidia.sh && \
    echo 'export LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64:$LD_LIBRARY_PATH' >> /etc/profile.d/nvidia.sh


#######################################################
# #####################################################
# #####################################################
# Install Line
# #####################################################
# #####################################################
# 
# repository - How can I get apt to use a mirror close to me, or choose a faster mirror? - Ask Ubuntu 
# https://askubuntu.com/questions/37753/how-can-i-get-apt-to-use-a-mirror-close-to-me-or-choose-a-faster-mirror
# 
# apt - Trouble downloading packages list due to a "Hash sum mismatch" error - Ask Ubuntu
# https://askubuntu.com/questions/41605/trouble-downloading-packages-list-due-to-a-hash-sum-mismatch-error
# 
# Because there is trouble in download due to "Hash sum mismatch" with default mirror, change to other mirror
# 
RUN sed -i 's|archive.ubuntu.com|tw.archive.ubuntu.com|' /etc/apt/sources.list


#
# How to Install Wine 2.0 Stable in Ubuntu 16.04, 14.04, 16.10 | UbuntuHandbook 
# http://ubuntuhandbook.org/index.php/2017/01/install-wine-2-0-ubuntu-16-04-14-04-16-10/
# 
# Do following command before adding the PPA:
# 
RUN apt update && \
    apt-get install -y software-properties-common

#
# adding Ricotz’s PPA:
# For 64-bit system, enable 32-bit architecture (if you haven’t already) via 
# sudo dpkg --add-architecture i386
# 
# wine not initializing opengl - FedoraForum.org
# https://forums.fedoraforum.org/showthread.php?t=231666
# 
# err:wgl:X11DRV_WineGL_InitOpenglInfo couldn't initialize OpenGL, expect problems
# 
# This was because Wine is 32 bit and requires 32 bit OGL library (duh!)
# 
RUN add-apt-repository -y ppa:ricotz/unstable && \
    dpkg --add-architecture i386 && \
    apt update && \
    apt install -y wine-stable

# add user wineXdocker
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
RUN useradd -m wineXdocker -s /bin/bash

# change password with username:password
RUN echo wineXdocker:wineXdocker | chpasswd
RUN echo root:root | chpasswd

# install sudo and make user wineXdocker as sudoer
RUN apt update && apt-get install -y sudo
RUN echo "wineXdocker       ALL=(ALL)          NOPASSWD: ALL" >> /etc/sudoers

RUN apt update && apt-get install -y wget && \
    apt-get install -y xvfb

#
# WineHQ Forums • View topic - Error at launching game 
# https://forum.winehq.org/viewtopic.php?t=16162
# Ierr:winediag:SECUR32_initNTLMSP ntlm_auth was not found or is outdated. Make sure that ntlm_auth >= 3.0.25 is in your path. Usually, you can find it in the winbind package of your distribution.
# 
# Do what it says; install winbind. If you're not sure which package to install, ask your distro.
# 
RUN apt update && apt-get install -y winbind

# 
# install glxgears
# How to Check 3D Acceleration (FPS) in Ubuntu/Linux Mint 
# http://www.upubuntu.com/2013/11/how-to-check-3d-acceleration-fps-in.html
# 
# use following command to check
# export LIBGL_DEBUG=verbose && glxgears
# 
# How can i deal with 'libGL error: failed to load driver: swrast.' · Issue #509 · openai/gym
# https://github.com/openai/gym/issues/509
# 
# Based on the dockerfile of nvidia/cuda, I can solve this problem.
# https://gitlab.com/nvidia/cuda/blob/ubuntu16.04/8.0/runtime/Dockerfile
# 
# Or you can just use it with nvidia-docker to create another container run all the stuff without touching your OS environments.
# 
RUN apt update && apt-get install -y mesa-utils

# 
# Wineskin: play your favorite Windows games on Mac OS X without needing Microsoft Windows | Swords and Sandals: Crusader problems 
# http://wineskin.urgesoftware.com/tiki-view_forum_thread.php?comments_parentId=3675
# 
# _XSERVTransmkdir: ERROR: euid != 0,directory /tmp/.X11-unix will not be created. 
# 
# 1. mkdir /tmp/.X11-unix (make a directory)
# 2. sudo chmod a+rwx /tmp/.X11-unix (give it all rights) 
# 
RUN mkdir /tmp/.X11-unix && \
    chmod 1777 /tmp/.X11-unix


# change user
USER wineXdocker

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
RUN Xvfb :99 & export DISPLAY=:99 && \
    wine "/home/`whoami`/LineInst.exe" /s || : && \
    WAIT=wineserver; echo "Start waiting on $WAIT"; while pgrep -u `whoami` "$WAIT" > /dev/null; do echo "waiting ..." ; sleep 1; done ; echo "$WAIT completed"

#
# unix - How to set bash aliases for docker containers in Dockerfile? - Stack Overflow 
# https://stackoverflow.com/questions/36388465/how-to-set-bash-aliases-for-docker-containers-in-dockerfile
# 
# For non-interactive shells you should create a small script and put it in your path, i.e.:
# RUN echo -e '#!/bin/bash\necho hello' > /usr/bin/hi && \
# chmod +x /usr/bin/hi
# 
RUN echo "#!/bin/bash\nexport LINE_PATH=$HOME/.wine/drive_c/users/wineXdocker/Local\ Settings/Application\ Data/LINE/bin\nwine \"\$LINE_PATH\"/LineLauncher.exe\nWAIT=wineserver; echo \"Start waiting on \$WAIT\"; while pgrep -u `whoami` \"\$WAIT\" > /dev/null; do echo \"waiting ...\" ; sleep 1; done ; echo \"\$WAIT completed\"" | sudo tee -a /usr/bin/Line && \
    sudo chmod +x /usr/bin/Line


EXPOSE 22

#ENTRYPOINT [ "/usr/sbin/sshd", "-d"]
CMD    ["bash"]

