# base_percona_server

[![Docker image](https://img.shields.io/badge/docker-latest-blue.svg)](https://harbor.windmaker.net/harbor/projects/2/repositories/base_percona_server)

Percona Server (MySQL) image based on Limani base. Root password and auth plugin configured via debconf.


Packages installed:
- percona-telemetry-agent (1.0.7-1.noble)
- daedalus-project-mysql-utils (0.4-7)
- percona-server-server (8.4.7-7-1.noble)

Additional features:
- Port 3306 exposed
- Runs as mysql user
- Telemetry disabled via build env