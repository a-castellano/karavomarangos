#!/bin/bash
# Validate containers lib

oneTimeSetUp() {
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  LIB_DIR="${script_dir}/../lib"
}

setUp() {
  source "${LIB_DIR}/01-log.sh"
  source "${LIB_DIR}/02-containers.sh"
  source "${LIB_DIR}/03-packages.sh"
}

tearDown() {
  stop_container
  remove_container
}

test_docker_image_management() {
  create_container "harbor.windmaker.net/limani/base"
  assertNotNull "container has been created" "${CONTAINER_NAME}"
  start_container

  update_container_apt_cache

  package_name="windmaker-infiniterecorder"
  package_required_version="0.9-8"

  latest_available_version=$(retrieve_package_from_container "${package_name}")

  assertEquals "Latest windmaker-infiniterecorder version is 0.9-8" "0.9-8" "${latest_available_version}"
}

# Load shunit2 (default path or SHUNIT2 env var)
. "${SHUNIT2:-/usr/share/shunit2/shunit2}"
