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

test_invalid_json() {
  JSON_FILE="${EXAMPLES_DIR}/invalid_examples/base_golang.json"
  bash src/json_updater.sh "${JSON_FILE}"
  exit_code=$?
  assertEquals "Invalid JSON should make json_updater.fail" 1 "${exit_code}"
}

. "${SHUNIT2:-/usr/share/shunit2/shunit2}"
