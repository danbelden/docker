# docker

[![CircleCI](https://circleci.com/gh/danbelden/docker.svg?style=svg)](https://circleci.com/gh/danbelden/docker)

## Overview

This is a project for managing my personal docker files published to DockerHub:
- https://hub.docker.com/u/danbelden

### Make

You can use the convenience make commands to build and push the images in this project.

```
$ make
help                           Show this help
build-alpine-go114-goimports   Build alpine-go114-goimports
...
push-alpine-go114-goimports    Push alpine-go114-goimports
...
```

## Summary

Please feel free to fork this project to manage your own DockerHub images with CircleCI.

Note: DockerHub authentication credentials are set as environment variables for CI.

Thanks.
