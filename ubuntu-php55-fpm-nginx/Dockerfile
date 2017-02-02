# https://github.com/vutran/docker-nginx-php5-fpm/blob/master/Dockerfile
# https://github.com/nginxinc/docker-nginx/blob/master/mainline/alpine/Dockerfile
# Reference: http://stackoverflow.com/questions/18861300/how-to-run-nginx-within-docker-container-without-halting
FROM ubuntu:trusty
MAINTAINER Dan Belden <me@danbelden.com>

# Set env specific configs
ENV DEBIAN_FRONTEND noninteractive

# Update core dependencies
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

# Update dependencies ready
RUN apt-get upgrade -y

# Install NGINX and PHP7-FPM
RUN apt-get install -y nginx
RUN apt-get install -y php5-fpm

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
CMD service php5-fpm start && nginx
