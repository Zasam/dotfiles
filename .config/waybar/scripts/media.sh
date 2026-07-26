#!/usr/bin/env bash
MAX_LEN=35

STATUS=$(playerctl status 2>/dev/null)
if [ -z "$STATUS" ] || [ "$STATUS" = "No players found" ]; then
    exit 0
fi

ARTIST=$(playerctl metadata artist 2>/dev/null)
TITLE=$(playerctl metadata title 2>/dev/null)
[ -z "$TITLE" ] && exit 0

if [ -n "$ARTIST" ]; then
    FULL="$ARTIST — $TITLE"
else
    FULL="$TITLE"
fi

if [ "${#FULL}" -gt "$MAX_LEN" ]; then
    FULL="${FULL:0:$MAX_LEN}…"
fi

# Escape quotes for JSON
FULL=$(printf '%s' "$FULL" | sed 's/"/\\"/g')
TITLE_SAFE=$(printf '%s' "$TITLE" | sed 's/"/\\"/g')
ARTIST_SAFE=$(printf '%s' "$ARTIST" | sed 's/"/\\"/g')

if [ "$STATUS" = "Playing" ]; then
    printf '{"text":" %s","tooltip":"%s\\n%s","class":"playing"}\n' \
        "$FULL" "$TITLE_SAFE" "$ARTIST_SAFE"
else
    printf '{"text":" %s","tooltip":"%s\\n%s","class":"paused"}\n' \
        "$FULL" "$TITLE_SAFE" "$ARTIST_SAFE"
fi
