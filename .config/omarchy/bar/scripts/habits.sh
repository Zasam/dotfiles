#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=atlas-env.sh
source "$SCRIPT_DIR/atlas-env.sh"

TODAY=$(date +%F)

RESP=$(curl -s --max-time 3 --connect-timeout 2 "$ATLAS_URL/api/planning/habits" 2>/dev/null)

if [ -z "$RESP" ]; then
    printf '{"text":"—","tooltip":"Atlas unreachable","class":"none"}\n'
    exit
fi

# Due today = Atlas's own current period starts today (its interval rules: weekdays, week
# parity, every N days, month-end clamping), or a weekly_count habit, whose week-long period
# can be worked on any day.
OUT=$(jq -c --arg today "$TODAY" '
  [ .[] | select(.paused == false)
        | select(.current_period == $today or .interval == "weekly_count") ] as $due
  | ($due | length) as $total
  | ([$due[] | select(.current_entry.done == true)] | length) as $done
  | ($due | sort_by(.name) | map(if .current_entry.done == true then "✓ " + .name else "○ " + .name end) | join("\n")) as $tooltip
  | if $total == 0 then
      {text: "—", tooltip: "No habits due today", class: "none"}
    else
      {
        text: (" \($done)/\($total)"),
        tooltip: $tooltip,
        class: (if $done >= $total then "active" else "none" end)
      }
    end
' <<< "$RESP" 2>/dev/null)

if [ -z "$OUT" ]; then
    printf '{"text":"—","tooltip":"Atlas response error","class":"none"}\n'
    exit
fi

echo "$OUT"
