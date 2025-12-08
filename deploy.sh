#!/bin/bash -e

DOCKER_USERNAME="justdan96"
DOCKER_REPO="acestream-engine"
GITHUB_REGISTRY="ghcr.io/justdan96"
TAG="3.2.11-r2"

# Deploy to GHCR new version (tag)
docker tag $GITHUB_REGISTRY/$DOCKER_REPO:$TAG $GITHUB_REGISTRY/$DOCKER_REPO:latest
docker push $GITHUB_REGISTRY/$DOCKER_REPO:$TAG
docker push $GITHUB_REGISTRY/$DOCKER_REPO:latest
