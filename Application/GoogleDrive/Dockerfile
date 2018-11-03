# baiduyun-wine
#
# VERSION               0.0.1

FROM        allenyllee/wine-base
LABEL       maintainer="allen7575@gmail.com"


# inorder to extract wininet package
RUN apt-get install -y cabextract

RUN apt-get install -y playonlinux

#ENV PLAYONLINUX "/usr/share/playonlinux"

# change password with username:password
RUN echo root:root | chpasswd

# add guest user
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
RUN useradd -m guest -s /bin/bash && \
    echo guest:guest | chpasswd 

# grant access for guest to video device
RUN usermod -a -G video guest `# grant access to video device`

USER guest 
ENV HOME /home/guest 
ENV USER guest 

COPY ./init /init

##############
# cleanup
##############
# debian - clear apt-get list - Unix & Linux Stack Exchange
# https://unix.stackexchange.com/questions/217369/clear-apt-get-list
#
# bash - autoremove option doesn't work with apt alias - Ask Ubuntu
# https://askubuntu.com/questions/573624/autoremove-option-doesnt-work-with-apt-alias
#
# RUN apt-get autoremove && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*


CMD    ["bash"]