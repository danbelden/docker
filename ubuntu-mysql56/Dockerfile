# Part sourced from a GitHub page
# https://github.com/docker-library/mysql/blob/eeb0c33dfcad3db46a0dfb24c352d2a1601c7667/5.7/docker-entrypoint.sh
# https://github.com/sameersbn/docker-mysql/blob/master/Dockerfile
FROM ubuntu:trusty
MAINTAINER Dan Belden <me@danbelden.com>

# Set env specific configs
ENV DEBIAN_FRONTEND noninteractive
ENV MYSQL_USER=mysql
ENV MYSQL_DATA_DIR=/var/lib/mysql
ENV MYSQL_RUN_DIR=/run/mysqld
ENV MYSQL_LOG_DIR=/var/log/mysql

# Optional env vars you can declare if you desire
ENV MYSQL_ROOT_PASSWORD=root
#ENV MYSQL_ALLOW_EMPTY_PASSWORD=yes
#ENV MYSQL_RANDOM_ROOT_PASSWORD=yes
#ENV MYSQL_ONETIME_PASSWORD=yes
#ENV MYSQL_USER=user
#ENV MYSQL_PASSWORD=password
#ENV MYSQL_DATABASE=list,of,databases,to,create

# Install gosu to enable "Easy root stepdown"
ENV GOSU_VERSION 1.7
RUN set -x
RUN apt-get update
RUN apt-get install -y --no-install-recommends ca-certificates wget
RUN rm -rf /var/lib/apt/lists/*
RUN wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)"
RUN wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc"
RUN export GNUPGHOME="$(mktemp -d)"
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu
RUN rm -r /usr/local/bin/gosu.asc
RUN chmod +x /usr/local/bin/gosu
RUN gosu nobody true
RUN apt-get purge -y --auto-remove ca-certificates wget

# Add mysql user to run the service
RUN groupadd -r mysql
RUN useradd -r -g mysql mysql

# Install MySQL dependencies
RUN apt-get update
RUN apt-get install -y --no-install-recommends pwgen
RUN apt-get install -y --no-install-recommends openssl
RUN apt-get install -y --no-install-recommends perl
RUN mkdir -p /var/lib/mysql
RUN mkdir -p /var/run/mysqld
RUN chown -R mysql:mysql /var/lib/mysql
RUN chown -R mysql:mysql /var/run/mysqld
RUN chmod 777 /var/run/mysqld
RUN rm -rf /var/lib/apt/lists/*

# Run update and install mysql-server
RUN apt-get update
RUN apt-get install -y mysql-server-5.6
RUN apt-get install -y nano
RUN rm -rf ${MYSQL_DATA_DIR}/*
RUN rm -rf /var/lib/apt/lists/*

# https://bugs.launchpad.net/ubuntu/+source/mysql-5.6/+bug/1422391
RUN cp /etc/mysql/my.cnf /usr/share/mysql/my-default.cnf

# Comment out a few problematic configuration values
# don't reverse lookup hostnames, they are usually another container
RUN sed -Ei 's/^(bind-address|log)/#&/' /etc/mysql/my.cnf
RUN echo '[mysqld]\nskip-host-cache\nskip-name-resolve' > /etc/mysql/conf.d/docker.cnf

# https://github.com/docker-library/mysql/blob/eeb0c33dfcad3db46a0dfb24c352d2a1601c7667/5.7/Dockerfile#L20
RUN mkdir /docker-entrypoint-initdb.d

# Create a volume for holding data
VOLUME /var/lib/mysql

# Copy and configure the entrypoint script
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN ln -s /usr/local/bin/entrypoint.sh /entrypoint.sh # backwards compat
ENTRYPOINT ["entrypoint.sh"]

# Expose the corresponding port and launch MySQL
EXPOSE 3306
CMD ["mysqld"]
