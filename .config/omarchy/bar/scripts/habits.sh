#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=atlas-env.sh
source "$SCRIPT_DIR/atlas-env.sh"

TODAY_DOW=$(( $(date +%u) - 1 ))     # 0=Mon..6=Sun, matches Atlas's Interval convention
TODAY_DOM=$((10#$(date +%d)))
TODAY_MONTH=$((10#$(date +%m)))

RESP=$(curl -s --max-time 3 --connect-timeout 2 "$ATLAS_URL/api/planning/habits" 2>/dev/null)

if [ -z "$RESP" ]; then
    printf '{"text":"—","tooltip":"Atlas unreachable","class":"none"}\n'
    exit
fi

OUT=$(jq -c --argjson dow "$TODAY_DOW" --argjson dom "$TODAY_DOM" --argjson month "$TODAY_MONTH" '
  [ .[] | select(.paused == false) | select(
      (.interval == "daily") or
      (.interval == "weekly_count") or
      (.interval == "weekly"  and ((.config.days  // [0]) | index($dow) != null)) or
      (.interval == "monthly" and ((.config.day   // 1)   == $dom)) or
      (.interval == "yearly"  and ((.config.month // 1)   == $month) and ((.config.day // 1) == $dom))
    )
  ] as $due
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
