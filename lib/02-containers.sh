#!/bin/bash -
#===============================================================================
#
#          FILE: 02-containers.sh
#
#   DESCRIPTION: container functions
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Álvaro Castellano Vela (alvaro@windmaker.net),
#       CREATED: 2026/02/26 21:35
#      REVISION:  ---
#===============================================================================

# create_container
#
# create a container from the given image name and store the container name in a global variable
#
# Arguments:
# IMAGE_NAME: name of the created container
#
# Creates:
# CONTAINER_NAME: name of the created container

function create_container {
  IMAGE_NAME="$1"
  declare -g CONTAINER_NAME=$(head -c 16 /dev/urandom | od -An -tx1 | tr -d ' \n')

  write_log "Creating container ${CONTAINER_NAME} from image ${IMAGE_NAME}"
  # Image should have a different entrypoint,
  # change it by /bin/bash in order to keep the container running
  docker create --name "${CONTAINER_NAME}" -i ${IMAGE_NAME} /bin/bash
}

# start_container
#
# starts given container name
#
# Requires:
# CONTAINER_NAME: name of the created container
#

function start_container {
  docker start "${CONTAINER_NAME}"
}

# stop_container
#
# stops given container name
#
# Requires:
# CONTAINER_NAME: name of the created container
#

function stop_container {
  docker stop "${CONTAINER_NAME}"
}

# remove_container
#
# remove given container name
#
# Requires:
# CONTAINER_NAME: name of the created container
#

function remove_container {
  docker rm "${CONTAINER_NAME}"
}

# run_command_in_container
#
# runs a command in the given container name and returns the output
#
# Requires:
# CONTAINER_NAME: name of the created container
#
# Arguments:
# COMMAND: command to run in the container

function run_command_in_container {
  COMMAND="${@}"
  docker exec "${CONTAINER_NAME}" ${COMMAND}
}

# update_container_apt_cache
#
# runs a apt-get update in the given container
#
# Requires:
# CONTAINER_NAME: name of the created container
#

function update_container_apt_cache {
  run_command_in_container "apt-get update -qq"
}
