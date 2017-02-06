# Part sourced from a GitHub page
# https://github.com/romeOz/docker-redis/blob/master/3.2/Dockerfile
FROM ubuntu:xenial
MAINTAINER Dan Belden <me@danbelden.com>

# Set env specific configs
ENV DEBIAN_FRONTEND noninteractive
ENV REDIS_VERSION=3.2.5
ENV REDIS_USER=redis
ENV REDIS_CONF=/etc/redis/redis.conf
ENV REDIS_DATA_DIR=/var/lib/redis
ENV REDIS_LOG_DIR=/var/log/redis

# Install redis 3.2
RUN set -x
RUN apt-get update
RUN apt-get install -y ruby gcc libc6-dev make curl --no-install-recommends
RUN mkdir -p /tmp/redis
RUN curl -sSL "http://download.redis.io/releases/redis-$REDIS_VERSION.tar.gz" -o redis.tar.gz
RUN tar -xzf redis.tar.gz -C /tmp/redis --strip-components=1
RUN rm redis.tar.gz
RUN make -C /tmp/redis
RUN make -C /tmp/redis install
RUN cp /tmp/redis/src/redis-trib.rb /redis-trib.rb
RUN rm -rf /tmp/redi*
RUN gem install redis
RUN apt-get purge -y --auto-remove ruby gcc libc6-dev make curl
RUN rm -rf /var/lib/apt/lists/*

# Redis config tweaks
COPY ./redis.conf ${REDIS_CONF}
COPY ./entrypoint.sh /sbin/entrypoint.sh
RUN chmod +x /sbin/entrypoint.sh

# Expose and run the redis client
EXPOSE 6379
VOLUME ["${REDIS_DATA_DIR}"]
ENTRYPOINT ["/sbin/entrypoint.sh"]
