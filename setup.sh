#!/bin/bash

docker build -t $DOCKER_REPO .
docker run --detach --name $DOCKER_REPO --publish 6878:6878 --env HOME=. \
    $DOCKER_REPO sh -c "./acestreamengine --client-console"

