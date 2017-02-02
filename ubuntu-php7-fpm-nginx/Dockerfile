FROM ubuntu:xenial
MAINTAINER Dan Belden <me@danbelden.com>

# Set env specific configs
ENV DEBIAN_FRONTEND noninteractive

# Update core dependencies
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

# Update dependencies ready
RUN apt-get upgrade -y

# Install NGINX and PHP7-FPM
RUN apt-get install -y nginx
RUN apt-get install -y php-fpm

# Start the corresponding service daemons
RUN service nginx start
RUN service php7.0-fpm start

# Expose the container port 80 
EXPOSE 80
