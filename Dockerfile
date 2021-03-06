FROM debian:jessie
MAINTAINER Werner Beroux <werner@beroux.com>

# 1. Install compile and runtime dependencies
# 2. Compile PhantomJS from the source code
# 3. Remove compile depdencies
# We do all in a single commit to reduce the image size (a lot!)
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        g++ \
        git \
        flex \
        bison \
        gperf \
        perl \
        python \
        ruby \
        libsqlite3-dev \
        libfontconfig1-dev \
        libicu-dev \
        libfreetype6 \
        libssl-dev \
        libpng-dev \
        libjpeg-dev \
    && apt-get install -y --no-install-recommends \
        haproxy \
    && apt-get install -y \
        squid3 \
    && git clone --recurse-submodules https://github.com/ariya/phantomjs /tmp/phantomjs \
    && cd /tmp/phantomjs \
    && git checkout -f tags/1.9.7 \
    && git clean -fdx \
    && ./build.sh --confirm --jobs 2 \
    && mv bin/phantomjs /usr/local/bin \
    && cd \
    && apt-get purge --auto-remove -y \
        build-essential \
        g++ \
        git \
        flex \
        bison \
        gperf \
        ruby \
        perl \
        python \
    && apt-get clean \
    && rm -rf /tmp/* /var/lib/apt/lists/*

# Run as non-root user
RUN useradd --system --uid 72379 -m --shell /usr/sbin/nologin phantomjs
USER phantomjs

COPY \
  haproxy.cfg \
    /etc/haproxy/haproxy.cfg

COPY \
  entry_point.sh \
    /opt/bin/
RUN chmod +x /opt/bin/entry_point.sh

USER phantomjs

EXPOSE 8910

#ENTRYPOINT ["dumb-init"]
#CMD ["/opt/bin/entry_point.sh"]

ENTRYPOINT [ "sh", "-c", "/opt/bin/entry_point.sh"]

