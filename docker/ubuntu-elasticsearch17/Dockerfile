# Part sourced from a GitHub page
# https://github.com/dockerfile/elasticsearch/blob/master/Dockerfile
FROM ubuntu:xenial
MAINTAINER Dan Belden <me@danbelden.com>

# Set env specific configs
ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV ES_PKG_NAME elasticsearch-1.7.6

# Update core dependencies
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

# Update dependencies ready
RUN apt-get upgrade -y

# Install Java 8
RUN apt-get install -y openjdk-8-jdk
RUN apt-get install -y openjdk-8-jre

# Install Elasticsearch 1.7.6
RUN cd /
RUN apt-get install -y wget
RUN wget https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES_PKG_NAME.tar.gz
RUN tar xvzf $ES_PKG_NAME.tar.gz
RUN rm -f $ES_PKG_NAME.tar.gz
RUN mv /$ES_PKG_NAME /elasticsearch

# Define mountable directories.
VOLUME ["/data"]

# Mount 1.7.6 elasticsearch.yml config file
ADD elasticsearch.yml /elasticsearch/config/elasticsearch.yml

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["/elasticsearch/bin/elasticsearch"]

# Expose ports.
EXPOSE 9200
EXPOSE 9300
