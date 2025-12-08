#!/bin/bash

DOCKER_USERNAME="justdan96"
DOCKER_REPO="acestream-engine"
GITHUB_REGISTRY="ghcr.io/justdan96"
TAG="3.2.11-r2"

docker build --tag $GITHUB_REGISTRY/$DOCKER_REPO:$TAG .
docker container rm -f acestream-engine || true
docker run --platform=linux/amd64 --name acestream-engine --rm -p 6878:6878 $GITHUB_REGISTRY/$DOCKER_REPO:$TAG

sleep 5
