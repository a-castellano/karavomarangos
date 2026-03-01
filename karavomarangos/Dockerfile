ARG BASE_IMAGE=harbor.windmaker.net/limani/base
FROM ${BASE_IMAGE}

MAINTAINER Álvaro Castellano Vela <alvaro@windmaker.net>

COPY argbash /usr/local/bin/argbash
COPY karavomarangos.sh /usr/local/bin/karavomarangos 
COPY templates/Dockerfile.tmpl /tmp/Dockerfile.tmpl
COPY templates/README.tmpl /tmp/README.tmpl
COPY schema.json /tmp/schema.json

RUN \
  apt-get update -qq && \
  apt-get install -qq -o=Dpkg::Use-Pty=0 -y --no-install-recommends \
    docker-ce=5:28.3.2-1~ubuntu.24.04~noble \
    docker-ce-cli=5:28.3.2-1~ubuntu.24.04~noble \
    containerd.io=1.7.27-1 \
    python3-jsonschema=4.10.3-2ubuntu1 \
    moreutils=0.69-1 \
    gnupg=2.4.4-2ubuntu17.4 \
    ca-certificates=20240203 \
    wget=1.21.4-1ubuntu4.1 \
    && \
    wget https://github.com/hairyhenderson/gomplate/releases/download/v5.0.0/gomplate_linux-amd64 -O /usr/local/bin/gomplate && \
    chmod +x /usr/local/bin/gomplate && \
    chmod +x /usr/local/bin/argbash && \
    mkdir /etc/karavomarangos && \
    mv /tmp/schema.json /etc/karavomarangos/schema.json && \
    mv /tmp/Dockerfile.tmpl /etc/karavomarangos/Dockerfile.tmpl && \
    mv /tmp/README.tmpl /etc/karavomarangos/README.tmpl && \
    apt-get purge -y --auto-remove && \
    rm -rf /var/lib/apt/lists/*
