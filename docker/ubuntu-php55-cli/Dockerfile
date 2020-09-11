# https://github.com/docker-library/php/blob/9abc1efe542b56aa93835e4987d5d4a88171b232/5.6/Dockerfile
FROM ubuntu:trusty
MAINTAINER Dan Belden <me@danbelden.com>

# Environment vars
ENV PHPIZE_DEPS autoconf file g++ gcc libc-dev make pkg-config re2c
ENV PHP_INI_DIR /usr/local/etc/php
ENV PHP_CFLAGS "-fstack-protector-strong -fpic -fpie -O2"
ENV PHP_CPPFLAGS "$PHP_CFLAGS"
ENV PHP_LDFLAGS "-Wl,-O1 -Wl,--hash-style=both -pie"
ENV GPG_KEYS 1A4E8B7277C42E53DBA9C7B9BCAA30EA9C0D5763 6E4F6AB321FDC07F2C332E3AC2BF0BC433CFC8B3
ENV PHP_VERSION 5.5.38
ENV PHP_URL "https://secure.php.net/get/php-5.5.38.tar.xz/from/this/mirror"
ENV PHP_ASC_URL "https://secure.php.net/get/php-5.5.38.tar.xz.asc/from/this/mirror"
ENV PHP_SHA256 "cb527c44b48343c8557fe2446464ff1d4695155a95601083e5d1f175df95580f"
ENV PHP_MD5 "72302e26f153687e2ca922909f927443"

# Install installation persistent / runtime deps
RUN apt-get update
RUN apt-get install -y $PHPIZE_DEPS ca-certificates curl libedit2 libsqlite3-0 libxml2 xz-utils	--no-install-recommends
RUN rm -r /var/lib/apt/lists/*

# Create the PHP ini folder
RUN mkdir -p $PHP_INI_DIR/conf.d

# Install fetch dependencies
RUN set -xe;
RUN apt-get update;
RUN apt-get install -y --no-install-recommends wget
RUN rm -rf /var/lib/apt/lists/*;

# Retrieve the php install files
WORKDIR /usr/src
RUN pwd
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

# Clear out the fetch dependencies
RUN apt-get purge -y --auto-remove wget

# Add a tarball manager bash command
COPY docker-php-source /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-php-source

# Install additional build dependencies
RUN set -xe
RUN apt-get update
RUN apt-get install -y libcurl4-openssl-dev libedit-dev libsqlite3-dev libssl-dev libxml2-dev --no-install-recommends
RUN rm -rf /var/lib/apt/lists/*

# Add the build flags
RUN export CFLAGS="$PHP_CFLAGS"
RUN export CPPFLAGS="$PHP_CPPFLAGS"
RUN export LDFLAGS="$PHP_LDFLAGS"

# Extract and install the php tarball
RUN ls -l /usr/src
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
    --with-libedit \
    --with-openssl \
    --with-zlib \
    $PHP_EXTRA_CONFIGURE_ARGS
RUN make -j "$(nproc)"
RUN make install
RUN { find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' + || true; }
RUN make clean
RUN docker-php-source delete

# Add the PHP ini file
COPY php.ini /usr/local/etc/php

# Remove now redundant build dependencies
RUN apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false libcurl4-openssl-dev libedit-dev libsqlite3-dev libssl-dev libxml2-dev

# Copy docker extension and entrypoint files
COPY docker-php-ext-configure /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-php-ext-configure
COPY docker-php-ext-enable /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-php-ext-enable
COPY docker-php-ext-install /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-php-ext-install
COPY docker-php-entrypoint /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-php-entrypoint

# Configure and run the php interpreter
ENTRYPOINT ["docker-php-entrypoint"]
CMD ["php", "-a"]
