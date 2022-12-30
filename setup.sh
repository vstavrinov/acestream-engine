#!/bin/bash

docker build --tag $DOCKER_USERNAME/$DOCKER_REPO .
docker run --detach --name $DOCKER_REPO --publish 6878:6878 \
    $DOCKER_USERNAME/$DOCKER_REPO

sleep 5
