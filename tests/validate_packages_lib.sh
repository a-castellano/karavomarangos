#!/bin/bash
# Validate JSON files in examples/ against schema.json

oneTimeSetUp() {
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  EXAMPLES_DIR="${script_dir}/../examples"
  LIB_DIR="${script_dir}/../lib"
}

setUp() {
  source "${LIB_DIR}/01-log.sh"
  source "${LIB_DIR}/02-packages.sh"
}

tearDown() {
  unset JSON_FILE
  unset READED_PACKAGES
}

test_empty_package_definition() {
  JSON_FILE="${EXAMPLES_DIR}/valid_examples/minimum_valid_definition.json"
  parse_packages
  assertNull "No packages should be readed" "${READED_PACKAGES[*]}"
}

# Load shunit2 (default path or SHUNIT2 env var)
. "${SHUNIT2:-/usr/share/shunit2/shunit2}"
