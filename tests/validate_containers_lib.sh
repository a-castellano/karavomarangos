#!/bin/bash
# Validate containers lib

oneTimeSetUp() {
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  LIB_DIR="${script_dir}/../lib"
}

setUp() {
  source "${LIB_DIR}/01-log.sh"
  source "${LIB_DIR}/02-containers.sh"
}

tearDown() {
  stop_container
  remove_container
}

test_docker_image_management() {
  create_container "harbor.windmaker.net/limani/base"
  assertNotNull "container has been created" "${CONTAINER_NAME}"
  start_container

  run_command_in_container apt-get update -qq
  package_name=$(run_command_in_container apt-cache madison openssl | head -n 1 | awk '{print $1}')

  assertEquals "Package name should be openssl" "openssl" "${package_name}"
  package_name=$(run_command_in_container apt-cache madison vim | head -n 1 | awk '{print $1}')
  assertEquals "Second package name should be vim" "vim" "${package_name}"
}

# Load shunit2 (default path or SHUNIT2 env var)
. "${SHUNIT2:-/usr/share/shunit2/shunit2}"
