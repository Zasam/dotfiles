#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CACHE="$HOME/.cache/omarchy-servers"

# servers.sh writes the cache on every check; before its first run, do one check now.
[ -f "$CACHE" ] || "$SCRIPT_DIR/servers.sh" >/dev/null

# Build display lines and a parallel URL array
DISPLAY=()
URLS=()
while IFS='|' read -r name status latency url; do
    [ -z "$name" ] && continue
    if [ "$status" = "up" ]; then
        DISPLAY+=("● $name  ${latency}ms")
    else
        DISPLAY+=("○ $name  offline")
    fi
    URLS+=("$url")
done < "$CACHE"

[ ${#DISPLAY[@]} -eq 0 ] && exit

CHOICE=$(printf '%s\n' "${DISPLAY[@]}" | walker --dmenu -p "Open server" 2>/dev/null)
[ -z "$CHOICE" ] && exit

for i in "${!DISPLAY[@]}"; do
    if [ "${DISPLAY[$i]}" = "$CHOICE" ]; then
        xdg-open "${URLS[$i]}"
        break
    fi
done
