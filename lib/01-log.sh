#!/bin/bash -
#===============================================================================
#
#          FILE: 01-log.sh
#
#   DESCRIPTION: Log functions
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Álvaro Castellano Vela (alvaro@windmaker.net),
#       CREATED: 2026/02/26 19:25
#      REVISION:  ---
#===============================================================================

# write_log
#
# writes log using logger

function write_log {
  echo "[$(date +%Y-%m-%d_%H:%M:%S)] - $@"
}
