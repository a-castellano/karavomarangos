# karavomarangos

[![Docker image](https://img.shields.io/badge/docker-latest-blue.svg)](https://harbor.windmaker.net/harbor/projects/2/repositories/karavomarangos)

Karavomarangos release image: the tool itself with docker, jq, jsonschema-jv, moreutils, gnupg, gomplate, and argbash on top of Limani base.


Packages installed:
- gpg (2.4.8-4ubuntu3.1)
- jsonschema-jv (5.3.1-2build1)
- gnupg (2.4.8-4ubuntu3.1)
- containerd.io (2.3.4-1~ubuntu.26.04~resolute)
- docker-ce (5:29.7.2-1~ubuntu.26.04~resolute)
- moreutils (0.69-1build1)
- wget (1.25.0-2ubuntu4.4)
- jq (1.8.1-4ubuntu2)
- docker-ce-cli (5:29.7.2-1~ubuntu.26.04~resolute)
- ca-certificates (20260816ubuntu0.26.04.2)

Additional features:
- karavomarangos installed as /usr/local/bin/karavomarangos
- Templates and schema installed under /etc/karavomarangos
- Gomplate v5.3.1 installed with wget after package install
- argbash copied from build context to /usr/local/bin/argbash