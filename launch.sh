#!/bin/bash
sudo docker run -it \
    --name="ros_container" \
    --rm \
    --env="DISPLAY=192.168.86.32:0" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume=$HOME/.bash_history:/home/ros/.bash_history \
    --env="XAUTHORITY=$XAUTH" \
    -v$PWD:/workspace \
    --expose 9090 \
    --net host \
    --privileged \
	shah/ros2:1.0 \
	/bin/bash
