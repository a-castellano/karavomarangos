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
  apt-get install -qq -o=Dpkg::Use-Pty=0 -y gnupg ca-certificates wget --no-install-recommends && \
  wget -qO- http://packages.windmaker.net/WINDMAKER-GPG-KEY.pub >> /etc/apt/keyrings/windmaker.gpg && \
  echo "Types: deb " > /etc/apt/sources.list.d/docker.sources && \
  echo "URIs: http://packages.windmaker.net/docker " >> /etc/apt/sources.list.d/docker.sources && \
  echo "Suites: resolute " >> /etc/apt/sources.list.d/docker.sources && \
  echo "Components: main " >> /etc/apt/sources.list.d/docker.sources && \
  echo "Architectures: amd64 " >> /etc/apt/sources.list.d/docker.sources && \
  echo "Signed-By: /etc/apt/keyrings/windmaker.gpg" >> /etc/apt/sources.list.d/docker.sources && \
  apt-get update -qq && \
  apt-get install -qq -o=Dpkg::Use-Pty=0 -y \
    gpg=2.4.8-4ubuntu3.1 \
    jsonschema-jv=5.3.1-2build1 \
    gnupg=2.4.8-4ubuntu3.1 \
    containerd.io=2.3.4-1~ubuntu.26.04~resolute \
    docker-ce=5:29.7.2-1~ubuntu.26.04~resolute \
    moreutils=0.69-1build1 \
    wget=1.25.0-2ubuntu4.4 \
    jq=1.8.1-4ubuntu2 \
    docker-ce-cli=5:29.7.2-1~ubuntu.26.04~resolute \
    ca-certificates=20260816ubuntu0.26.04.2 \
    --no-install-recommends && \
  apt-get purge -qq -o=Dpkg::Use-Pty=0 -y    && \
  apt-get autoremove -qq -o=Dpkg::Use-Pty=0 -y && \
  apt-get autoclean -qq -o=Dpkg::Use-Pty=0 -y && \
  rm -rf /var/lib/apt/lists/* && \
  wget https://github.com/hairyhenderson/gomplate/releases/download/v5.3.1/gomplate_linux-amd64 -O /usr/local/bin/gomplate && \
  chmod +x /usr/local/bin/gomplate && \
  chmod +x /usr/local/bin/argbash && \
  chmod +x /usr/local/bin/karavomarangos 
