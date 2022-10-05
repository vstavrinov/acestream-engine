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

COMMIT=$(git rev-parse --short $GITHUB_SHA)
REST="curl -siX POST                            \
    -H 'Accept: application/vnd.github.v3+json' \
    -H 'Authorization: token $TOKEN'            \
    -d '{\"ref\": \"master\",
         \"inputs\":
           {\"acestream\": \"$COMMIT\"}
        }'                                      \
    https://api.github.com/repos/$ENDPOINT/dispatches"

RETURN="$(eval "$REST")"
echo "$RETURN"
STATUS=$(echo "$RETURN" |
    head -1            |
    awk '{print $2}')

if [ ${STATUS:=400} -ge 400 ]; then
    set -x -v
    eval "$REST"
    exit 1
fi
