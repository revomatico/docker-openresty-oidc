#!/bin/bash

cd $(readlink -f ${0%/*})
. common.sh

# Get the latest
wget -nv https://raw.githubusercontent.com/zmartzone/lua-resty-openidc/master/lib/resty/openidc.lua -O lua-resty-openidc/openidc.lua

docker build \
    --force-rm \
    -t $DOCKER_IMAGE \
    .

# List image in docker
docker images $DOCKER_IMAGE
