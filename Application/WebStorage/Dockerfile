# webstorage-wine
#
# VERSION               0.0.1

FROM        allenyllee/wine-base
LABEL       maintainer="allen7575@gmail.com"



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