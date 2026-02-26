#!/bin/bash -
#===============================================================================
#
#          FILE: 02-parsing.sh
#
#   DESCRIPTION: parsing functions
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
    write_log "Readed package: $pkg -> Version: ${READED_PACKAGES[${readed_package}]}"
  done
}
