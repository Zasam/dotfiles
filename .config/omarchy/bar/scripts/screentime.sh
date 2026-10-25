#!/usr/bin/env bash
# screentime — today's active screen time from Atlas's Screen time module (fed by
# atlas-screentime-agent on this machine). Tooltip: what's focused right now, the change
# vs. the 7-day average, time per category, top apps and sites.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=atlas-env.sh
source "$SCRIPT_DIR/atlas-env.sh"

fetch() { curl -s --max-time 3 --connect-timeout 2 "$ATLAS_URL/api/screentime/$1" 2>/dev/null; }

DAY=$(fetch day)
if [ -z "$DAY" ]; then
    jq -cn '{text: "⏱ —", tooltip: "Atlas unreachable", class: "none"}'
    exit
fi
# Status and live sample are best-effort: without them the tooltip just skips those lines.
STATUS=$(fetch agent/status)
LIVE=$(fetch live)

jq -c --argjson status "${STATUS:-null}" --argjson live "${LIVE:-null}" '
  def dur: floor | if . >= 3600 then "\(. / 3600 | floor)h \(. % 3600 / 60 | floor)m"
                   elif . >= 60 then "\(. / 60 | floor)m" else "<1m" end;
  (.categories | map({key: (.id | tostring), value: .name}) | from_entries) as $names
  | ($status.online // false) as $online
  | (if $live == null then []
     elif $live.idle then ["Right now: idle"]
     elif $live.focused then ["Right now: " + $live.focused.display_name
                              + (if $live.focused.domain then " · " + $live.focused.domain else "" end)]
     else [] end) as $now
  | (if .avg_active_secs > 0 then
       ((.active_secs / .avg_active_secs - 1) * 100 | round) as $pct
       | ["\(if $pct >= 0 then "+" else "" end)\($pct)% vs. 7-day average (\(.avg_active_secs | dur))"]
     else [] end) as $avg
  | (.by_category | map("  \($names[.category_id | tostring] // "Uncategorized") — \(.secs | dur)")) as $cats
  | (.apps | map(select(.focused_secs > 0)) | .[0:3] | map("  \(.name) — \(.focused_secs | dur)")) as $apps
  | (.sites | .[0:3] | map("  \(.domain) — \(.focused_secs | dur)")) as $sites
  | {
      text: ("⏱ " + (.active_secs | dur)),
      tooltip: ((if $online then [] else ["Agent offline — screen time is not being recorded"] end)
        + ["Screen time today: \(.active_secs | dur)"] + $avg + $now
        + (if ($cats | length) > 0 then ["", "Categories:"] + $cats else [] end)
        + (if ($apps | length) > 0 then ["", "Top apps:"] + $apps else [] end)
        + (if ($sites | length) > 0 then ["", "Top sites:"] + $sites else [] end)
        | join("\n")),
      class: (if $online then "ok" else "none" end)
    }
' <<< "$DAY" 2>/dev/null || jq -cn '{text: "⏱ —", tooltip: "Atlas response error", class: "none"}'
