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

# Check the source tag name is set on arg1 [Default: "test"]
SOURCE_TAG_NAME="$2"
if [[ -z "$SOURCE_TAG_NAME" ]]; then
  SOURCE_TAG_NAME="test"
fi

# Check the release tag name is set on arg2 [Default: "latest"]
RELEASE_TAG_NAME="$3"
if [[ -z "$RELEASE_TAG_NAME" ]]; then
  RELEASE_TAG_NAME="latest"
fi

# [Hack] Realpath function hack for OSX
# https://stackoverflow.com/questions/3572030/bash-script-absolute-path-with-os-x
realpath() {
  [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

# Create the remaining vars for docker build
BUILD_PATH_FULL="$(realpath $BUILD_PATH)"
BUILD_PATH_LAST_DIR="$(echo $BUILD_PATH_FULL | rev | cut -d'/' -f1 | rev)"
SOURCE_IMAGE_TAG="danbelden/${BUILD_PATH_LAST_DIR}:${SOURCE_TAG_NAME}"
RELEASE_IMAGE_TAG="danbelden/${BUILD_PATH_LAST_DIR}:${RELEASE_TAG_NAME}"
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Throw an error if the source tag does not exist
SOURCE_IMAGE_ID=`docker image inspect --format "{{lower .Id}}" "$SOURCE_IMAGE_TAG"`
if [[ $? != 0 ]]; then
  echo "[ERROR] \"$SOURCE_IMAGE_TAG\" is not valid!"
  exit 1
fi

# Create a release tag from the source tag
docker tag "$SOURCE_IMAGE_TAG" "$RELEASE_IMAGE_TAG"

# Throw an error if the release tag does not exist
RELEASE_IMAGE_ID=`docker image inspect --format "{{lower .Id}}" "$RELEASE_IMAGE_TAG"`
if [[ $? != 0 ]]; then
  echo "[ERROR] \"$RELEASE_IMAGE_TAG\" is not valid!"
  exit 1
fi

# Output the vars for debugging
echo "--------------- DEBUG ----------------------"
echo "BUILD_PATH: $BUILD_PATH"
echo "BUILD_PATH_FULL: $BUILD_PATH_FULL"
echo "BUILD_PATH_LAST_DIR: $BUILD_PATH_LAST_DIR"
echo "SOURCE_IMAGE_TAG: $SOURCE_IMAGE_TAG"
echo "SOURCE_IMAGE_ID: $SOURCE_IMAGE_ID"
echo "RELEASE_IMAGE_TAG: $RELEASE_IMAGE_TAG"
echo "RELEASE_IMAGE_ID: $RELEASE_IMAGE_ID"
echo "SCRIPT_PATH: $SCRIPT_PATH"

# Run the docker hub push
$SCRIPT_PATH/docker-push.sh "$RELEASE_IMAGE_TAG"
