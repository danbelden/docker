# Part sourced from a GitHub page
# https://github.com/docker-library/redis/blob/9db6cc1645465f134d03584dbbbd962ce822479a/3.2/alpine/Dockerfile
FROM ubuntu:xenial
MAINTAINER Dan Belden <me@danbelden.com>

# Set env specific configs
ENV DEBIAN_FRONTEND noninteractive

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
# Add mysql user to run the service
RUN groupadd -r redis
RUN useradd -r -g redis redis

RUN apt-get update
RUN apt-get install --no-install-recommends -y redis-server
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

RUN update-rc.d -f redis-server disable
RUN sed -i 's/^\(bind .*\)$/# \1/' /etc/redis/redis.conf
RUN sed -i 's/^\(daemonize .*\)$/# \1/' /etc/redis/redis.conf

VOLUME ["/var/lib/redis"]

EXPOSE 6379

CMD ["/usr/bin/redis-server", "/etc/redis/redis.conf"]
