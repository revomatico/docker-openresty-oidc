#!/bin/bash

# Test run the container using a shell

. common.sh

docker run -it --rm \
    --name $DOCKER_CONTAINER \
    $DOCKER_IMAGE \
    $*
