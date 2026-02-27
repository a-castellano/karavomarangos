#!/bin/bash
# Validate packages lib

oneTimeSetUp() {
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  EXAMPLES_DIR="${script_dir}/../examples"
  LIB_DIR="${script_dir}/../lib"
}

setUp() {
  source "${LIB_DIR}/01-log.sh"
  source "${LIB_DIR}/04-repos.sh"
}

tearDown() {
  unset JSON_FILE
  unset READED_PACKAGES
}

test_empty_repo_definition() {
  JSON_FILE="${EXAMPLES_DIR}/valid_examples/minimum_valid_definition.json"
  has_repos=$(check_repos)
  assertEquals "No repo info should be readed" 0 "${has_repos}"
}

test_non_empty_repo_definition() {
  JSON_FILE="${EXAMPLES_DIR}/valid_examples/repos_with_urls.json"
  has_repos=$(check_repos)
  assertEquals "repo info should be readed" 1 "${has_repos}"
}

# Load shunit2 (default path or SHUNIT2 env var)
. "${SHUNIT2:-/usr/share/shunit2/shunit2}"
