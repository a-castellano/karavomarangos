#!/bin/bash
# Validate packages lib

oneTimeSetUp() {
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  EXAMPLES_DIR="${script_dir}/../examples"
  LIB_DIR="${script_dir}/../lib"
}

test_build() {
  FORMER_JSON_FILE="${EXAMPLES_DIR}/valid_examples/base_golang.json"
  COPIED_JSON_FILE=$(mktemp)

  cp "${FORMER_JSON_FILE}" "${COPIED_JSON_FILE}"

  make

  bash karavomarangos --json-file="${COPIED_JSON_FILE}"

  compare_versions=$(diff "${FORMER_JSON_FILE}" "${COPIED_JSON_FILE}" 2>&1 | grep version | tr '\n' ' ' | cut -d '"' -f 4,8)

  assertEquals "Version should be updated in the JSON file" "changeme\"1.26.0-1longsleep1+jammy" "${compare_versions}"
}

# Load shunit2 (default path or SHUNIT2 env var)
. "${SHUNIT2:-/usr/share/shunit2/shunit2}"
