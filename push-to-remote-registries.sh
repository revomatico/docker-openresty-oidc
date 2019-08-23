#!/bin/bash

cd $(readlink -f ${0%/*})
. common.sh

./build.sh

REGISTRIES="$*"
if [[ -z "$REGISTRIES" ]]; then
    echo "[ERROR] Must specify at least one remote registry host! More can be specified separated by spaces"
    exit 1
fi

for reg in $REGISTRIES; do
    docker tag $DOCKER_IMAGE $reg/${DOCKER_IMAGE##*/}
    docker push $reg/${DOCKER_IMAGE##*/}
done
