#/bin/bash

CONTAINER_NAME="wine"
IMAGE="allenyllee/wine-base:test"


XSOCK=/tmp/.X11-unix
XAUTH_DIR=/tmp/.docker.xauth
XAUTH=$XAUTH_DIR/.xauth

# # 1. Use tr to swap the newline character to NUL character.
# #       NUL (\000 or \x00) is nice because it doesn't need UTF-8 support and it's not likely to be used.
# # 2. Use sed to match the string
# # 3. Use tr to swap back.
# # 4. insert a string into /etc/rc.local before exit 0
# tr '\n' '\000' < /etc/rc.local | sudo tee /etc/rc.local >/dev/null
# sudo sed -i 's|\x00XAUTH_DIR=.*\x00\x00|\x00|' /etc/rc.local >/dev/null
# tr '\000' '\n' < /etc/rc.local | sudo tee /etc/rc.local >/dev/null
# sudo sed -i 's|^exit 0.*$|XAUTH_DIR=/tmp/.docker.xauth; rm -rf $XAUTH_DIR; install -m 777 -d $XAUTH_DIR\n\nexit 0|' /etc/rc.local

# # create a folder with mod 777 that can allow all other user read/write
# XAUTH_DIR=/tmp/.docker.xauth; sudo rm -rf $XAUTH_DIR; install -m 777 -d $XAUTH_DIR

# # append string in ~/.profile
# tr '\n' '\000' < ~/.profile | sudo tee ~/.profile >/dev/null
# sed -i 's|\x00XAUTH_DIR=.*-\x00|\x00|' ~/.profile
# tr '\000' '\n' < ~/.profile | sudo tee ~/.profile >/dev/null
# echo "XAUTH_DIR=/tmp/.docker.xauth; XAUTH=\$XAUTH_DIR/.xauth; touch \$XAUTH; xauth nlist \$DISPLAY | sed -e 's/^..../ffff/' | xauth -f \$XAUTH nmerge -" >> ~/.profile
# source ~/.profile

# remove previous container
nvidia-docker stop $CONTAINER_NAME && \
nvidia-docker rm $CONTAINER_NAME

# pull latest image
nvidia-docker pull $IMAGE

# run new container
nvidia-docker run -ti --rm \
    --user root \
    --name $CONTAINER_NAME \
    --env DISPLAY=$DISPLAY \
    --env XAUTHORITY=$XAUTH \
    --volume $XSOCK:$XSOCK \
    --volume /home/allenyllee/Projects/server_setup/Dockerfile/wine-base/Application/WebStorage:/root/WebStorage \
    --volume /home/allenyllee/Projects_SSD/docker-srv/WebStorageConfig/.wine:/root/.wine \
    --volume /home/allenyllee/Projects/ResilioSyncFolder/Cloud/WebStorage:/WebStorage \
    --volume $XAUTH_DIR:$XAUTH_DIR \
    `#--device /dev/video0:/dev/video0 # for webcam` \
    --entrypoint /bin/bash \
    $IMAGE \
    -c "bash"
