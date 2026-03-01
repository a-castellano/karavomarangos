# Karavomarangos (καραβομαραγκός)

<p align="center">
  <img src="logo.png" alt="Karavomarangos logo" />
</p>

**Repository:** [git.windmaker.net/a-castellano/karavomarangos](https://git.windmaker.net/a-castellano/karavomarangos)

**Karavomarangos** — from the Greek _καραβομαραγκός_ (_karavomarangos_), meaning _ship carpenter_ or _shipwright_ — is a tool for managing and rendering Docker images used by the [Limani](https://git.windmaker.net/a-castellano/limani) project.

This project generates Dockerfiles and READMEs from a JSON file that defines the image; it also updates package versions in that same JSON, making it easier to keep [Limani](https://git.windmaker.net/a-castellano/limani) (or any other project) images up to date.

[![pipeline status](https://git.windmaker.net/a-castellano/karavomarangos/badges/main/pipeline.svg)](https://git.windmaker.net/a-castellano/karavomarangos/-/commits/main)
[![Latest Release](https://git.windmaker.net/a-castellano/karavomarangos/-/badges/release.svg)](https://git.windmaker.net/a-castellano/karavomarangos/-/releases)

## Contents

- [Usage](#usage)
  - [Option 1: Docker image (recommended)](#option-1-docker-image-recommended)
  - [Option 2: Local install](#option-2-local-install)
  - [Invocation](#invocation)
  - [Environment variables](#environment-variables)
- [Image definition schema](#image-definition-schema)
  - [Required fields](#required-fields)
  - [Optional fields](#optional-fields)
- [Example](#example)
  - [Example commands](#example-commands)
  - [Example JSON definition](#example-json-definition)
  - [Example generated Dockerfile](#example-generated-dockerfile)
  - [Example generated README](#example-generated-readme)
- [CI/CD](#cicd)
  - [Docker Image for CI](#docker-image-for-ci)
  - [Tests](#tests)
  - [Docker and local testing](#docker-and-local-testing)
- [Libraries, programs, and build](#libraries-programs-and-build)
  - [Structure](#structure)
  - [Argument parsing (argbash)](#argument-parsing-argbash)
  - [Build process (Makefile)](#build-process-makefile)
- [License](#license)

---

## Usage

There are two ways to use this project: **run the project’s Docker image** (recommended) or **install the tool and its dependencies locally**.

### Option 1: Docker image (recommended)

Use the image `harbor.windmaker.net/karavomarangos/karavomarangos`. Bind the directory where you want to update Docker images (e.g. your Limani checkout) so you can run the tool inside the container against that path.

**1. Enable the Podman user socket** (so the container can use the host’s Docker/Podman):

```bash
systemctl --user enable --now podman.socket
```

**2. Check that the socket exists**, e.g.:

```text
/run/user/<uid>/podman/podman.sock
```

(`$XDG_RUNTIME_DIR` is set by the session; typically `$XDG_RUNTIME_DIR/podman/podman.sock` is the socket path.)

**3. Run the image** with that socket and your project directory mounted:

```bash
podman run --rm -it \
  -v $XDG_RUNTIME_DIR/podman/podman.sock:/var/run/docker.sock \
  -v ~/Projects/limani:/limani \
  harbor.windmaker.net/karavomarangos/karavomarangos \
  /bin/bash
```

Then run `karavomarangos` inside the container (e.g. from `/limani` or the path where your JSON definitions live).

### Option 2: Local install

To run the tool on the host without the Docker image, install the dependencies and then build and install the program.

**Dependencies:**

- **Docker or Podman** — the tool runs a temporary container to resolve package versions.
- **jq** — JSON handling.
- **Python 3** and **python3-jsonschema** — JSON schema validation.
- **moreutils**, **gnupg**, **ca-certificates**, **wget**, **gpg** — used during repo/package resolution.
- **[gomplate](https://docs.gomplate.ca/installing/)** — renders Dockerfile and README from templates.
- **[argbash](https://argbash.readthedocs.io/en/latest/install.html)** — CLI parsing (needed to regenerate `lib/05-argbash.sh` from `lib/05-argbash.m4` when changing options).

**Build and install:**

```bash
make
sudo make install
```

This installs the `karavomarangos` binary under `/usr/local/bin` (by default) and the schema/templates under `/etc/karavomarangos/`. For a custom prefix or config path, see the [Makefile](Makefile) variables.

### Invocation

The `karavomarangos` command runs **inside the Docker container** (Option 1) or **on the host** (Option 2), depending on how you chose to use the project:

```bash
karavomarangos --json-file=<path> [options]
```

**Required:**

| Option                   | Description                                                                                                       |
| ------------------------ | ----------------------------------------------------------------------------------------------------------------- |
| **`--json-file=<path>`** | Path to the JSON image definition file (must conform to the [image definition schema](#image-definition-schema)). |

**Optional (defaults in parentheses):**

| Option                                                   | Description                                                           |
| -------------------------------------------------------- | --------------------------------------------------------------------- |
| **`--update-packages`** / **`--no-update-packages`**     | Update package versions in the JSON from the container (default: on). |
| **`--update-dockerfile`** / **`--no-update-dockerfile`** | Render the Dockerfile (default: on).                                  |
| **`--dockerfile-output=<path>`**                         | Where to write the Dockerfile (default: `Dockerfile`).                |
| **`--update-readme`** / **`--no-update-readme`**         | Render the image README (default: on).                                |
| **`--readme-output=<path>`**                             | Where to write the README (default: `README.md`).                     |
| **`--help`**                                             | Print usage and exit.                                                 |

### Environment variables

When running **locally**, the script uses these variables when set; otherwise it uses the defaults below (suitable for an installed deployment under `/etc/karavomarangos/`).

| Variable              | Default                               | Description                               |
| --------------------- | ------------------------------------- | ----------------------------------------- |
| **`JSON_SCHEMA`**     | `/etc/karavomarangos/schema.json`     | Path to the JSON schema file.             |
| **`DOCKERFILE_TMPL`** | `/etc/karavomarangos/Dockerfile.tmpl` | Path to the Dockerfile gomplate template. |
| **`README_TMPL`**     | `/etc/karavomarangos/README.tmpl`     | Path to the README gomplate template.     |

For development or CI (e.g. from the repo without `make install`), set them to paths inside the repo. The file [`config/common.env`](config/common.env) does that so you can `source config/common.env` before running the script.

---

## Image definition schema

Image definitions are JSON files validated against the schema in [`schema.json`](schema.json). Each JSON file will describe a Docker image: what it is based on, who maintains it, and what it adds (repos, packages, runtime options). Image properties are the needed by Limani project requisites.

### Required fields

| Field            | Type   | Required | Description                                                                         |
| ---------------- | ------ | -------- | ----------------------------------------------------------------------------------- |
| **`name`**       | string | yes      | Image name. Lowercase letters and numbers with underscores only.                    |
| **`base_image`** | string | yes      | Parent image to extend (e.g. `ubuntu:24.04` or `harbor.windmaker.net/limani/base`). |
| **`maintainer`** | object | yes      | Maintainer of the image. See **maintainer** below.                                  |
| **`readme`**     | object | yes      | Readme content for the image. See **readme** below.                                 |

#### maintainer

| Field         | Type   | Required | Description            |
| ------------- | ------ | -------- | ---------------------- |
| **`name`**    | string | yes      | Maintainer first name. |
| **`surname`** | string | yes      | Maintainer surname.    |
| **`email`**   | string | yes      | Maintainer email.      |

#### readme

| Field                     | Type   | Required | Description                                                          |
| ------------------------- | ------ | -------- | -------------------------------------------------------------------- |
| **`description`**         | string | yes      | Short description of the image.                                      |
| **`additional_features`** | array  | yes      | List of strings for the “Additional features” section of the README. |

### Optional fields

| Field                             | Type   | Description                                                                    |
| --------------------------------- | ------ | ------------------------------------------------------------------------------ |
| **`required_repositories`**       | object | Extra APT repositories. See **required_repositories** below.                   |
| **`packages`**                    | array  | Packages to install. See **packages** (item) below.                            |
| **`extra_commands`**              | array  | Shell commands run after package install (array of strings).                   |
| **`user`**                        | string | User to run as in the image.                                                   |
| **`environment_variables`**       | array  | Runtime env vars. See **environment_variables** (item) below.                  |
| **`exposed_ports`**               | array  | Ports to expose (integers 1–65535).                                            |
| **`command`**                     | array  | Default command when the container starts (array of strings).                  |
| **`build_environment_variables`** | array  | Env vars during image build. See **build_environment_variables** (item) below. |
| **`debconf_selections`**          | array  | Debconf entries during build. See **debconf_selections** (item) below.         |
| **`copy`**                        | array  | Files to copy into the image. See **copy** (item) below.                       |

#### required_repositories

| Field             | Type   | Required | Description                                              |
| ----------------- | ------ | -------- | -------------------------------------------------------- |
| **`name`**        | string | no       | Name of the repository.                                  |
| **`apt_lines`**   | array  | yes      | APT source lines (array of strings).                     |
| **`gpg_keyring`** | object | no       | GPG keyring for verification. See **gpg_keyring** below. |

#### required_repositories → gpg_keyring

| Field         | Type   | Required | Description                                             |
| ------------- | ------ | -------- | ------------------------------------------------------- |
| **`name`**    | string | yes      | Name of the GPG keyring file.                           |
| **`content`** | object | yes      | Where the key is retrieved from. See **content** below. |

#### gpg_keyring → content

| Field      | Type   | Required | Description                                  |
| ---------- | ------ | -------- | -------------------------------------------- |
| **`type`** | string | yes      | How the key is provided: `"url"` or `"key"`. |
| **`data`** | array  | yes      | URLs or key material (array of strings).     |

#### packages (array item)

| Field         | Type   | Required | Description                       |
| ------------- | ------ | -------- | --------------------------------- |
| **`name`**    | string | yes      | Package name.                     |
| **`version`** | string | no       | Package version (can be ignored). |

#### environment_variables (array item)

| Field       | Type   | Required | Description     |
| ----------- | ------ | -------- | --------------- |
| **`name`**  | string | yes      | Variable name.  |
| **`value`** | string | yes      | Variable value. |

#### build_environment_variables (array item)

| Field       | Type   | Required | Description     |
| ----------- | ------ | -------- | --------------- |
| **`name`**  | string | yes      | Variable name.  |
| **`value`** | string | yes      | Variable value. |

#### debconf_selections (array item)

| Field          | Type   | Required | Description        |
| -------------- | ------ | -------- | ------------------ |
| **`package`**  | string | yes      | Package concerned. |
| **`question`** | string | yes      | Debconf question.  |
| **`type`**     | string | yes      | Type of response.  |
| **`value`**    | string | yes      | Selection value.   |

#### copy (array item)

| Field             | Type   | Required | Description                   |
| ----------------- | ------ | -------- | ----------------------------- |
| **`source`**      | string | yes      | Path of the source file.      |
| **`destination`** | string | yes      | Path of the destination file. |

The schema does not allow extra properties: only the fields above are accepted.

---

## Example

### Example commands

With the utility installed, run from the directory that contains your image definition JSON files (e.g. your Limani project):

```bash
karavomarangos --json-file=examples/valid_examples/minimum_valid_definition.json
```

This validates the JSON, (optionally) updates package versions inside a temporary container, and writes the Dockerfile and the image README to the current directory (default paths: `Dockerfile` and `README.md`).

Generate both Dockerfile and README with custom paths:

```bash
karavomarangos --json-file=examples/valid_examples/minimum_valid_definition.json \
  --update-readme --readme-output=./IMAGE_README.md --dockerfile-output=./Dockerfile.image
```

Only render assets without updating package versions in the JSON:

```bash
karavomarangos --json-file=examples/valid_examples/minimum_valid_definition.json \
  --no-update-packages
```

### Example JSON definition

The definition below (from [`examples/valid_examples/base_golang.json`](examples/valid_examples/base_golang.json)) is the input for the Dockerfile and README shown in the next sections.

```json
{
  "name": "base_golang_1_26",
  "base_image": "harbor.windmaker.net/limani/base_deb_builder",
  "maintainer": {
    "name": "Álvaro",
    "surname": "Castellano Vela",
    "email": "alvaro@windmaker.net"
  },
  "required_repositories": {
    "name": "golang",
    "gpg_keyring": {
      "name": "golang",
      "content": {
        "type": "key",
        "data": ["C631127F87FA12D1", "F6BC817356A3D45E"]
      }
    },
    "apt_lines": [
      "deb [signed-by=/etc/apt/keyrings/golang.gpg] https://ppa.launchpadcontent.net/longsleep/golang-backports/ubuntu/ noble main"
    ]
  },
  "packages": [
    { "name": "git", "version": "1:2.43.0-1ubuntu7.3" },
    { "name": "nfpm", "version": "2.43.0" },
    { "name": "golang-golang-x-sys-dev", "version": "0.17.0-1" },
    { "name": "sudo", "version": "1.9.15p5-3ubuntu5.24.04.1" },
    { "name": "golang-1.26", "version": "1.26.0-1longsleep1+jammy" },
    { "name": "make", "version": "4.3-4.1build2" },
    { "name": "clang", "version": "1:18.0-59~exp2" },
    { "name": "bind9-host", "version": "1:9.18.39-0ubuntu0.24.04.2" },
    { "name": "golang-1.26-go", "version": "changeme" },
    { "name": "ca-certificates", "version": "20240203" },
    { "name": "dh-golang", "version": "1.62" },
    { "name": "openssl", "version": "3.0.13-0ubuntu3.7" }
  ],
  "extra_commands": [
    "ln -s /usr/lib/go-1.26/bin/go /usr/bin/go",
    "echo -e \"DEBEMAIL=\\\"alvaro@windmaker.net\\\"\\nDEBFULLNAME=\\\"Álvaro Castellano Vela\\\"\\nexport DEBEMAIL DEBFULLNAME\\n\" >> ~/.bashrc.backup"
  ],
  "readme": {
    "description": "Golang 1.26 image with Debian packaging tools (dh-golang, nfpm, make, clang). Based on base_deb_builder.",
    "additional_features": [
      "Symlink for go binary and DEBEMAIL/DEBFULLNAME in bashrc",
      "Golang backports PPA and many pinned packages"
    ]
  }
}
```

### Example generated Dockerfile

The following is the Dockerfile generated from the JSON above (default output: `Dockerfile`).

```dockerfile
# Dockerfile generated using karavomarangos - https://git.windmaker.net/a-castellano/karavomarangos
ARG BASE_IMAGE=harbor.windmaker.net/limani/base_deb_builder
FROM $BASE_IMAGE

MAINTAINER Álvaro Castellano Vela <alvaro@windmaker.net>

RUN \
  apt-get update -qq && \
  apt-get install -qq -o=Dpkg::Use-Pty=0 -y gnupg ca-certificates wget --no-install-recommends && \
  gpg --keyserver keyserver.ubuntu.com --recv-keys C631127F87FA12D1 && \
  gpg --keyserver keyserver.ubuntu.com --recv-keys F6BC817356A3D45E && \
  gpg --export C631127F87FA12D1 F6BC817356A3D45E | gpg --dearmor > /etc/apt/keyrings/golang.gpg && \
  echo "deb [signed-by=/etc/apt/keyrings/golang.gpg] https://ppa.launchpadcontent.net/longsleep/golang-backports/ubuntu/ noble main" >> /etc/apt/sources.list.d/golang.list && \
  apt-get update -qq && \
  apt-get install -qq -o=Dpkg::Use-Pty=0 -y \
    git=1:2.43.0-1ubuntu7.3 \
    nfpm=2.43.0 \
    golang-golang-x-sys-dev=0.17.0-1 \
    sudo=1.9.15p5-3ubuntu5.24.04.1 \
    golang-1.26=1.26.0-1longsleep1+jammy \
    make=4.3-4.1build2 \
    clang=1:18.0-59~exp2 \
    bind9-host=1:9.18.39-0ubuntu0.24.04.2 \
    golang-1.26-go=changeme \
    ca-certificates=20240203 \
    dh-golang=1.62 \
    openssl=3.0.13-0ubuntu3.7 \
    --no-install-recommends && \
  apt-get purge -qq -o=Dpkg::Use-Pty=0 -y gnupg wget && \
  apt-get autoremove -qq -o=Dpkg::Use-Pty=0 -y && \
  apt-get autoclean -qq -o=Dpkg::Use-Pty=0 -y && \
  rm -rf /var/lib/apt/lists/* && \
  ln -s /usr/lib/go-1.26/bin/go /usr/bin/go && \
  echo -e "DEBEMAIL=\"alvaro@windmaker.net\"\nDEBFULLNAME=\"Álvaro Castellano Vela\"\nexport DEBEMAIL DEBFULLNAME\n" >> ~/.bashrc.backup
```

### Example generated README

With `--update-readme` (default on), the tool renders a README from the same JSON. Example output:

```markdown
# base_golang_1_26

[![Docker image](https://img.shields.io/badge/docker-latest-blue.svg)](https://harbor.windmaker.net/harbor/projects/2/repositories/base_golang_1_26)

Golang 1.26 image with Debian packaging tools (dh-golang, nfpm, make, clang). Based on base_deb_builder.

Packages installed:

- git (1:2.43.0-1ubuntu7.3)
- nfpm (2.43.0)
- golang-golang-x-sys-dev (0.17.0-1)
- sudo (1.9.15p5-3ubuntu5.24.04.1)
- golang-1.26 (1.26.0-1longsleep1+jammy)
- make (4.3-4.1build2)
- clang (1:18.0-59~exp2)
- bind9-host (1:9.18.39-0ubuntu0.24.04.2)
- golang-1.26-go (1.26.0-1longsleep1+jammy)
- ca-certificates (20240203)
- dh-golang (1.62)
- openssl (3.0.13-0ubuntu3.7)

Additional features:

- Symlink for go binary and DEBEMAIL/DEBFULLNAME in bashrc
- Golang backports PPA and many pinned packages
```

---

## CI/CD

### Docker Image for CI

The project builds a Docker image in GitLab CI and pushes it to the [Windmaker Registry](https://harbor.windmaker.net) as `harbor.windmaker.net/karavomarangos/karavomarangos_ci`. That image is used to run all CI jobs (tests, integration tests, build tests). Source: [`karavomarangos_ci/Dockerfile`](karavomarangos_ci/Dockerfile).

#### What the image is

- **Base:** `harbor.windmaker.net/limani/base_docker` (Limani’s Docker build image from the [Windmaker Registry](https://harbor.windmaker.net)).
- **Additions (on top of base_docker):**
  - **Python 3** and **python3-jsonschema** — JSON schema validation for the tool and tests.
  - **shunit2** — test runner for the shell test suite.
  - **jq**, **moreutils**, **make**, **gnupg**, **ca-certificates**, **wget** — used by the tool and tests.
  - **gomplate** — template rendering (downloaded binary).
  - **argbash** — CLI parsing (copied from the build context when the image is built in CI).

The image includes Docker and is used for all CI jobs. It works in CI because the GitLab runners are configured to allow Docker-in-Docker (running Docker inside the container).

#### When it is built

The image is built only on branches whose name matches the pattern `ci-*` or `ci_*` (e.g. `ci-render`, `ci_validate`). The job runs in the `build_ci_image` stage: it uses the image `harbor.windmaker.net/limani/base_docker`, unlocks git-crypt, sources `config/common.env` and `config/ci.env`, fetches argbash into the build context, then runs the `docker-build` helper (from Limani’s base_docker) to build and push `karavomarangos_ci` to the registry.

#### Credentials and git-crypt

The repository uses [git-crypt](https://github.com/AGWA/git-crypt) to keep sensitive files out of the repo in encrypted form. Config needed to push the image (e.g. Windmaker Registry credentials) lives in encrypted files such as `config/common.env` and `config/ci.env`. In CI, the pipeline unlocks the repo with the key in the `GIT_CRYPT_KEY_B64` variable, then sources those configs before building and pushing.

### Tests

CI runs several jobs using the image `harbor.windmaker.net/karavomarangos/karavomarangos_ci:latest`:

- **validate_json_files** — runs `tests/validate_examples_test.sh` (shunit2); validates every JSON under `examples/valid_examples/` against `schema.json`.
- **validate_package_libs**, **test_containers_lib** — unit tests for the library scripts.
- **test_package_version_retrieval_from_container** (integration) — package retrieval and list update, GPG/repo functions.
- **test_build** — runs `tests/validate_build.sh` to check that the tool builds correctly.

All of these jobs use the CI image; the ones that need Docker run it via Docker-in-Docker on the runner.

### Docker and local testing

The tool needs Docker (e.g. to build or run images). In CI, the GitLab runners are configured for Docker-in-Docker, so the CI image can run Docker inside the container.

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
  - `05-argbash.sh`: CLI argument parsing (generated from `05-argbash.m4`; see **Argument parsing (argbash)** below). Exposes the required option `--json-file` as `_arg_json_file`, plus option variables such as `_arg_update_packages`, `_arg_dockerfile_output`, etc.

- **`src/`** — Entry-point scripts (programs). Each script sources the needed `lib/*.sh` files and implements a single workflow. Example: `src/karavomarangos.sh` validates a JSON image definition, runs a container from the base image, updates package lists and GPG/repos inside it, writes updated package versions back into the JSON file, and can generate the Dockerfile.

### Argument parsing (argbash)

Command-line options are handled by [argbash](https://argbash.readthedocs.io/). The parsing code lives in **`lib/05-argbash.sh`**, which is **generated** from the template **`lib/05-argbash.m4`**. You must not edit `05-argbash.sh` by hand; any change would be overwritten the next time it is regenerated.

- **To change or add CLI options:** edit **`lib/05-argbash.m4`** (the ARG\_\* directives and ARG_HELP).
- **To regenerate** `lib/05-argbash.sh` from the template:
  - **Automatically:** run `make` or `make build`. The Makefile has a rule that regenerates `lib/05-argbash.sh` when `lib/05-argbash.m4` is newer.
  - **Manually:** run  
    `argbash lib/05-argbash.m4 -o lib/05-argbash.sh --strip user-content`  
    (requires argbash installed).

After regeneration, the script body in `src/karavomarangos.sh` is unchanged; it keeps using variables like `$_arg_json_file` set by the sourced parsing code.

### Build process (Makefile)

Running `make` (or `make build`) produces a **single, self-contained executable** per program:

1. **Regenerate** `lib/05-argbash.sh` from `lib/05-argbash.m4` if the template is newer (see **Argument parsing (argbash)** above).
2. **Copy** `lib/` to a temporary `clean_lib/`.
3. **Strip** from each file in `clean_lib/` comment-only lines and any `source ...` lines (so inlined code has no comments or source directives).
4. **Inline** libraries into the program: for each `source lib/XX` in the program (e.g. `src/karavomarangos.sh`), replace that line with the contents of the corresponding file in `clean_lib/`.
5. **Write** the result to the program name (e.g. `karavomarangos`), set executable bit, then remove `clean_lib/`.

The output is one standalone script with no external `source` calls: all library code is embedded. Install with `make install` (installs to `$(DESTDIR)$(prefix)/bin`, default `/usr/local/bin`).

---

## License

This project is licensed under the same terms as [Limani](https://git.windmaker.net/a-castellano/limani): the **GNU General Public License v3.0** (GPL-3.0). See [LICENSE](LICENSE) for the full text.
