#!/usr/bin/env bash

# https://github.com/JCMais/docker-building-on-ci/blob/master/.circleci/config.yml

# Check the docker hub username env vars is set
if [[ -z "$DOCKERHUB_USERNAME" ]]; then
  echo "[ERROR] Docker hub username env var is not set"
  exit 1
fi

# Check the docker hub password env vars is set
if [[ -z "$DOCKERHUB_PASSWORD" ]]; then
  echo "[ERROR] Docker hub password env var is not set"
  exit 1
fi

# Check the docker push name is provided in arg1
IMAGE_NAME="$1"
if [[ -z "$IMAGE_NAME" ]]; then
  echo "[ERROR] No docker image is provided in arg1!"
  exit 1
fi

# Check the image name contains a slash and colon (Example: "danbelden/ubuntu-mysql56:latest")
if [[ "$IMAGE_NAME" != */* || "$IMAGE_NAME" != *:* ]]; then
  echo "[ERROR] \"$IMAGE_NAME\" is not a valid image name! (Example: repo/name:tag)"
  exit 1
fi

# Check the docker image exists
IMAGE_ID=`docker image inspect --format "{{lower .Id}}" "$IMAGE_NAME"`
if [[ $? != 0 ]]; then
  echo "[ERROR] \"$IMAGE_NAME\" is not valid!"
  exit 1
fi

# Output some info for debugging
echo "----------- Debug ---------------"
echo "IMAGE_NAME: $IMAGE_NAME"
echo "IMAGE_ID: $IMAGE_ID"

# Login to docker hub
echo "------- DockerHub Login ---------"
echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin
if [[ $? != 0 ]]; then
  echo "[ERROR] Failed to login to DockerHub!"
  exit 1
fi

# Process the docker hub tag
echo "------- DockerHub Push ----------"
docker push "$IMAGE_NAME"
