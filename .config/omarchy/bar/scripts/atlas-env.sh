#!/usr/bin/env bash
# Single source of truth for Atlas's LAN address — sourced by every bar script that
# talks to Atlas (habits, servers, focus-*), so the Pi's IP only needs updating here.
ATLAS_URL="http://192.168.178.40:3000"
