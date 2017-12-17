# Part sourced from a GitHub page
# https://github.com/dockerfile/elasticsearch/blob/master/Dockerfile
FROM ubuntu:xenial
MAINTAINER Dan Belden <me@danbelden.com>

# Set env specific configs
ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV ES_PKG_NAME 6.1.0

# Update core dependencies
RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils

# Update dependencies ready
RUN apt-get upgrade -y

# Install Java 8
RUN apt-get install -y openjdk-8-jdk
RUN apt-get install -y openjdk-8-jre

# Install elastic search
RUN apt-get install wget
WORKDIR /usr/share
RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$ES_PKG_NAME.tar.gz
RUN tar xvzf elasticsearch-$ES_PKG_NAME.tar.gz
RUN rm /usr/share/elasticsearch-$ES_PKG_NAME.tar.gz

# Replace the default config file with the personalised one here
COPY elasticsearch.yml /usr/share/elasticsearch-$ES_PKG_NAME/config/elasticsearch.yml

# Create an elasticsearch group and user
RUN groupadd -g 1000 elasticsearch
RUN useradd elasticsearch -u 1000 -g 1000

# Assign elasticsearch as owner of all ES files
RUN chown -R elasticsearch:elasticsearch /usr/share/elasticsearch-$ES_PKG_NAME

# Expose ports.
EXPOSE 9200
EXPOSE 9300

# Run the elastic search application
USER elasticsearch
CMD ["/usr/share/elasticsearch-6.1.0/bin/elasticsearch"]
