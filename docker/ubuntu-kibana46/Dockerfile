# Part sourced from a GitHub page
# https://github.com/docker-library/kibana/blob/902581f626cba60693e32ca54f91f487b6be7e98/4.6/Dockerfile
FROM ubuntu:xenial
MAINTAINER Dan Belden <me@danbelden.com>

# Set env specific configs
ENV DEBIAN_FRONTEND noninteractive
ENV KIBANA_MAJOR 4.6
ENV KIBANA_VERSION 4.6.4

# Update core dependencies
RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils

# Update dependencies ready
RUN apt-get upgrade -y

# Add required dependencies for install
RUN apt-get install -y --no-install-recommends ca-certificates wget

# Install gosu to enable "Easy root stepdown"
ENV GOSU_VERSION 1.7
RUN set -x
RUN rm -rf /var/lib/apt/lists/*
RUN wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)"
RUN wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc"
RUN export GNUPGHOME="$(mktemp -d)"
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu
RUN rm -r /usr/local/bin/gosu.asc
RUN chmod +x /usr/local/bin/gosu
RUN gosu nobody true

# Install tini to enable "signal processing and zombie killing"
ENV TINI_VERSION v0.9.0
RUN set -x
RUN wget -O /usr/local/bin/tini "https://github.com/krallin/tini/releases/download/$TINI_VERSION/tini"
RUN wget -O /usr/local/bin/tini.asc "https://github.com/krallin/tini/releases/download/$TINI_VERSION/tini.asc"
RUN export GNUPGHOME="$(mktemp -d)"
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 6380DC428747F6C393FEACA59A84159D7001A4E5
RUN gpg --batch --verify /usr/local/bin/tini.asc /usr/local/bin/tini
RUN rm -r /usr/local/bin/tini.asc
RUN chmod +x /usr/local/bin/tini 
RUN tini -h

# Add the elastic GPG key for apt-get
# https://artifacts.elastic.co/GPG-KEY-elasticsearch
RUN set -ex;
RUN export GNUPGHOME="$(mktemp -d)";
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "46095ACC8548582C1A2699A9D27D666CD88E42B4";
RUN gpg --export "46095ACC8548582C1A2699A9D27D666CD88E42B4" > /etc/apt/trusted.gpg.d/elastic.gpg;
RUN apt-key list

# Add the relevant kibana source url for apt-get
# https://www.elastic.co/guide/en/kibana/4.4/setup.html#kibana-apt
RUN echo "deb http://packages.elastic.co/kibana/${KIBANA_MAJOR}/debian stable main" > /etc/apt/sources.list.d/kibana.list

# Install kibana
RUN set -x
RUN apt-get update
RUN apt-get install -y --no-install-recommends kibana=$KIBANA_VERSION
RUN chown -R kibana:kibana /opt/kibana
RUN rm -rf /var/lib/apt/lists/*

# Correct kibana configuration issues
# ensure the default configuration is useful when using --link
RUN sed -ri "s!^(\#\s*)?(elasticsearch\.url:).*!\2 'http://elasticsearch:9200'!" /opt/kibana/config/kibana.yml
RUN grep -q 'elasticsearch:9200' /opt/kibana/config/kibana.yml

# Add the kibana executable to the root PATH
ENV PATH /opt/kibana/bin:$PATH

# Purge now redundant packages
RUN apt-get purge -y --auto-remove ca-certificates wget
RUN rm -rf /var/lib/apt/lists/*

# Copy the entrypoint exzecutable
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Expose the port for kibana and launch the service
EXPOSE 5601
ENTRYPOINT ["/entrypoint.sh"]
CMD ["kibana"]
