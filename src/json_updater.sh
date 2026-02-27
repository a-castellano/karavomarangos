#!/usr/bin/env bash
#===============================================================================
#
#          FILE: json_updater.sh
#
#         USAGE: ./json_updater.sh base_image.json
#
#   DESCRIPTION: Update json file with new package versions
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

###################
###     Main    ###
###################
set -Eeuo pipefail

write_log "Start Karavomarangos JSON updater"

JSON_FILE="$1"

write_log "Checking JSON file ${JSON_FILE}"

if [ ! -f "${JSON_FILE}" ]; then
  write_log "JSON file ${JSON_FILE} not found"
  exit 1
fi

write_log "Validating ${JSON_FILE} format"

python3 -m jsonschema -i "${JSON_FILE}" schema.json

write_log "End"
