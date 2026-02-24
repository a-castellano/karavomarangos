# Karavomarangos (καραβομαραγκός)

<p align="center">
  <img src="logo.png" alt="Karavomarangos logo" />
</p>

**Repository:** [git.windmaker.net/a-castellano/karavomarangos](https://git.windmaker.net/a-castellano/karavomarangos)

**Karavomarangos** — from the Greek _καραβομαραγκός_ (_karavomarangos_), meaning _ship carpenter_ or _shipwright_ — is a tool for managing and rendering Docker images used by the [Limani](https://github.com/a-castellano/limani) project.

Limani hosts Docker manifests for images used across several personal projects. Karavomarangos lets you define those images in a single, parseable format (JSON in this case), render Dockerfiles and related assets, and detect when newer package versions are available.

## Contents

- [Features](#features)
- [Use cases](#use-cases)
- [Usage](#usage)
- [CI/CD](#cicd)
  - [Docker Image for CI](#docker-image-for-ci)
- [License](#license)

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
4. **Documentation** — Auto-generate READMEs next to each image so users know what each image contains.

---

## Usage

_(To be filled once the workflow is defined.)_

This tool should be able to be run in “check” or “detect” mode to compare the versions in image definition files against the latest versions available in the configured repositories, and report (or optionally update) when newer versions exist.

---

## CI/CD

### Docker Image for CI

The project builds a Docker image in GitLab CI and pushes it to the [Windmaker Registry](https://harbor.windmaker.net) as `harbor.windmaker.net/karavomarangos/karavomarangos_ci`. That image is the one used to run tests for the tool in CI.

#### What the image is

- **Base:** `harbor.windmaker.net/limani/base` (`base` image from Limani, hosted on the [Windmaker Registry](https://harbor.windmaker.net)).
- **Additions:**
  - Python 3 and `python3-jsonschema` (pinned version) so the tool can run inside CI.
  - shunit2 (pinned version) for CI.

Dockerfile: `karavomarangos_ci/Dockerfile`.

#### When it is built

The image is built only on branches whose name matches the pattern `ci` or `ci-*` / `ci_*` (e.g. `ci`, `ci-render`, `ci_check`). The job runs in the `build_ci_image` stage: it builds the image and pushes it to the Windmaker Registry using the `docker-build` helper from the Limani `base_docker` image.

#### Credentials and git-crypt

The repository uses [git-crypt](https://github.com/AGWA/git-crypt) to keep sensitive files out of the repo in encrypted form. The files that CI needs to push the image (e.g. Windmaker Registry credentials or config) live in encrypted config (such as `config/common.env` and `config/ci.env`). In CI, the pipeline unlocks the repo with the key provided in the `GIT_CRYPT_KEY_B64` variable, then sources those configs before building and pushing.

---

## License

This project is licensed under the same terms as [Limani](https://github.com/a-castellano/limani): the **GNU General Public License v3.0** (GPL-3.0). See [LICENSE](LICENSE) for the full text.
