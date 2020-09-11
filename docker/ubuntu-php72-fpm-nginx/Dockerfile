FROM ubuntu:xenial
MAINTAINER Dan Belden <me@danbelden.com>

# Set env specific configs
ENV DEBIAN_FRONTEND noninteractive

# Environment vars
ENV PHPIZE_DEPS autoconf dpkg-dev file g++ gcc libc-dev make pkg-config re2c
ENV PHP_INI_DIR /usr/local/etc/php
ENV PHP_CFLAGS "-fstack-protector-strong -fpic -fpie -O2"
ENV PHP_CPPFLAGS "$PHP_CFLAGS"
ENV PHP_LDFLAGS "-Wl,-O1 -Wl,--hash-style=both -pie"
ENV PHP_EXTRA_CONFIGURE_ARGS "--enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data"
ENV GPG_KEYS 1729F83938DA44E27BA0F4D3DBDB397470D12172 B1B44D8F021E4E2D6021E995DC9FF8D3EE5AF27F
ENV PHP_VERSION 7.2.0
ENV PHP_URL "https://secure.php.net/get/php-7.2.0.tar.xz/from/this/mirror"
ENV PHP_ASC_URL "https://secure.php.net/get/php-7.2.0.tar.xz.asc/from/this/mirror"
ENV PHP_SHA256 "87572a6b924670a5d4aac276aaa4a94321936283df391d702c845ffc112db095"
ENV PHP_MD5 "ef8d4764f16d5f066e9893fe91887a31"

# Install deps
RUN apt-get update
RUN apt-get install -y --no-install-recommends $PHPIZE_DEPS \
    libssl-dev libreadline6 libreadline6-dev ca-certificates curl \
    libcurl4-openssl-dev libedit2 libsqlite3-0 libxml2 xz-utils wget \
    libedit-dev libxml2-dev

# Install NGINX
RUN apt-get install -y nginx

# Retrieve the php install files
WORKDIR /usr/src
RUN wget -O php.tar.xz "$PHP_URL";

# Verify file hashes
RUN if [ -n "$PHP_SHA256" ]; then echo "$PHP_SHA256 *php.tar.xz" | sha256sum -c -; fi;
RUN if [ -n "$PHP_MD5" ]; then echo "$PHP_MD5 *php.tar.xz" | md5sum -c -; fi;
RUN if [ -n "$PHP_ASC_URL" ]; then \
    wget -O php.tar.xz.asc "$PHP_ASC_URL"; \
    export GNUPGHOME="$(mktemp -d)"; \
    for key in $GPG_KEYS; do \
        gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
    done; \
    gpg --batch --verify php.tar.xz.asc php.tar.xz; \
    rm -r "$GNUPGHOME"; \
fi;

# Add a tarball manager bash command
COPY docker-php-source /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-php-source

# Create config directories
RUN mkdir "$PHP_INI_DIR"
RUN mkdir "$PHP_INI_DIR/conf.d"
RUN mkdir "$PHP_INI_DIR/fpm/"
RUN mkdir "$PHP_INI_DIR/fpm/pool.d"

# Extract and install the php tarball
RUN docker-php-source extract
WORKDIR /usr/src/php
RUN ./configure	\
    --with-config-file-path="$PHP_INI_DIR" \
    --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
    --disable-cgi \
    --enable-ftp \
    --enable-mbstring \
    --enable-mysqlnd \
    --with-curl \
    --without-readline \
    --with-libedit \
    --with-openssl \
    --with-zlib \
    $PHP_EXTRA_CONFIGURE_ARGS
RUN make -j "$(nproc)"
RUN make install
RUN { find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' + || true; }
RUN cp sapi/fpm/php-fpm /usr/local/bin/php-fpm
RUN chmod +x /usr/local/bin/php-fpm
RUN make clean
RUN docker-php-source delete

# Add the PHP/FPM config files
COPY php.ini /usr/local/etc/php/php.ini
COPY php.ini /usr/local/etc/php/fpm/php.ini
COPY php-fpm.conf /usr/local/etc/php-fpm.conf
COPY www.conf /usr/local/etc/php/fpm/pool.d/www.conf

# Add php-fpm as a service `service php-fpm start`
COPY php-fpm-service /etc/init.d/php-fpm
RUN chmod +x /etc/init.d/php-fpm
RUN update-rc.d php-fpm defaults

# Clear out unused dependencies
RUN apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    libedit-dev libsqlite3-dev libssl-dev libxml2-dev wget
RUN rm -r /var/lib/apt/lists/*

# NGINX tweaks
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# Expose the container port 80 & 443
EXPOSE 80
EXPOSE 443

# Add entrypoint to the container
COPY entrypoint.sh /var/entrypoint.sh
RUN chmod +x /var/entrypoint.sh

# Run the services
ENTRYPOINT [ "/var/entrypoint.sh" ]
