#!/bin/bash -e


: ${TAG:=latest}
# Deploy to docker hub new version (tag)
echo Deploy to docker hub new version GITHUB_REF=${GITHUB_REF}
docker tag $DOCKER_REPO $DOCKER_USERNAME/$DOCKER_REPO:$TAG
docker tag $DOCKER_REPO $DOCKER_USERNAME/$DOCKER_REPO:latest
echo $DOCKER_PASSWORD |
docker login -u $DOCKER_USERNAME --password-stdin
docker push $DOCKER_USERNAME/$DOCKER_REPO:$TAG
docker push $DOCKER_USERNAME/$DOCKER_REPO:$latest
curl -s -X POST                                 \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: token $TOKEN"            \
    -d '{"ref": "master"}'                      \
    https://api.github.com/repos/$ENDPOINT/dispatches
