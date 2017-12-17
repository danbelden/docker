# Part sourced from a GitHub page
# https://github.com/docker-library/rabbitmq/blob/2016a3de7f3c9663208bd11a9bd49b2af49c13bc/Dockerfile
FROM ubuntu:xenial
MAINTAINER Dan Belden <me@danbelden.com>

# Set env specific configs
ENV DEBIAN_FRONTEND noninteractive
ENV GOSU_VERSION 1.7
ENV RABBITMQ_VERSION 3.6.14
ENV RABBITMQ_DEBIAN_VERSION 3.6.14-1
ENV RABBITMQ_LOGS=- RABBITMQ_SASL_LOGS=-

# Update core dependencies
RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils

# Update dependencies ready
RUN apt-get upgrade -y

# grab gosu for easy step-down from root
RUN set -x
RUN apt-get install -y --no-install-recommends ca-certificates wget
RUN rm -rf /var/lib/apt/lists/*
RUN wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)"
RUN wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc"
RUN export GNUPGHOME="$(mktemp -d)"
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu
RUN chmod +x /usr/local/bin/gosu
RUN gosu nobody true
RUN apt-get purge -y --auto-remove ca-certificates wget

# install Erlang
RUN apt-get update
RUN apt-get install -y --no-install-recommends erlang-asn1 erlang-base-hipe erlang-crypto erlang-eldap erlang-inets erlang-mnesia erlang-nox erlang-os-mon erlang-public-key erlang-ssl erlang-xmerl
RUN rm -rf /var/lib/apt/lists/*

# http://www.rabbitmq.com/install-debian.html
# "Please note that the word testing in this line refers to the state of our release of RabbitMQ, not any particular Debian distribution."
RUN set -ex; \
	key='0A9AF2115F4687BD29803A206B73A36E6026DFCA'; \
	export GNUPGHOME="$(mktemp -d)"; \
	gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
	gpg --export "$key" > /etc/apt/trusted.gpg.d/rabbitmq.gpg; \
	rm -r "$GNUPGHOME"; \
	apt-key list
RUN echo 'deb http://www.rabbitmq.com/debian testing main' > /etc/apt/sources.list.d/rabbitmq.list

# install rabbitmq
RUN apt-get update
RUN apt-get install -y --no-install-recommends rabbitmq-server=$RABBITMQ_DEBIAN_VERSION
RUN rm -rf /var/lib/apt/lists/*

# /usr/sbin/rabbitmq-server has some irritating behavior, and only exists to "su - rabbitmq /usr/lib/rabbitmq/bin/rabbitmq-server ..."
ENV PATH /usr/lib/rabbitmq/bin:$PATH

# set home so that any `--user` knows where to put the erlang cookie
ENV HOME /var/lib/rabbitmq

# fudge with rabbit file permissions for some reason
RUN mkdir -p /var/lib/rabbitmq /etc/rabbitmq
RUN echo '[ { rabbit, [ { loopback_users, [ ] } ] } ].' > /etc/rabbitmq/rabbitmq.config
RUN chown -R rabbitmq:rabbitmq /var/lib/rabbitmq /etc/rabbitmq
RUN chmod -R 777 /var/lib/rabbitmq /etc/rabbitmq
VOLUME /var/lib/rabbitmq

# add a symlink to the .erlang.cookie in /root so we can "docker exec rabbitmqctl ..." without gosu
RUN ln -sf /var/lib/rabbitmq/.erlang.cookie /root/
RUN ln -sf /usr/lib/rabbitmq/lib/rabbitmq_server-$RABBITMQ_VERSION/plugins /plugins

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 4369 5671 5672 25672 15671 15672
RUN rabbitmq-plugins enable --offline rabbitmq_management

CMD ["rabbitmq-server"]
