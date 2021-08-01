#!/bin/bash
xhost +local:root
version="latest"
container_name="motion_planner"
while getopts i:c:v: flag
do
    case "${flag}" in
        i) image_name=${OPTARG};;
        c) container_name=${OPTARG};;
        v) version=${OPTARG};;
    esac
done
if docker ps | grep -q $container_name
then 
    echo "Joining existing container session with name = $container_name...."
    nvidia-docker exec -it --privileged $container_name /bin/bash
else
    echo "Launching container with name $container_name for the first time in this session...."
    nvidia-docker run -it \
        --name=$container_name \
        --rm \
        --env="DISPLAY=$DISPLAY" \
        --env="QT_X11_NO_MITSHM=1" \
        --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
        --volume=$HOME/.bash_history:/home/ros/.bash_history \
        --env="XAUTHORITY=$XAUTH" \
        --runtime=nvidia \
        -v$PWD:/workspace \
        --expose 9090 \
        --net host \
        --privileged \
        $image_name:$version \
        /bin/bash
fi
exit 0