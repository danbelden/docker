FROM ubuntu:trusty
MAINTAINER Dan Belden <me@danbelden.com>

# Set env specific configs
ENV DEBIAN_FRONTEND noninteractive
RUN locale-gen en_GB.UTF-8
ENV LANG       en_GB.UTF-8
ENV LC_ALL     en_GB.UTF-8

# Update core dependencies
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

# Enable PHP 5.6 repo and update apt-get
RUN apt-get install -y build-essential
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:ondrej/php
RUN apt-get update

# Update dependencies ready
RUN apt-get upgrade -y

# Install NGINX and PHP7-FPM
RUN apt-get install -y nginx
RUN apt-get install -y php5.6-fpm

# Start the corresponding service daemons
RUN service nginx start
RUN service php5.6-fpm start

# Expose the container port 80 
EXPOSE 80
