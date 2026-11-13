# Dockerfile generated using karavomarangos - https://git.windmaker.net/a-castellano/karavomarangos
ARG BASE_IMAGE=harbor.windmaker.net/limani/base_docker
FROM $BASE_IMAGE

MAINTAINER Álvaro Castellano Vela <alvaro@windmaker.net>

COPY argbash /usr/local/bin/argbash

RUN \
  apt-get update -qq && \
  apt-get install -qq -o=Dpkg::Use-Pty=0 -y \
    gpg=2.4.8-4ubuntu3.1 \
    jsonschema-jv=5.3.1-2build1 \
    gnupg=2.4.8-4ubuntu3.1 \
    moreutils=0.69-1build1 \
    shunit2=2.1.8-4build1 \
    make=4.4.1-3 \
    wget=1.25.0-2ubuntu4.4 \
    jq=1.8.1-4ubuntu2 \
    ca-certificates=20260816ubuntu0.26.04.2 \
    --no-install-recommends && \
  apt-get purge -qq -o=Dpkg::Use-Pty=0 -y    && \
  apt-get autoremove -qq -o=Dpkg::Use-Pty=0 -y && \
  apt-get autoclean -qq -o=Dpkg::Use-Pty=0 -y && \
  rm -rf /var/lib/apt/lists/* && \
  wget https://github.com/hairyhenderson/gomplate/releases/download/v5.3.1/gomplate_linux-amd64 -O /usr/local/bin/gomplate && \
  chmod +x /usr/local/bin/gomplate && \
  chmod +x /usr/local/bin/argbash 
