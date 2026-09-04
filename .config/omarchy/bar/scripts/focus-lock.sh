#!/usr/bin/env bash
# focus-lock — active Focus-module commitment blocks: apps enforced locally by
# atlas-focus-agent, domains enforced via Pi-hole. Shows a countdown to when the last
# active block clears; ∞ while a permanent block is still waiting on request-unlock.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=focus-common.sh
source "$SCRIPT_DIR/focus-common.sh"

NOW_TXT=$(date +"%Y-%m-%d %H:%M:%S")
NOW_EPOCH=$(date +%s)

APPS_RAW=$(curl -s --max-time 3 --connect-timeout 2 "$ATLAS_URL/api/focus/apps/active" 2>/dev/null)
DOMAINS_RAW=$(curl -s --max-time 3 --connect-timeout 2 "$ATLAS_URL/api/focus/domains" 2>/dev/null)

if [ -z "$APPS_RAW" ] && [ -z "$DOMAINS_RAW" ]; then
    emit "—" "Atlas unreachable" "none"
    exit
fi

# name<TAB>kind<TAB>unlock_at, one per currently-active block. /api/focus/domains returns
# full history (not just active), so it needs the same reverted_at/unlock_at filter Atlas's
# own frontend applies; /api/focus/apps/active is already filtered server-side.
LINES=$(
  { jq -r '.[]? | [.display_name, "app", .unlock_at] | @tsv' <<< "${APPS_RAW:-[]}"
    jq -r --arg now "$NOW_TXT" \
      '.[]? | select(.reverted_at == null and .unlock_at > $now) | [.domain, "domain", .unlock_at] | @tsv' \
      <<< "${DOMAINS_RAW:-[]}"
  } 2>/dev/null
)

if [ -z "$LINES" ]; then
    emit "—" "No active focus blocks" "none"
    exit
fi

COUNT=0
MAX_REMAINING=0
HAS_FOREVER=0
TOOLTIP=""
while IFS=$'\t' read -r NAME KIND UNLOCK_AT; do
    [ -z "$NAME" ] && continue
    COUNT=$((COUNT + 1))
    ICON="🖥"
    [ "$KIND" = "domain" ] && ICON="🌐"
    if [ "$UNLOCK_AT" = "$FOREVER" ]; then
        HAS_FOREVER=1
        LINE="$ICON $NAME — forever (no unlock requested)"
    else
        UNLOCK_EPOCH=$(date -d "$UNLOCK_AT" +%s 2>/dev/null || echo "$NOW_EPOCH")
        REMAINING=$((UNLOCK_EPOCH - NOW_EPOCH))
        [ "$REMAINING" -lt 0 ] && REMAINING=0
        [ "$REMAINING" -gt "$MAX_REMAINING" ] && MAX_REMAINING=$REMAINING
        LINE="$ICON $NAME — $(fmt_duration "$REMAINING") left"
    fi
    TOOLTIP="${TOOLTIP:+$TOOLTIP$'\n'}$LINE"
done <<< "$LINES"

# Both branches use class "active" (not a distinct "forever" class) — the bar's command
# module only highlights the literal string "active", so this is what makes a live block
# actually stand out, unlike the old waybar CSS which could style "forever" separately.
if [ "$HAS_FOREVER" -eq 1 ]; then
    emit "🔒 ∞" "$TOOLTIP" "active"
elif [ "$COUNT" -gt 1 ]; then
    emit "🔒 ($COUNT) $(fmt_duration "$MAX_REMAINING")" "$TOOLTIP" "active"
else
    emit "🔒 $(fmt_duration "$MAX_REMAINING")" "$TOOLTIP" "active"
fi
