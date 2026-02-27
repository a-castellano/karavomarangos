#!/usr/bin/env bash
#===============================================================================
#
#          FILE: 04-repos.sh
#
#   DESCRIPTION: repo functions including GPG key management
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Álvaro Castellano Vela (alvaro@windmaker.net),
#       CREATED: 2026/02/27 19:44
#      REVISION:  ---
#===============================================================================

# check_repos
#
# check if the JSON docker definition contains repositories information
# Global variables:
# JSON_FILE: path to the JSON file containing the docker definition
#
# returns:
# 1 if repositories information is found, 0 otherwise

function check_repos {
  if jq -e 'has("required_repositories") and (.required_repositories | length > 0)' "$JSON_FILE" >/dev/null; then
    echo 1 # Repositories information is found
  else
    echo 0 # No repositories information found
  fi
}

# add_gpg_keys
#
# parse gpg keys from the JSON docker definition and adds them to base container
#
# Global variables:
# JSON_FILE: path to the JSON file containing the docker definition
# CONTAINER_NAME: name of the created container
#
# Creates:
# none, gpg keys will be added to the container

function add_gpg_keys {

  temp_gpg_file=$(mktemp)

  keyring_name=$(jq -r '.required_repositories.gpg_keyring.name' "${JSON_FILE}")
  write_log "Adding GPG keys to container ${CONTAINER_NAME} using keyring ${keyring_name}"
  gpg_keys_type=$(jq -r '.required_repositories.gpg_keyring.content.type' "${JSON_FILE}")
  write_log "GPG keys type: ${gpg_keys_type}"

  if [ "${gpg_keys_type}" == "url" ]; then
    mapfile -t gpg_urls < <(
      jq -r '.required_repositories.gpg_keyring.content.data[]' "${JSON_FILE}"
    )
    for gpg_url in "${gpg_urls[@]}"; do
      write_log "Adding GPG key from URL: ${gpg_url}"
      wget -qO- ${gpg_url} >>"${temp_gpg_file}"
    done
  else # gpg_keys_type is "keys"
    mapfile -t gpg_keys < <(
      jq -r '.required_repositories.gpg_keyring.content.data[]' "${JSON_FILE}"
    )
    for gpg_key in "${gpg_keys[@]}"; do
      write_log "Adding GPG key: ${gpg_key}"
      gpg --keyserver keyserver.ubuntu.com --recv-keys "${gpg_key}"
    done
    write_log "Exporting GPG keys to temporary file"
    gpg --export $(printf "%s " "${gpg_keys[@]}") | gpg --dearmor >"${temp_gpg_file}"
  fi
  write_log "copy GPG keys file to container ${CONTAINER_NAME}"
  copy_file_to_container "${temp_gpg_file}" "/etc/apt/keyrings/${keyring_name}.gpg"
  run_command_in_container "chmod 644 /etc/apt/keyrings/${keyring_name}.gpg"

  rm "${temp_gpg_file}"
}

# add_repositories
#
# parse repositories from the JSON docker definition and adds them to container
#
# Global variables:
# JSON_FILE: path to the JSON file containing the docker definition
# CONTAINER_NAME: name of the created container
#
# Creates:
# none, repo entries will be added to the container

function add_repositories {
  repository_name=$(jq -r '.required_repositories.name' "${JSON_FILE}")
  temp_repos_file=$(mktemp)
  mapfile -t repository_lines < <(
    jq -r '.required_repositories.apt_lines[]' "${JSON_FILE}"
  )
  for repository_line in "${repository_lines[@]}"; do
    write_log "Adding: ${repository_line}"
    echo "${repository_line}" >>"${temp_repos_file}"
  done
  write_log "copy repository file to container ${CONTAINER_NAME}"
  copy_file_to_container "${temp_repos_file}" "/etc/apt/sources.list.d/${repository_name}.list"
}

# install_required_repository_management_required_packages
#
# installs required packages for repository management in the CONTAINER_NAME
#
# Global variables:
# CONTAINER_NAME: name of the created container

function install_required_repository_management_required_packages {
  run_command_in_container "apt-get install -y gnupg wget ca-certificates"
}
