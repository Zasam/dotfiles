#!/usr/bin/env bash
printf 'STATE=idle\nEND_EPOCH=0\nREMAINING=0\nSESSIONS=0\n' > "$HOME/.cache/waybar-pomodoro"
pkill -RTMIN+8 waybar 2>/dev/null || true
