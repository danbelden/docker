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
RUN apt-get install -y php-fpm php-curl php-mysql

# NGINX tweaks
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# PHP-FPM Tweaks
RUN perl -pi -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/7.0/fpm/php.ini
RUN perl -pi -e 's/allow_url_fopen = Off/allow_url_fopen = On/g' /etc/php/7.0/fpm/php.ini
RUN perl -pi -e 's/expose_php = On/expose_php = Off/g' /etc/php/7.0/fpm/php.ini
RUN perl -pi -e 's/;clear_env = no/clear_env = no/g' /etc/php/7.0/fpm/pool.d/www.conf

# Expose the container port 80 & 443
EXPOSE 80
EXPOSE 443

# Add entrypoint to the container
COPY entrypoint.sh /var/entrypoint.sh

# Run the services
ENTRYPOINT [ "/var/entrypoint.sh" ]
