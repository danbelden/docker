# Part sourced from a GitHub pages
# https://github.com/docker-library/logstash/blob/3e0af5d894e622dadf08ec849386ed64da23bb4b/5/Dockerfile
# https://github.com/docker-library/logstash/blob/3e0af5d894e622dadf08ec849386ed64da23bb4b/5/alpine/Dockerfile
# https://www.elastic.co/downloads/past-releases/logstash-5-1-2
FROM ubuntu:xenial
MAINTAINER Dan Belden <me@danbelden.com>

# Set env specific configs
ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV LOGSTASH_PATH /usr/share/logstash/bin
ENV LOGSTASH_HOME /usr/share/logstash
ENV PATH $LOGSTASH_PATH:$PATH
ENV LOGSTASH_VERSION 5.1.2
ENV LOGSTASH_TARBALL="https://artifacts.elastic.co/downloads/logstash/logstash-5.1.2.tar.gz"
ENV LOGSTASH_TARBALL_ASC="https://artifacts.elastic.co/downloads/logstash/logstash-5.1.2.tar.gz.asc"
ENV LOGSTASH_TARBALL_SHA1="dead2e06f74ab09f012ac34dfb18aafeaa7b08f0"

# Update core dependencies
RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils

# Update dependencies ready
RUN apt-get upgrade -y

# Install Java 8
RUN apt-get install -y openjdk-8-jdk
RUN apt-get install -y openjdk-8-jre
RUN java -version

# Install gosu to enable "Easy root stepdown"
ENV GOSU_VERSION 1.7
RUN set -x
RUN apt-get update
RUN apt-get install -y --no-install-recommends ca-certificates wget
RUN wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)"
RUN wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc"
RUN export GNUPGHOME="$(mktemp -d)"
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu
RUN rm -r /usr/local/bin/gosu.asc
RUN chmod +x /usr/local/bin/gosu
RUN gosu nobody true

# Check logstash sha keys are configured
RUN set -ex;
RUN if [ -z "$LOGSTASH_TARBALL_SHA1" ] && [ -z "$LOGSTASH_TARBALL_ASC" ]; then echo >&2 'error: have neither a SHA1 _or_ a signature file -- cannot verify download!'; exit 1; fi;

# Download the configured logstash version
WORKDIR /tmp
RUN wget -O logstash.tar.gz "$LOGSTASH_TARBALL";

# Check the tarball is valid using file hashes
RUN if [ "$LOGSTASH_TARBALL_SHA1" ]; then echo "$LOGSTASH_TARBALL_SHA1 *logstash.tar.gz" | sha1sum -c -; fi;
RUN if [ "$LOGSTASH_TARBALL_ASC" ]; then \
    wget -O logstash.tar.gz.asc "$LOGSTASH_TARBALL_ASC"; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEY"; \
    gpg --batch --verify logstash.tar.gz.asc logstash.tar.gz; \
    rm -r "$GNUPGHOME" logstash.tar.gz.asc; \
fi;

# Extract the tarball to the given logstash directory
RUN mkdir -p $LOGSTASH_HOME
RUN tar -xf logstash.tar.gz --strip-components=1 -C "$LOGSTASH_HOME";
RUN rm logstash.tar.gz;

# Create the logstash user
RUN groupadd -g 1000 logstash
RUN useradd logstash -u 1000 -g 1000

# Patch config file rules
RUN set -ex;
ENV LS_SETTINGS_DIR "$LOGSTASH_HOME/config"
RUN if [ -f "$LS_SETTINGS_DIR/logstash.yml" ]; then sed -ri 's!^path\.config:!#&!g' "$LS_SETTINGS_DIR/logstash.yml"; fi;
RUN if [ -f "$LS_SETTINGS_DIR/logstash.yml" ]; then sed -ri '/http.host:/c\http.host: 0.0.0.0' "$LS_SETTINGS_DIR/logstash.yml"; fi;
RUN if [ -f "$LS_SETTINGS_DIR/log4j2.properties" ]; then \
    cp "$LS_SETTINGS_DIR/log4j2.properties" "$LS_SETTINGS_DIR/log4j2.properties.dist"; \
    truncate --size=0 "$LS_SETTINGS_DIR/log4j2.properties"; \
fi

# Install logstash (Add missing folders)
RUN mkdir -p /usr/share/logstash/logs

# Install logstash (Fix folder permissions)
RUN for userDir in "$LOGSTASH_HOME/config" "$LOGSTASH_HOME/data"; do \
    if [ -d "$userDir" ]; then \
        chown -R logstash:logstash "$userDir"; \
    fi; \
done;
RUN chown -R logstash:logstash /usr/share/logstash/logs

# Check logstash works by dumping the version
RUN logstash --version

# Remove packages no-longer required
RUN apt-get purge -y --auto-remove wget
RUN rm -rf /var/lib/apt/lists/*

# Add the entrypoint script
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Expose the API port
EXPOSE 9600

# Run the logstash instance
ENTRYPOINT ["/entrypoint.sh"]
CMD ["-e", ""]
