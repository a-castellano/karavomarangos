ARG BASE_IMAGE=harbor.windmaker.net/limani/base_docker
FROM ${BASE_IMAGE}

MAINTAINER Álvaro Castellano Vela <alvaro@windmaker.net>

COPY /tmp/argbash-2.11.0/bin/argbash /usr/local/bin/argbash

RUN \
  apt-get update -qq && \
  apt-get install -qq -o=Dpkg::Use-Pty=0 -y --no-install-recommends \
    python3-jsonschema=4.10.3-2ubuntu1 \
    shunit2=2.1.8-4 \
    jq=1.7.1-3ubuntu0.24.04.1 \
    moreutils=0.69-1 \
    make=4.3-4.1build2 \
    gnupg=2.4.4-2ubuntu17.4 \
    ca-certificates=20240203 \
    wget=1.21.4-1ubuntu4.1 \
    && \
    wget https://github.com/hairyhenderson/gomplate/releases/download/v5.0.0/gomplate_linux-amd64 -O /usr/local/bin/gomplate && \
    chmod +x /usr/local/bin/gomplate && \
    chmod +x /usr/local/bin/argbash && \
    apt-get purge -y --auto-remove && \
    rm -rf /var/lib/apt/lists/*
