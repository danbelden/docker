FROM alpine:latest
MAINTAINER Dan Belden <me@danbelden.com>

# Set build configs
ENV GO_INSTALL_ROOT /usr/local
ENV GO_PATH /go
ENV GO_VERSION 1.14.9

# Install go
RUN apk upgrade --update --no-cache && \
  apk add --no-cache --virtual ".build-deps" go gcc bash musl-dev openssl-dev ca-certificates && \
  wget -O go.tgz "https://dl.google.com/go/go${GO_VERSION}.src.tar.gz" && \
  tar -C $GO_INSTALL_ROOT -xzf go.tgz && \
  rm go.tgz && \
  cd $GO_INSTALL_ROOT/go/src && \
  ./make.bash && \
  apk del ".build-deps"
ENV GOROOT="${GO_INSTALL_ROOT}/go"
ENV GOPATH="${GO_PATH}"
ENV PATH="${PATH}:${GOROOT}/bin:${GOPATH}/bin"

# Install goimports
RUN apk add --no-cache --virtual ".build-deps" git && \
  go get golang.org/x/tools/cmd/goimports && \
  apk del ".build-deps"

# Create empty workdir
RUN mkdir -p /app
WORKDIR /app

# Run the goimports command as entrypoint
ENTRYPOINT ["goimports"]
CMD ["--help"]
