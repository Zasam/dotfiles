#!/usr/bin/env bash
COUNT=$(pacman -Qu 2>/dev/null | wc -l)
COUNT=${COUNT:-0}

if [ "$COUNT" -eq 0 ]; then
    printf '{"text":"󰮂","tooltip":"System is up to date","class":"ok"}\n'
elif [ "$COUNT" -lt 10 ]; then
    printf '{"text":"󰮂 %d","tooltip":"%d update(s) available\\nClick to update","class":"pending"}\n' "$COUNT" "$COUNT"
else
    printf '{"text":"󰮂 %d","tooltip":"%d update(s) available\\nClick to update","class":"urgent"}\n' "$COUNT" "$COUNT"
fi
