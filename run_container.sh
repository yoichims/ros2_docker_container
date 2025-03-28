#!/usr/bin/env bash

source utils

IMAGE_TAG=$(cat .env | grep IMAGE_TAG | cut -d = -f 2)

while [[ ${#} -gt 0 ]]; do
  key="${1}"

  case ${key} in
    -d|--distro)
      IMAGE_TAG="${2}"
      shift
      shift
      ;;
    *)
      echo -e "\e[33mIgnoring unknown option ${key}.\e[0m"
      exit 1
      ;;
  esac
done

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
touch ${XAUTH}
xauth nlist ${DISPLAY} | sed -e 's/^..../ffff/' | xauth -f ${XAUTH} nmerge -

DOCKER_ARGS_GUI="-e DISPLAY "
DOCKER_ARGS_GUI+="-e XAUTHORITY=${XAUTH} "
DOCKER_ARGS_GUI+="-v ${XAUTH}:${XAUTH}:rw "
DOCKER_ARGS_GUI+="-v ${XSOCK}:${XSOCK}:rw "

if command -v nvidia-smi &> /dev/null; then
  gpu_list=$(nvidia-smi -L)
  if [[ ! -z ${gpu_list} ]]; then
    DOCKER_ARGS_GUI+="-e NVIDIA_DRIVER_CAPABILITIES=all "
    DOCKER_ARGS_GUI+="--gpus=all "
  else
    echo -e "\e[33m[WARN]: Cannot find any GPU.\e[0m"
  fi
fi

echo "Starting container using ${IMAGE_NAME}:${IMAGE_TAG}"

exec docker run -it --rm --name=${CONTAINER_NAME} \
  --net=host \
  --device=/dev/video0 \
  ${DOCKER_ARGS_GUI} \
  -v $(pwd)/ws:/home/user/ws \
  ${IMAGE_NAME}:${IMAGE_TAG} \
  bash
