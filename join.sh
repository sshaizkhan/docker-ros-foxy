#!/bin/bash
xhost +local:root
nvidia-docker exec -it ros_container /bin/bash --init-file './ros_entrypoint.sh'