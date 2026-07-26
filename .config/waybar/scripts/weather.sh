#!/usr/bin/env bash
# Requires internet connection, uses wttr.in
icon="☀️"
temp=$(curl -s 'wttr.in/?format=%t' 2>/dev/null)
if [ -z "$temp" ]; then
  temp="N/A"
fi
echo "$icon $temp"
