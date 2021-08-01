#!/bin/bash
version_tag="latest"
build="true"
image_name="ros2_foxy_motion_planning_lib"
container_name="motion_planning_container"
while getopts b:i:c:v: flag
do
    case "${flag}" in
        b) build=${OPTARG};;
        i) image_name=${OPTARG};;
        c) container_name=${OPTARG};;
        v) version_tag=${OPTARG};;
    esac
done
if [ "$build" == "true" ];then
    sh ./prep_host.sh -i $image_name -v $version_tag
else
    sh ./launch.sh -i $image_name -c $container_name -v $version_tag
fi
exit 0