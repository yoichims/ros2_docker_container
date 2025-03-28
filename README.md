# ros2_docker_env

![ci status](https://github.com/f-fl0/ros2_docker_env/workflows/ci/badge.svg)

A simple docker environment to test stuff with ros2 (default `iron`). The workspace is mounted inside the container with
read/write/execution permission for your user so you can edit files on the host and compile/run inside the container.
You can install libraries from inside the container using `apt-get` or `pip`. You might need to run `sudo apt-get update`
the first time. Add dependencies/libraries to the Dockerfile as you need them and build a new image.

## Setup

* Install docker following the instructions from <https://docs.docker.com/engine/install>
and <https://docs.docker.com/engine/install/linux-postinstall> to be able to use docker as a normal user.

* Build the image

```bash
make
```

Build options can be added by specifying `DOCKER_BUILD_OPTS`.

```bash
DOCKER_BUILD_OPTS=-"--pull=true" make
```

* Create a folder for your ROS2 workspace called `ws` and copy your packages in `ws/src`.

```bash
mkdir -p ./ws/src
```

## Usage

* Start the container

```bash
./run_container.sh
```

* Start the container using `docker compose`

```bash
docker compose run --rm --name ros2_devel_container ros2_dev_env bash
```

* Entering the container from another terminal

```bash
./exec_container.sh
```

* Compile the workspace

```bash
colcon build
```

* Run tests

```bash
colcon test
```

* Show test results

```bash
colcon test-result --all
```

* Install dependencies via rosdep

Only required the first time when starting the container:

```bash
sudo apt-get update
rosdep update
```
