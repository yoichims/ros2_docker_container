ARG ROS2_DISTRO
FROM ros:${ROS2_DISTRO}-ros-core

ENV DEBIAN_FRONTEND=noninteractive

ARG APT_MIRROR="us"
RUN sed --in-place --regexp-extended "s|(//)(archive\.ubuntu)|\1${APT_MIRROR}.\2|" /etc/apt/sources.list

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    bash-completion \
    build-essential \
    locate \
    nano \
    python3-colcon-common-extensions \
    python3-pip \
    python3-rosdep \
    sudo \
  && python3 -m pip install pydocstyle==6.1.1 \
  && rosdep init \
  && apt-get install -y --no-install-recommends \
    libeigen3-dev \
    libpcl-dev \
    libyaml-cpp-dev \
    ros-${ROS_DISTRO}-diagnostic-updater \
    ros-${ROS_DISTRO}-nav2-amcl \
    ros-${ROS_DISTRO}-nav2-lifecycle-manager \
    ros-${ROS_DISTRO}-nav2-map-server \
    ros-${ROS_DISTRO}-nav2-rviz-plugins \
    ros-${ROS_DISTRO}-pcl-conversions \
    ros-${ROS_DISTRO}-pcl-msgs \
    ros-${ROS_DISTRO}-rqt-image-view \
    ros-${ROS_DISTRO}-rviz2 \
    ros-${ROS_DISTRO}-tf2 \
    ros-${ROS_DISTRO}-tf2-geometry-msgs \
    ros-${ROS_DISTRO}-tf2-sensor-msgs \
    ros-${ROS_DISTRO}-v4l2-camera \
  && rm -rf /var/lib/apt/lists/*

ARG USER_ID
ARG GROUP_ID
RUN addgroup --gid ${GROUP_ID} user \
  && adduser --disabled-password --gecos '' --uid ${USER_ID} --gid ${GROUP_ID} user \
  && usermod -a -G sudo,video user \
  && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER user
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /home/user/.bashrc \
  && echo "source /home/user/ws/install/setup.bash" >> /home/user/.bashrc

WORKDIR /home/user/ws
