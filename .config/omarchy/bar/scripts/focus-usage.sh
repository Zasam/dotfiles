#!/usr/bin/env bash
# focus-usage — today's total window-focused screen time, aggregated by
# atlas-focus-agent's usage sampler (Focus module's usage/daily endpoint).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=focus-common.sh
source "$SCRIPT_DIR/focus-common.sh"

RESP=$(curl -s --max-time 3 --connect-timeout 2 "$ATLAS_URL/api/focus/usage/daily" 2>/dev/null)

if [ -z "$RESP" ]; then
    emit "—" "Atlas unreachable" "none"
    exit
fi

TOTAL_SECS=$(jq '[.apps[].focused_secs] | add // 0' <<< "$RESP" 2>/dev/null)
if [ -z "$TOTAL_SECS" ]; then
    emit "—" "Atlas response error" "none"
    exit
fi

if [ "$TOTAL_SECS" -eq 0 ]; then
    emit "⏱ 0m" "No screen time recorded yet today" "none"
    exit
fi

TEXT="⏱ $(fmt_duration "$TOTAL_SECS")"

OUT=$(jq -c --arg text "$TEXT" '
  (.apps | map(select(.focused_secs > 0)) | sort_by(-.focused_secs) | .[0:5]
    | map("  \(.display_name) — \((.focused_secs / 60 | floor))m")) as $top_apps
  | (.sites | sort_by(-.focused_secs) | .[0:5]
    | map("  \(.site) — \((.focused_secs / 60 | floor))m")) as $top_sites
  | ([ "Screen time today: " + $text ]
      + (if ($top_apps | length) > 0 then [""] + ["Top apps:"] + $top_apps else [] end)
      + (if ($top_sites | length) > 0 then [""] + ["Top sites:"] + $top_sites else [] end)
    ) as $lines
  | {text: $text, tooltip: ($lines | join("\n")), class: "ok"}
' <<< "$RESP" 2>/dev/null)

if [ -z "$OUT" ]; then
    emit "—" "Atlas response error" "none"
else
    echo "$OUT"
fi
