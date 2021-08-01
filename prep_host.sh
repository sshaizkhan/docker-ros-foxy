#!/bin/bash
version="latest"
while getopts i:v: flag
do
    case "${flag}" in
        i) image_name=${OPTARG};;
        v) version=${OPTARG};;
    esac
done
# Installing nvidia-docker toolkit
echo "Installing nvidia-docker2 for NVIDIA cuda support..."
sudo apt-get update 
sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker

#Installing Ubuntu 20 and setting up ros2 foxy
ROS_WS_ROOT="ros_ws"
WS="/workspace"
WS_PATH="$WS/$ROS_WS_ROOT"
echo "Building the image with image name: $image_name and tag name:$version........."
docker build --rm -t $image_name:$version .
exit 0
# docker run --rm -e "WS=$WS" -e "WS_PATH=$WS_PATH" -v$PWD:/workspace/ -it  $image_name:$version