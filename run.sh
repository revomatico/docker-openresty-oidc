#!/bin/bash

. common.sh

docker run -d -it \
    -p 8888:80 \
    --name $DOCKER_CONTAINER \
    $DOCKER_IMAGE
