#!/bin/bash

docker build -t $DOCKER_REPO .
docker run --detach --name $DOCKER_REPO --publish 6878:6878 \
    $DOCKER_REPO /srv/acestream/start-engine --client-console
