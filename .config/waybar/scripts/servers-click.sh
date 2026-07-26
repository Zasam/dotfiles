#!/usr/bin/env bash
CACHE="$HOME/.cache/waybar-servers"

# If no cache yet, fall back to static list
if [ ! -f "$CACHE" ]; then
    entries=(
        "Home Assistant|up|0|http://192.168.178.40:8123"
        "Immich|up|0|http://192.168.178.40:2283"
        "Nextcloud|up|0|http://192.168.178.40:8080"
        "SEQ|up|0|http://212.227.31.20:5341"
        "Pi-hole|up|0|http://192.168.178.41"
        "Atlas|up|0|http://192.168.178.40:3000"
    )
    for e in "${entries[@]}"; do
        echo "$e" >> "$CACHE"
    done
fi

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
