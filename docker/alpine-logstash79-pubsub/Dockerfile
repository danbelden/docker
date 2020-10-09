FROM alpine:latest
MAINTAINER Dan Belden <me@danbelden.com>

# Set build configs
ENV VERSION 7.9.2
ENV DOWNLOAD_URL https://artifacts.elastic.co/downloads/logstash
ENV TARBALL "${DOWNLOAD_URL}/logstash-oss-${VERSION}.tar.gz"

# Install logstash
RUN apk add --no-cache openjdk8-jre su-exec libc6-compat libzmq bash && \
  apk upgrade --update --no-cache && \
  apk add --no-cache --virtual ".build-deps" wget ca-certificates gnupg openssl && \
  set -ex && \
  cd /tmp && \
  wget --progress=bar:force -O logstash.tar.gz "$TARBALL" && \
  tar -xzf logstash.tar.gz && \
  mv logstash-$VERSION /usr/share/logstash && \
  ln -s /usr/share/logstash /opt/logstash && \
  rm -rf /tmp/* && \
  addgroup --gid 1000 logstash && \
  adduser -u 1000 -G logstash -h /usr/share/logstash -H -D logstash && \
  chown --recursive logstash:logstash /usr/share/logstash/ && \
  chown -R logstash:root /usr/share/logstash && \
  chmod -R g=u /usr/share/logstash && \
  find /usr/share/logstash -type d -exec chmod g+s {} \; && \
  apk del --purge .build-deps

# Install logstash GCP pubsub plugin
ENV PATH /usr/share/logstash/bin:/sbin:$PATH
RUN logstash-plugin install logstash-input-google_pubsub

# Final setup
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENV LANG='en_US.UTF-8'
ENV LC_ALL='en_US.UTF-8'
WORKDIR /usr/share/logstash
USER 1000

# Run the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
CMD ["-e", ""]
