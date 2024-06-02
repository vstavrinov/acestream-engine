#!/bin/bash -e

# Deploy to docker hub new version (tag)
docker tag $DOCKER_USERNAME/$DOCKER_REPO{,:$TAG}
echo $DOCKER_PASSWORD |
docker login -u $DOCKER_USERNAME --password-stdin
docker push $DOCKER_USERNAME/$DOCKER_REPO:$TAG
docker push $DOCKER_USERNAME/$DOCKER_REPO
echo $GITHUB_PASSWORD |
docker login -u $GITHUB_USERNAME --password-stdin $GITHUB_REGISTRY
docker tag $DOCKER_USERNAME/$DOCKER_REPO $GITHUB_REGISTRY/$IMAGE_NAME:$TAG
docker tag $DOCKER_USERNAME/$DOCKER_REPO $GITHUB_REGISTRY/$IMAGE_NAME:latest
docker push $GITHUB_REGISTRY/$IMAGE_NAME:$TAG
docker push $GITHUB_REGISTRY/$IMAGE_NAME:latest

COMMIT=$(git rev-parse --short $GITHUB_SHA)
REST="curl -siX POST                            \
    -H 'Accept: application/vnd.github.v3+json' \
    -H 'Authorization: token $TOKEN'            \
    -d '{\"ref\": \"master\",
         \"inputs\":
           {\"deploy\": \"true\"}
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
