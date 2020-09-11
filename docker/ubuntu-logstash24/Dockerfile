# Part sourced from a GitHub page
# https://github.com/docker-library/logstash/blob/754eeb919e42b1f6f2708b73f6f13cbc06fd722c/2.4/Dockerfile
FROM ubuntu:xenial
MAINTAINER Dan Belden <me@danbelden.com>

# Set env specific configs
ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV LOGSTASH_VERSION 2.4.1
ENV LOGSTASH_DEB_VERSION 1:2.4.1-1

# Update core dependencies
RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils

# Update dependencies ready
RUN apt-get upgrade -y

# Install gosu to enable "Easy root stepdown"
ENV GOSU_VERSION 1.7
RUN set -x
RUN apt-get update
RUN apt-get install -y --no-install-recommends ca-certificates wget
RUN rm -rf /var/lib/apt/lists/*
RUN wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)"
RUN wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc"
RUN export GNUPGHOME="$(mktemp -d)"
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu
RUN rm -r /usr/local/bin/gosu.asc
RUN chmod +x /usr/local/bin/gosu
RUN gosu nobody true
RUN apt-get purge -y --auto-remove ca-certificates wget

# Install Java 8
RUN apt-get update
RUN apt-get install -y openjdk-8-jdk
RUN apt-get install -y openjdk-8-jre
RUN rm -rf /var/lib/apt/lists/*

# Logstash GPG key juggling
# https://artifacts.elastic.co/GPG-KEY-elasticsearch
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "46095ACC8548582C1A2699A9D27D666CD88E42B4";
RUN gpg --export "46095ACC8548582C1A2699A9D27D666CD88E42B4" > /etc/apt/trusted.gpg.d/elastic.gpg;
RUN apt-key list

# Logstash 2.4.1 requirements
RUN echo 'deb http://packages.elastic.co/logstash/2.4/debian stable main' > /etc/apt/sources.list.d/logstash.list

# Install logstash 2.4.1
RUN set -x
RUN apt-get update
RUN apt-get install -y --no-install-recommends "logstash=$LOGSTASH_DEB_VERSION"
RUN rm -rf /var/lib/apt/lists/*

# Add logstash env vars
ENV PATH /opt/logstash/bin:$PATH
ENV LS_SETTINGS_DIR /etc/logstash

# Patch config file rules
RUN set -ex;
RUN if [ -f "$LS_SETTINGS_DIR/logstash.yml" ]; then sed -ri 's!^path\.config:!#&!g' "$LS_SETTINGS_DIR/logstash.yml"; fi;
RUN if [ -f "$LS_SETTINGS_DIR/logstash.yml" ]; then sed -ri '/http.host:/c\http.host: 0.0.0.0' "$LS_SETTINGS_DIR/logstash.yml"; fi;
RUN if [ -f "$LS_SETTINGS_DIR/log4j2.properties" ]; then \
    cp "$LS_SETTINGS_DIR/log4j2.properties" "$LS_SETTINGS_DIR/log4j2.properties.dist"; \
    truncate --size=0 "$LS_SETTINGS_DIR/log4j2.properties"; \
fi

# Add the entrypoint script
COPY entrypoint.sh /
RUN chmod +x entrypoint.sh

# Run the logstash instance
ENTRYPOINT ["/entrypoint.sh"]
CMD ["-e", ""]
