# karavomarangos

[![Docker image](https://img.shields.io/badge/docker-latest-blue.svg)](https://harbor.windmaker.net/harbor/projects/2/repositories/karavomarangos)

Karavomarangos release image: the tool itself with docker, jq, jsonschema, moreutils, gnupg, gomplate, and argbash on top of Limani base.


Packages installed:
- gpg (2.4.4-2ubuntu17.4)
- gnupg (2.4.4-2ubuntu17.4)
- containerd.io (2.2.3-1~ubuntu.24.04~noble)
- docker-ce (5:29.4.1-1~ubuntu.24.04~noble)
- python3-jsonschema (4.10.3-2ubuntu1)
- moreutils (0.69-1)
- wget (1.21.4-1ubuntu4.3)
- jq (1.7.1-3ubuntu0.24.04.2)
- docker-ce-cli (5:29.4.1-1~ubuntu.24.04~noble)
- ca-certificates (20260601~24.04.1)

Additional features:
- karavomarangos installed as /usr/local/bin/karavomarangos
- Templates and schema installed under /etc/karavomarangos
- Gomplate v5.0.0 installed with wget after package install
- argbash copied from build context to /usr/local/bin/argbash