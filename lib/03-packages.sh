#!/usr/bin/env bash
#===============================================================================
#
#          FILE: 03-packages.sh
#
#   DESCRIPTION: package functions
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Álvaro Castellano Vela (alvaro@windmaker.net),
#       CREATED: 2026/02/26 19:29
#      REVISION:  ---
#===============================================================================

# parse_packages
#
# parse packages from the JSON docker definition and store them in an array
#
# Global variables:
# JSON_FILE: path to the JSON file containing the docker definition
#
# Creates:
# READED_PACKAGES: associative array to store package names and versions

function parse_packages {
  declare -g -A READED_PACKAGES # Associative array to store package names and versions

  while IFS=$'\t' read -r name version; do
    READED_PACKAGES["${name}"]="${version}"
  done < <(
    jq -r '(.packages // [])[] | [.name, (.version // "")] | @tsv' "$JSON_FILE"
  )
  for readed_package in "${!READED_PACKAGES[@]}"; do
    write_log "Readed package: $readed_package -> Version: ${READED_PACKAGES[${readed_package}]}"
  done
}

# update_json_file
#
# updates the JSON file with the latest available versions for each package
#
# Global variables:
# JSON_FILE: path to the JSON file containing the docker definition
# READED_PACKAGES: associative array where package names and versions are stored
#

function update_json_file {
  # First of all, remove the old packages information
  jq '.packages = []' "${JSON_FILE}" | sponge "${JSON_FILE}"
  for readed_package in "${!READED_PACKAGES[@]}"; do
    if [ -n "${READED_PACKAGES[${readed_package}]}" ]; then
      write_log "Add package: ${readed_package} -> Version: ${READED_PACKAGES[${readed_package}]}"
      jq --arg name "${readed_package}" --arg version "${READED_PACKAGES[${readed_package}]}" \
        '.packages += [{"name": $name, "version": $version}]' "${JSON_FILE}" | sponge "${JSON_FILE}"
    else
      write_log "Add package: ${package}"
      jq --arg name "${readed_package}" \
        '.packages += [{"name": $name}]' "${JSON_FILE}" | sponge "${JSON_FILE}"
    fi
  done
}

# retieve_package_from_container
#
# retrieve package information from the container
#
# Global variables:
# CONTAINER_NAME: name of the created container
#
# variables:
# required_package: name of the package to retrieve
#
# Returns:
# package_version: packages's latest available verision

function retrieve_package_from_container {
  required_package="$1"
  run_command_in_container "apt-cache madison ${required_package}" | awk '{print $3}' | head -n 1
}

# update_packages_list
#
# updates the package list using container results
#
# Global variables:
# CONTAINER_NAME: name of the created container
# READED_PACKAGES: associative array where package names and versions are stored
#
# Returns:
# nothng, READED_PACKAGES will be updated with the latest available versions for each package

function update_packages_list {
  # Update apt-cache
  run_command_in_container "apt-get update -qq"

  for readed_package in "${!READED_PACKAGES[@]}"; do
    retrived_package_version=$(retrieve_package_from_container "${readed_package}")
    if [[ -n "${retrived_package_version}" ]]; then
      write_log "Package ${readed_package} latest available version: ${retrived_package_version}"
      READED_PACKAGES["${readed_package}"]="$(retrieve_package_from_container "${readed_package}")"
    else
      write_log "Package ${readed_package} not found in container"
    fi
  done

}
