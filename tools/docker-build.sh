#!/usr/bin/env bash

# Check the build folder is non-empty
if [[ -z $1 ]]; then
  echo "[ERROR] No build folder provided in arg1!"
  exit 1
fi

# If the path is a directory append `Dockerfile`
DOCKERFILE_PATH="$1"
if [[ -d "$DOCKERFILE_PATH" ]]; then
  DOCKERFILE_PATH="${DOCKERFILE_PATH}/Dockerfile"
fi

# Check the docker file path is valid
if [[ ! -f "$DOCKERFILE_PATH" ]]; then
  echo "[ERROR] \"${1}\" is not a valid build path!"
  exit 1
fi

# Check the image tag is non-empty
if [[ -z $2 ]]; then
  echo "[ERROR] No image name provided in arg2!"
  exit 1
fi

# Check the image name contains a slash and colon (Example: "danbelden/ubuntu-mysql56:latest")
IMAGE_NAME="$2"
if [[ "$IMAGE_NAME" != */* || "$IMAGE_NAME" != *:* ]]; then
  echo "[ERROR] \"$IMAGE_NAME\" is not a valid image name! (Example: repo/name:tag)"
  exit 1
fi

# [Hack] Realpath function hack for OSX
# https://stackoverflow.com/questions/3572030/bash-script-absolute-path-with-os-x
realpath() {
  [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

# Find the absolute file path for the Dockerfile
DOCKERFILE_PATH_FULL="$(realpath $DOCKERFILE_PATH)"
DOCKERFILE_PATH_DIR="$(dirname $DOCKERFILE_PATH_FULL)"

# Output some info for de-bugging builds
echo "--------------- DEBUG ----------------------"
echo "DOCKERFILE_PATH_FULL: $DOCKERFILE_PATH_FULL"
echo "DOCKERFILE_PATH_DIR: $DOCKERFILE_PATH_DIR"
echo "IMAGE_NAME: $IMAGE_NAME"

# Build the docker image
echo "--------------- BUILD ----------------------"
docker build -t $IMAGE_NAME $DOCKERFILE_PATH_DIR
