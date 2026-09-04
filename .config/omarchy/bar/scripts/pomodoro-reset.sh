#!/usr/bin/env bash
# No signal-based force-refresh (waybar's pkill -RTMIN+8 trick) — the bar's command
# modules only poll on their own interval, but pomodoro.sh polls every 1s anyway, so the
# next tick picks this up with no perceptible delay.
printf 'STATE=idle\nEND_EPOCH=0\nREMAINING=0\nSESSIONS=0\n' > "$HOME/.cache/omarchy-pomodoro"
