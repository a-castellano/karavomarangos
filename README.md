# Karavomarangos (καραβομαραγκός)

<p align="center">
  <img src="logo.png" alt="Karavomarangos logo" />
</p>

**Karavomarangos** — from the Greek _καραβομαραγκός_ (_karavomarangos_), meaning _ship carpenter_ or _shipwright_ — is a tool for managing and rendering Docker images used by the [Limani](https://github.com/a-castellano/limani) project.

Limani hosts Docker manifests for images used across several personal projects. Karavomarangos lets you define those images in a single, parseable format (JSON in this case), render Dockerfiles and related assets, and detect when newer package versions are available.

---

## Features

- **Declarative image definitions** in a parseable format — JSON in this case:

  - **Parent image** — base image to extend
  - **Repositories** — list of APT (or other) repositories added by the image
  - **GPG keys** — keys used to trust those repositories
  - **Packages** — list of packages to install, including **pinned versions** for reproducibility

- **Rendering** of Docker images (Dockerfiles and any supporting files) for the Limani project.

- **New-version detection** — automatically detect when newer versions of the declared packages are available (e.g. from the configured repositories).

- **README generation** — produce a README (or similar docs) alongside each rendered image so each image is self-documented.

_Future:_ rendering of GitLab CI configuration (e.g. `.gitlab-ci.yml`) for Limani may be added later.

---

## Use cases

1. **Single source of truth** — Define each Limani image once (parent, repos, keys, packages with versions) and generate Dockerfiles from that definition.
2. **Reproducibility** — Version pinning in the definition file ensures consistent, reproducible builds.
3. **Maintenance** — Run the tool to see which packages have newer versions and update definitions as needed.
4. **Documentation** — Auto-generate READMEs next to each image so users and CI know what each image contains.

---

## Usage

_(To be filled once the workflow is defined.)_

This tool should be able to be run in “check” or “detect” mode to compare the versions in image definition files against the latest versions available in the configured repositories, and report (or optionally update) when newer versions exist.

---

## Relationship to Limani

- **Limani**: [github.com/a-castellano/limani](https://github.com/a-castellano/limani) — Docker manifests and Dockerfiles for base images (e.g. Ubuntu 24.04, Windmaker repos, various stacks like Caddy, Nginx, PHP-FPM, Percona, RabbitMQ, etc.).
- **Karavomarangos**: Consumes declarative image definitions in a parseable format (JSON in this case), renders Dockerfiles and READMEs for Limani, and helps detect new package versions. It does not replace Limani’s repo; it feeds it with generated content and metadata.

---

## Name

_Καραβομαραγκός_ (_karavomarangos_) comes from Greek _καράβι_ (ship) + _μαραγκός_ (carpenter): _ship carpenter_ or _shipwright_. Like a shipwright who builds and maintains vessels, this tool helps build and maintain the “vessels” — Docker images — used by Limani.

---

## License

This project is licensed under the same terms as [Limani](https://github.com/a-castellano/limani): the **GNU General Public License v3.0** (GPL-3.0). See [LICENSE](LICENSE) for the full text.
