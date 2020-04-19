#!/bin/bash
DOCKER_IMAGE="popeye-action"

docker build . -t ${DOCKER_IMAGE}
