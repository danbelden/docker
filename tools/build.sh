#!/usr/bin/env bash

# Check the folder name on arg1 is set
if [[ -z $1 ]]; then
  echo "[ERROR] No build folder provided in arg1!"
  exit 1
fi

# Check the path exists
BUILD_PATH="docker/$1"
if [[ ! -d "$BUILD_PATH" ]]; then
  echo "[ERROR] \"$BUILD_PATH\" is not a valid build path!"
  exit 1
fi

# Check the tag name is set on arg2 [Default: "test"]
TAG_NAME="$2"
if [[ -z "$TAG_NAME" ]]; then
  TAG_NAME="test"
fi

# [Hack] Realpath function hack for OSX
# https://stackoverflow.com/questions/3572030/bash-script-absolute-path-with-os-x
realpath() {
  [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

# Create the remaining vars for docker build
BUILD_PATH_FULL="$(realpath $BUILD_PATH)"
BUILD_PATH_LAST_DIR="$(echo $BUILD_PATH_FULL | rev | cut -d'/' -f1 | rev)"
IMAGE_TAG="danbelden/${BUILD_PATH_LAST_DIR}:${TAG_NAME}"
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Output the vars for debugging
echo "--------------- DEBUG ----------------------"
echo "BUILD_PATH: $BUILD_PATH"
echo "BUILD_PATH_FULL: $BUILD_PATH_FULL"
echo "BUILD_PATH_LAST_DIR: $BUILD_PATH_LAST_DIR"
echo "IMAGE_TAG: $IMAGE_TAG"
echo "SCRIPT_PATH: $SCRIPT_PATH"

# Launch the docker build process
$SCRIPT_PATH/docker-build.sh "$BUILD_PATH" "$IMAGE_TAG"
