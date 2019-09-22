FROM ubuntu:xenial
MAINTAINER Dan Belden <me@danbelden.com>

# Set env specific configs
ENV DEBIAN_FRONTEND noninteractive
ENV LANG            en_GB.UTF-8
ENV LC_ALL          en_GB.UTF-8

# Update core dependencies
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils locales

# Switch to locale UTF8
RUN locale-gen en_GB.UTF-8

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

# NGINX tweaks
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# PHP-FPM Tweaks
RUN perl -pi -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php5/fpm/php.ini
RUN perl -pi -e 's/allow_url_fopen = Off/allow_url_fopen = On/g' /etc/php5/fpm/php.ini
RUN perl -pi -e 's/expose_php = On/expose_php = Off/g' /etc/php5/fpm/php.ini

# Expose the container port 80 & 443
EXPOSE 80
EXPOSE 443

# Run the services
CMD service php5.6-fpm start && nginx
