#!/usr/bin/env bash
#===============================================================================
#
#          FILE: karavomarangos.sh
#
#         USAGE: ./karavomarangos.sh [OPTIONS] --json-file=FICHERO
#
#   DESCRIPTION: Karavomarangos — update JSON image definition and generate Dockerfile
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Álvaro Castellano Vela (alvaro@windmaker.net),
#       CREATED: 2026/02/27 23:35
#      REVISION:  ---
#===============================================================================

source lib/01-log.sh
source lib/02-containers.sh
source lib/03-packages.sh
source lib/04-repos.sh
source lib/05-argbash.sh

###################
###     Main    ###
###################
set -Eeuo pipefail

write_log "Start karavomarangos"

JSON_FILE="$_arg_json_file"

if [[ -z "${JSON_FILE}" ]]; then
  _PRINT_HELP=yes die "Missing required argument: --json-file" 1
fi

write_log "Checking JSON file ${JSON_FILE}"

if [[ ! -f "${JSON_FILE}" ]]; then
  write_log "JSON file ${JSON_FILE} not found"
  exit 1
fi

write_log "Validating ${JSON_FILE} format"

python3 -m jsonschema -i "${JSON_FILE}" schema.json

write_log "Parsing packages from ${JSON_FILE}"

retrieve_base_image

parse_packages

create_container "${BASE_IMAGE}"

start_container

image_has_repos=$(check_repos)

if [[ "${image_has_repos}" -eq 1 ]]; then
  write_log "Image has repositories information, adding them to the container"
  update_container_apt_cache
  write_log "Adding required packages for repository management to the container"
  install_required_repository_management_required_packages
  add_gpg_keys
  add_repositories
fi

IS_OK=0
run_command_in_container "apt-get update" 2>&1 | grep 'public key is not available' || IS_OK=1

if [[ "${IS_OK}" -eq 0 ]]; then
  write_log "Failed to update package lists, probably due to missing GPG keys"
  exit 1
fi

update_packages_list

update_json_file

stop_container

remove_container

write_log "Writting Dockerfile"

gomplate --context config="${JSON_FILE}" --file=templates/Dockerfile.tmpl --out=Dockerfile

write_log "End"
