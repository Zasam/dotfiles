#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=atlas-env.sh
source "$SCRIPT_DIR/atlas-env.sh"

NAMES=("Home Assistant" "Immich"                 "Nextcloud"              "SEQ"                   "Pi-hole"              "Atlas")
HOSTS=("RPI5"           "RPI5"                   "RPI5"                   "VPS"                   "RPI3"                 "RPI5")
URLS=( "http://192.168.178.40:8123"
       "http://192.168.178.40:2283"
       "http://192.168.178.40:8080"
       "http://212.227.31.20:5341"
       "http://192.168.178.41"
       "$ATLAS_URL" )

CACHE="$HOME/.cache/waybar-servers"
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

for i in "${!NAMES[@]}"; do
    (
        START_MS=$(date +%s%3N)
        CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 --connect-timeout 2 "${URLS[$i]}" 2>/dev/null)
        END_MS=$(date +%s%3N)
        LATENCY=$((END_MS - START_MS))
        if [ -n "$CODE" ] && [ "$CODE" != "000" ] && [ "$CODE" -gt 0 ] 2>/dev/null; then
            echo "up $LATENCY"
        else
            echo "down 0"
        fi
    ) > "$TMPDIR/$i" &
done
wait

DOWN=0
TOTAL=${#NAMES[@]}
TOOLTIP=""
# Cache format: "NAME|STATUS|LATENCY|URL" per line
> "$CACHE.tmp"

for i in "${!NAMES[@]}"; do
    read -r STATUS LATENCY < "$TMPDIR/$i"
    if [ "$STATUS" = "up" ]; then
        LINE="● ${NAMES[$i]} [${HOSTS[$i]}]  ${LATENCY}ms"
        echo "${NAMES[$i]}|up|${LATENCY}|${URLS[$i]}" >> "$CACHE.tmp"
    else
        LINE="○ ${NAMES[$i]} [${HOSTS[$i]}]  offline"
        echo "${NAMES[$i]}|down|0|${URLS[$i]}" >> "$CACHE.tmp"
        ((DOWN++))
    fi
    TOOLTIP="${TOOLTIP:+$TOOLTIP\\n}$LINE"
done

mv "$CACHE.tmp" "$CACHE"

if [ "$DOWN" -eq 0 ]; then
    TEXT="● $TOTAL/$TOTAL"
    CLASS="ok"
else
    TEXT="● $((TOTAL - DOWN))/$TOTAL"
    CLASS="warn"
fi

printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' "$TEXT" "$TOOLTIP" "$CLASS"
