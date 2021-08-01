# Using base image from nvidia/cudagl
FROM nvidia/cudagl:11.4.0-devel-ubuntu20.04

# Setting up packages for devops
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --allow-unauthenticated \
lsb-release \
net-tools \
iputils-ping \
apt-utils \
build-essential \
psmisc \
vim-gtk \
mongodb \
scons \
bison \
flex \
git \
sudo \
keyboard-configuration \
 && rm -rf /var/lib/apt/lists/*

ENV USERNAME bot
RUN adduser --ingroup sudo --disabled-password --gecos "" --shell /bin/bash --home /home/$USERNAME $USERNAME
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN bash -c 'echo $USERNAME:bot | chpasswd'
ENV HOME /home/$USERNAME
USER $USERNAME

#Setting up the locales
RUN sudo apt-get update && sudo apt-get install locales
RUN sudo locale-gen en_US en_US.UTF-8
RUN sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
RUN export LANG=en_US.UTF-8

RUN sudo apt-get update && sudo apt-get install -y curl gnupg2 lsb-release
RUN sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

#Installing ROS2
RUN sudo apt-get update
RUN sudo apt-get update && DEBIAN_FRONTEND=noninteractive sudo apt-get install -y ros-foxy-desktop

#Installing Gazebo 11
RUN sudo apt-get install -y ros-foxy-gazebo-ros-pkgs 
RUN sudo apt-get install -y ros-foxy-ros-core ros-foxy-geometry2 

#Installing colcon for ROS2
RUN sudo sh -c 'echo "deb [arch=amd64,arm64] http://repo.ros2.org/ubuntu/main `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -

RUN sudo apt-get update
RUN sudo apt-get install -y python3-colcon-common-extensions

#Setting up source
RUN echo "source /opt/ros/foxy/setup.bash" >> /home/bot/.bashrc

COPY ros_entrypoint.sh /bin/rossrc

ENTRYPOINT [ "rossrc" ]