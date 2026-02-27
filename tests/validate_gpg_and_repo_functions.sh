#!/bin/bash
# Validate packages lib

oneTimeSetUp() {
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  EXAMPLES_DIR="${script_dir}/../examples"
  LIB_DIR="${script_dir}/../lib"
}

setUp() {
  source "${LIB_DIR}/01-log.sh"
  source "${LIB_DIR}/02-containers.sh"
  source "${LIB_DIR}/04-repos.sh"
}

tearDown() {
  unset JSON_FILE
  unset READED_PACKAGES
}

test_gpg_by_url() {
  JSON_FILE="${EXAMPLES_DIR}/valid_examples/repos_with_urls.json"

  create_container "ubuntu:noble"
  start_container

  IS_OK=0

  add_gpg_keys && IS_OK=1

  stop_container
  remove_container

  assertEquals "gpg keys by url should be added" 1 "${IS_OK}"
}

test_gpg_by_key() {
  JSON_FILE="${EXAMPLES_DIR}/valid_examples/repos_with_keys.json"

  create_container "ubuntu:noble"
  start_container

  IS_OK=0

  add_gpg_keys && IS_OK=1

  stop_container
  remove_container

  assertEquals "gpg keys by url should be added" 1 "${IS_OK}"
}

test_add_repo() {
  JSON_FILE="${EXAMPLES_DIR}/valid_examples/repos_with_urls.json"

  create_container "ubuntu:noble"
  start_container

  IS_OK=0

  add_gpg_keys

  add_repositories

  run_command_in_container "apt-get update" 2>&1 | grep 'public key is not available' || IS_OK=1

  stop_container
  remove_container

  assertEquals "apt-get update command should not return errors" 1 "${IS_OK}"

}

# Load shunit2 (default path or SHUNIT2 env var)
. "${SHUNIT2:-/usr/share/shunit2/shunit2}"
