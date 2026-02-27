#!/bin/bash
# Validate packages lib

oneTimeSetUp() {
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  EXAMPLES_DIR="${script_dir}/../examples"
  LIB_DIR="${script_dir}/../lib"
}

setUp() {
  source "${LIB_DIR}/01-log.sh"
  source "${LIB_DIR}/03-packages.sh"
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

test_package_definition() {
  JSON_FILE="${EXAMPLES_DIR}/valid_examples/rabbitmq.json"
  parse_packages
  assertNotNull "packages should be readed" "${READED_PACKAGES[*]}"

  first_package="${!READED_PACKAGES[@]}"
  first_package="${first_package%% *}"
  first_package_version="${READED_PACKAGES[${first_package}]}"

  assertEquals "First package name should be rabbitmq-server" "rabbitmq-server" "${first_package}"
  assertEquals "rabbitmq-server version should be 3.12.1-1ubuntu1" "3.12.1-1ubuntu1" "${first_package_version}"
}

test_package_definition_with_empty_version() {
  JSON_FILE="${EXAMPLES_DIR}/valid_examples/percona_server.json"
  parse_packages
  assertNotNull "packages should be readed" "${READED_PACKAGES[*]}"

  package_names=("${!READED_PACKAGES[@]}")

  first_package_name="${package_names[0]}"
  second_package_name="${package_names[1]}"

  first_package_version="${READED_PACKAGES[${first_package_name}]}"
  second_package_version="${READED_PACKAGES[${second_package_name}]}"

  assertEquals "First package name should be percona-telemetry-agent" "percona-telemetry-agent" "${first_package_name}"
  assertNull "percona-telemetry-agent has no version" "${first_package_version}"

  assertEquals "Second package name should be daedalus-project-mysql-utils" "daedalus-project-mysql-utils" "${second_package_name}"
  assertEquals "daedalus-project-mysql-utils package version" "0.4-7" "${second_package_version}"
}

# Load shunit2 (default path or SHUNIT2 env var)
. "${SHUNIT2:-/usr/share/shunit2/shunit2}"
