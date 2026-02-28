# Karavomarangos (καραβομαραγκός)

<p align="center">
  <img src="logo.png" alt="Karavomarangos logo" />
</p>

**Repository:** [git.windmaker.net/a-castellano/karavomarangos](https://git.windmaker.net/a-castellano/karavomarangos)

**Karavomarangos** — from the Greek _καραβομαραγκός_ (_karavomarangos_), meaning _ship carpenter_ or _shipwright_ — is a tool for managing and rendering Docker images used by the [Limani](https://git.windmaker.net/a-castellano/limani) project.

Limani hosts Docker manifests for images used across several personal projects. Karavomarangos lets you define those images in a single, parseable format (JSON in this case), render Dockerfiles and related assets, and detect when newer package versions are available.

[![pipeline status](https://git.windmaker.net/a-castellano/karavomarangos/badges/main/pipeline.svg)](https://git.windmaker.net/a-castellano/karavomarangos/-/commits/main)
[![Latest Release](https://git.windmaker.net/a-castellano/karavomarangos/-/badges/release.svg)](https://git.windmaker.net/a-castellano/karavomarangos/-/releases)

## Contents

- [Features](#features)
- [Use cases](#use-cases)
- [Usage](#usage)
- [Image definition schema](#image-definition-schema)
- [Example](#example)
- [CI/CD](#cicd)
  - [Docker Image for CI](#docker-image-for-ci)
  - [Tests](#tests)
  - [Docker and local testing](#docker-and-local-testing)
- [Libraries, programs, and build](#libraries-programs-and-build)
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

## Image definition schema

Image definitions are JSON files validated against the schema in [`schema.json`](schema.json). Each JSON file will describe a Docker image: what it is based on, who maintains it, and what it adds (repos, packages, runtime options). Image properties are the needed by Limani project requisites.

### Required fields

| Field             | Type   | Required | Description                                                                 |
| ----------------- | ------ | -------- | --------------------------------------------------------------------------- |
| **`name`**        | string | yes      | Image name. Lowercase letters and numbers with underscores only.            |
| **`base_image`**  | string | yes      | Parent image to extend (e.g. `ubuntu:24.04` or `harbor.windmaker.net/limani/base`). |
| **`maintainer`** | object | yes      | Maintainer of the image. See **maintainer** below.                         |

#### maintainer

| Field          | Type   | Required | Description              |
| -------------- | ------ | -------- | ------------------------ |
| **`name`**     | string | yes      | Maintainer first name.   |
| **`surname`**  | string | yes      | Maintainer surname.      |
| **`email`**   | string | yes      | Maintainer email.       |

### Optional fields

| Field                             | Type   | Description                                              |
| --------------------------------- | ------ | -------------------------------------------------------- |
| **`required_repositories`**       | object | Extra APT repositories. See **required_repositories** below. |
| **`packages`**                    | array  | Packages to install. See **packages** (item) below.       |
| **`extra_commands`**              | array  | Shell commands run after package install (array of strings). |
| **`user`**                        | string | User to run as in the image.                              |
| **`environment_variables`**       | array  | Runtime env vars. See **environment_variables** (item) below. |
| **`exposed_ports`**               | array  | Ports to expose (integers 1–65535).                       |
| **`command`**                     | array  | Default command when the container starts (array of strings). |
| **`build_environment_variables`** | array  | Env vars during image build. See **build_environment_variables** (item) below. |
| **`debconf_selections`**          | array  | Debconf entries during build. See **debconf_selections** (item) below. |

#### required_repositories

| Field             | Type   | Required | Description                              |
| ----------------- | ------ | -------- | ---------------------------------------- |
| **`name`**        | string | no       | Name of the repository.                   |
| **`apt_lines`**   | array  | yes      | APT source lines (array of strings).      |
| **`gpg_keyring`** | object | no       | GPG keyring for verification. See **gpg_keyring** below. |

#### required_repositories → gpg_keyring

| Field       | Type   | Required | Description                                    |
| ----------- | ------ | -------- | ---------------------------------------------- |
| **`name`**  | string | yes      | Name of the GPG keyring file.                   |
| **`content`** | object | yes    | Where the key is retrieved from. See **content** below. |

#### gpg_keyring → content

| Field     | Type   | Required | Description                                      |
| --------- | ------ | -------- | ------------------------------------------------ |
| **`type`** | string | yes      | How the key is provided: `"url"` or `"key"`.     |
| **`data`** | array  | yes      | URLs or key material (array of strings).         |

#### packages (array item)

| Field        | Type   | Required | Description                    |
| ------------ | ------ | -------- | ------------------------------ |
| **`name`**   | string | yes      | Package name.                  |
| **`version`** | string | no     | Package version (can be ignored). |

#### environment_variables (array item)

| Field       | Type   | Required | Description   |
| ----------- | ------ | -------- | ------------- |
| **`name`**  | string | yes      | Variable name. |
| **`value`** | string | yes      | Variable value. |

#### build_environment_variables (array item)

| Field       | Type   | Required | Description   |
| ----------- | ------ | -------- | ------------- |
| **`name`**  | string | yes      | Variable name. |
| **`value`** | string | yes      | Variable value. |

#### debconf_selections (array item)

| Field         | Type   | Required | Description        |
| ------------- | ------ | -------- | ------------------ |
| **`package`** | string | yes      | Package concerned.  |
| **`question`** | string | yes    | Debconf question.  |
| **`type`**    | string | yes      | Type of response.  |
| **`value`**   | string | yes      | Selection value.    |

The schema does not allow extra properties: only the fields above are accepted.

---

## Example

_(This section is not yet documented. Real examples will be added later.)_

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

### Tests

The **tests** stage runs the job `validate_json_files`: it uses the CI image above and executes `tests/validate_examples_test.sh`. That script (shunit2) validates every JSON file under `examples/valid_examples/` against `schema.json`; the pipeline fails if any example does not conform to the schema.

### Docker and local testing

The tool needs Docker (e.g. to build or run images). In CI, the GitLab runners mount the Docker socket, so jobs can run Docker inside the CI container (Docker-in-Docker).

To run the same kind of environment locally with **Podman** (Docker-compatible socket):

1. **Enable the Podman user socket:**
   ```bash
   systemctl --user enable --now podman.socket
   ```

2. **Check that the socket exists**, e.g.:
   ```text
   srw-rw---- 1 user users 0 feb 26 21:19 /run/user/1000/podman/podman.sock
   ```

3. **Run the CI image with the socket and project mounted** so that `docker` inside the container talks to your Podman:
   ```bash
   podman run --rm -it \
     -v $XDG_RUNTIME_DIR/podman/podman.sock:/var/run/docker.sock \
     -v ~/Projects/karavomarangos:/karavomarangos \
     harbor.windmaker.net/karavomarangos/karavomarangos_ci \
     /bin/bash
   ```
   Then run your tests or commands inside that container (e.g. from `/karavomarangos`).

**Note:** When you run `docker` (or `podman`) inside that container, you see the host’s containers (e.g. `docker ps` will list the current container and any others). Keep that in mind when interpreting test or tool output.

---

## Libraries, programs, and build

### Structure

- **`lib/`** — Reusable Bash libraries (sourced by the programs). Each file provides a set of functions; the numeric prefix defines load order when sourced:
  - `01-log.sh`: logging (`write_log`)
  - `02-containers.sh`: container lifecycle and commands (e.g. `retrieve_base_image`, `create_container`, `start_container`, `run_command_in_container`, `stop_container`, `remove_container`)
  - `03-packages.sh`: package parsing and list handling (e.g. `parse_packages`, `update_packages_list`, `update_json_file`)
  - `04-repos.sh`: repository and GPG key handling (e.g. `check_repos`, `add_gpg_keys`, `add_repositories`, `update_container_apt_cache`)

- **`src/`** — Entry-point scripts (programs). Each script sources the needed `lib/*.sh` files and implements a single workflow. Example: `src/json_updater.sh` validates a JSON image definition, runs a container from the base image, updates package lists and GPG/repos inside it, and writes updated package versions back into the JSON file.

### Build process (Makefile)

Running `make` (or `make build`) produces a **single, self-contained executable** per program:

1. **Copy** `lib/` to a temporary `clean_lib/`.
2. **Strip** from each file in `clean_lib/` comment-only lines and any `source ...` lines (so inlined code has no comments or source directives).
3. **Inline** libraries into the program: for each `source lib/XX` in the program (e.g. `src/json_updater.sh`), replace that line with the contents of the corresponding file in `clean_lib/`.
4. **Write** the result to the program name (e.g. `karavomarangos-json-updater`), set executable bit, then remove `clean_lib/`.

The output is one standalone script with no external `source` calls: all library code is embedded. Install with `make install` (installs to `$(DESTDIR)$(prefix)/bin`, default `/usr/local/bin`).

---

## License

This project is licensed under the same terms as [Limani](https://git.windmaker.net/a-castellano/limani): the **GNU General Public License v3.0** (GPL-3.0). See [LICENSE](LICENSE) for the full text.
