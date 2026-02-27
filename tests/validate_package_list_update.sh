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

  declare -g -A READED_PACKAGES

  READED_PACKAGES["windmaker-infiniterecorder"]="0.1"
  READED_PACKAGES["windmaker-any-other-package"]=""

  update_packages_list
  latest_available_version=${READED_PACKAGES["windmaker-infiniterecorder"]}

  assertEquals "Latest windmaker-infiniterecorder version is 0.9-8" "0.9-8" "${latest_available_version}"
}

# Load shunit2 (default path or SHUNIT2 env var)
. "${SHUNIT2:-/usr/share/shunit2/shunit2}"
