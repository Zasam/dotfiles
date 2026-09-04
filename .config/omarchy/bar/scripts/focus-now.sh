#!/usr/bin/env bash
# focus-now — currently-focused window/site, from atlas-focus-agent's hyprctl-based
# usage sampler (Focus module's usage/live endpoint, ~10s sample cadence). Tooltip also folds
# in today's per-program usage breakdown (usage/daily), so hovering the active-program
# indicator doubles as an at-a-glance "what have I used today, and for how long" view.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=focus-common.sh
source "$SCRIPT_DIR/focus-common.sh"

RESP=$(curl -s --max-time 3 --connect-timeout 2 "$ATLAS_URL/api/focus/usage/live" 2>/dev/null)

if [ -z "$RESP" ]; then
    emit "—" "Atlas unreachable" "none"
    exit
fi

OUT=$(jq -c '
  if .focused == null then
    {text: "—", tooltip: "No focused window reported (agent offline, or nothing focused)", class: "none"}
  else
    (.focused.site // .focused.display_name) as $label
    | (if ($label | length) > 24 then $label[0:23] + "…" else $label end) as $short
    | {
        text: "👁 \($short)",
        tooltip: (
          "\(.focused.display_name) — \(.focused.title)"
          + "\nOpen windows: \(.open_apps | length)"
          + (if (.background_apps | length) > 0 then "\nBackground: " + (.background_apps | join(", ")) else "" end)
        ),
        class: (if .focused.site then "site" else "app" end)
      }
  end
' <<< "$RESP" 2>/dev/null)

if [ -z "$OUT" ]; then
    emit "—" "Atlas response error" "none"
    exit
fi

# Best-effort: a slow/unreachable daily fetch never blocks the live focused-window display,
# it just means the tooltip skips the usage breakdown for this poll.
DAILY=$(curl -s --max-time 3 --connect-timeout 2 "$ATLAS_URL/api/focus/usage/daily" 2>/dev/null)
USAGE=""
if [ -n "$DAILY" ]; then
    while IFS=$'\t' read -r name secs; do
        [ -z "$name" ] && continue
        USAGE+="  ${name} — $(fmt_duration "$secs")"$'\n'
    done < <(jq -r '
        [(.apps // [] | map(select(.focused_secs > 0)) | sort_by(-.focused_secs) | .[] | [.display_name, .focused_secs]),
         (.sites // [] | .[] | [(.site + " (site)"), .focused_secs])]
        | .[] | @tsv
    ' <<< "$DAILY" 2>/dev/null)
fi

if [ -n "$USAGE" ]; then
    BASE_TOOLTIP=$(jq -r '.tooltip' <<< "$OUT")
    NEW_TOOLTIP="${BASE_TOOLTIP}"$'\n\n'"Today's usage:"$'\n'"${USAGE%$'\n'}"
    OUT=$(jq -c --arg tooltip "$NEW_TOOLTIP" '.tooltip = $tooltip' <<< "$OUT")
fi

echo "$OUT"
