ARG BASE_IMAGE=harbor.windmaker.net/limani/base
FROM ${BASE_IMAGE}

MAINTAINER Álvaro Castellano Vela <alvaro@windmaker.net>

RUN \
  apt-get update -qq && \
  apt-get install -qq -o=Dpkg::Use-Pty=0 -y --no-install-recommends \
    python3-jsonschema=4.10.3-2ubuntu1 \
    shunit2=2.1.8-4 \
    && \
    apt-get purge -y --auto-remove && \
    rm -rf /var/lib/apt/lists/*
