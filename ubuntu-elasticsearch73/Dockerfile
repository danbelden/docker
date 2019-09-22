# Part sourced from a GitHub page
# https://github.com/dockerfile/elasticsearch/blob/master/Dockerfile
FROM ubuntu:xenial
MAINTAINER Dan Belden <me@danbelden.com>

# Set env specific configs
ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64
ENV ES_PKG_NAME 7.3.2

# Update core dependencies
RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils software-properties-common

# Add openjdk PPA repo
RUN add-apt-repository ppa:openjdk-r/ppa
RUN apt-get update

# Update dependencies ready
RUN apt-get upgrade -y

# Install Java 11
RUN apt-get install -y openjdk-11-jdk
RUN apt-get install -y openjdk-11-jre

# Install elasticsearch
RUN apt-get install wget
WORKDIR /usr/share
RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_PKG_NAME}-linux-x86_64.tar.gz
RUN tar xvzf elasticsearch-${ES_PKG_NAME}-linux-x86_64.tar.gz
RUN rm /usr/share/elasticsearch-${ES_PKG_NAME}-linux-x86_64.tar.gz

# Replace the default config file with the personalised one here
COPY elasticsearch.yml /usr/share/elasticsearch-${ES_PKG_NAME}/config/elasticsearch.yml

# Create an elasticsearch group and user
RUN groupadd -g 1000 elasticsearch
RUN useradd elasticsearch -u 1000 -g 1000

# Assign elasticsearch as owner of all ES files
RUN chown -R elasticsearch:elasticsearch /usr/share/elasticsearch-${ES_PKG_NAME}

# Expose ports
EXPOSE 9200
EXPOSE 9300

# Run the elastic search application
USER elasticsearch
CMD ["/usr/share/elasticsearch-7.3.2/bin/elasticsearch"]
