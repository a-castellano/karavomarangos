ARG BASE_IMAGE=harbor.windmaker.net/limani/base_docker
FROM ${BASE_IMAGE}

MAINTAINER Álvaro Castellano Vela <alvaro@windmaker.net>

RUN \
  apt-get update -qq && \
  apt-get install -qq -o=Dpkg::Use-Pty=0 -y --no-install-recommends \
    python3-jsonschema=4.10.3-2ubuntu1 \
    shunit2=2.1.8-4 \
    jq=1.7.1-3ubuntu0.24.04.1 \
    moreutils=0.69-1 \
    && \
    apt-get purge -y --auto-remove && \
    rm -rf /var/lib/apt/lists/*
