ROS2_DISTRO         ?= $(shell cat .env | grep IMAGE_TAG | cut -d = -f 2)
IMAGE_NAME          := ros2_devel
IMAGE_TAG           = $(ROS2_DISTRO)
APT_MIRROR          ?= jp
USER_ID             :=$(shell id -u)
GROUP_ID            :=$(shell id -g)
DOCKER_BUILD_OPTS   ?=

.PHONY: build-image
build-image:
	docker build $(DOCKER_BUILD_OPTS) \
		-t $(IMAGE_NAME):$(IMAGE_TAG) \
		--build-arg ROS2_DISTRO=$(ROS2_DISTRO) \
		--build-arg APT_MIRROR=$(APT_MIRROR) \
		--build-arg USER_ID=$(USER_ID) \
		--build-arg GROUP_ID=$(GROUP_ID) .
