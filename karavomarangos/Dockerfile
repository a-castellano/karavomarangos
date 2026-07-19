# Dockerfile generated using karavomarangos - https://git.windmaker.net/a-castellano/karavomarangos
ARG BASE_IMAGE=harbor.windmaker.net/limani/base
FROM $BASE_IMAGE

MAINTAINER Álvaro Castellano Vela <alvaro@windmaker.net>

COPY argbash /usr/local/bin/argbash
COPY karavomarangos.sh /usr/local/bin/karavomarangos
COPY templates/Dockerfile.tmpl /etc/karavomarangos/Dockerfile.tmpl
COPY templates/README.tmpl /etc/karavomarangos/README.tmpl
COPY schema.json /etc/karavomarangos/schema.json

RUN \
  apt-get update -qq && \
  apt-get install -qq -o=Dpkg::Use-Pty=0 -y \
    gpg=2.4.4-2ubuntu17.4 \
    gnupg=2.4.4-2ubuntu17.4 \
    containerd.io=2.2.3-1~ubuntu.24.04~noble \
    docker-ce=5:29.4.1-1~ubuntu.24.04~noble \
    python3-jsonschema=4.10.3-2ubuntu1 \
    moreutils=0.69-1 \
    wget=1.21.4-1ubuntu4.3 \
    jq=1.7.1-3ubuntu0.24.04.2 \
    docker-ce-cli=5:29.4.1-1~ubuntu.24.04~noble \
    ca-certificates=20260601~24.04.1 \
    --no-install-recommends && \
  apt-get purge -qq -o=Dpkg::Use-Pty=0 -y gnupg   && \
  apt-get autoremove -qq -o=Dpkg::Use-Pty=0 -y && \
  apt-get autoclean -qq -o=Dpkg::Use-Pty=0 -y && \
  rm -rf /var/lib/apt/lists/* && \
  wget https://github.com/hairyhenderson/gomplate/releases/download/v5.0.0/gomplate_linux-amd64 -O /usr/local/bin/gomplate && \
  chmod +x /usr/local/bin/gomplate && \
  chmod +x /usr/local/bin/argbash && \
  chmod +x /usr/local/bin/karavomarangos 
