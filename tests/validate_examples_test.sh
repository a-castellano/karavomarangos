#!/bin/bash
# Validate JSON files in examples/ against schema.json

oneTimeSetUp() {
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  SCHEMA="${script_dir}/../schema.json"
  EXAMPLES_DIR="${script_dir}/../examples"
  assertNotNull "schema.json not found" "${SCHEMA}"
  assertTrue "schema.json must exist" "[ -f \"${SCHEMA}\" ]"
}

test_invalid_example_apt_lines_and_sources() {
  invalid_json="${EXAMPLES_DIR}/invalid_examples/base_golang_invalid_sources_and_lines.json"
  assertTrue "Invalid example must exist" "[ -f \"${invalid_json}\" ]"
  python3 -m jsonschema -i "${invalid_json}" "${SCHEMA}"
  result=$?
  assertNotEquals "Invalid example should not validate against schema" 0 ${result}
}

test_all_valid_examples() {
  for json in "${EXAMPLES_DIR}"/valid_examples/*.json; do
    [ -f "${json}" ] || continue
    python3 -m jsonschema -i "${json}" "${SCHEMA}"
    result=$?
    assertTrue "$(basename "${json}") must validate against schema" "[ ${result} -eq 0 ]"
  done
}

# Load shunit2 (default path or SHUNIT2 env var)
. "${SHUNIT2:-/usr/share/shunit2/shunit2}"
