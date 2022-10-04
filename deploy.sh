#!/bin/bash -e

: ${TAG:=latest}
# Deploy to docker hub new version (tag)
echo Deploy to docker hub new version GITHUB_REF=${GITHUB_REF}
docker tag $DOCKER_REPO $DOCKER_USERNAME/$DOCKER_REPO:$TAG
docker tag $DOCKER_REPO $DOCKER_USERNAME/$DOCKER_REPO:latest
echo $DOCKER_PASSWORD |
docker login -u $DOCKER_USERNAME --password-stdin
docker push $DOCKER_USERNAME/$DOCKER_REPO:$TAG
docker push $DOCKER_USERNAME/$DOCKER_REPO:latest
REST="curl -siX POST                            \
    -H 'Accept: application/vnd.github.v3+json' \
    -H 'Authorization: Bearer $TOKEN'           \
    -d '{"ref": "master"}'                      \
    https://api.github.com/repos/$ENDPOINT/dispatches"

RETURN="$(eval "$REST")"
echo "$RETURN"
STATUS=$(echo "$ETURN" |
    head -1            |
    awk '{print $2}')

if [ ${STATUS:=400} -ge 400 ]; then
    set -x -v
    eval "$REST"
    exit 1
fi
