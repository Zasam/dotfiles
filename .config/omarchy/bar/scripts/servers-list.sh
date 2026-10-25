#!/usr/bin/env bash
# The services the `servers` bar module checks — one place to add, remove or re-address one.
# Parallel arrays: display name, host label, URL. Sourced by servers.sh.
_SERVERS_LIST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=atlas-env.sh
source "$_SERVERS_LIST_DIR/atlas-env.sh"

# shellcheck disable=SC2034  # used by the scripts sourcing this file
NAMES=("Home Assistant" "Immich"                 "Nextcloud"              "SEQ"                   "Pi-hole"              "Atlas")
# shellcheck disable=SC2034
HOSTS=("RPI5"           "RPI5"                   "RPI5"                   "VPS"                   "RPI3"                 "RPI5")
# shellcheck disable=SC2034
URLS=( "http://192.168.178.40:8123"
       "http://192.168.178.40:2283"
       "http://192.168.178.40:8080"
       "http://212.227.31.20:5341"
       "http://192.168.178.41"
       "$ATLAS_URL" )
