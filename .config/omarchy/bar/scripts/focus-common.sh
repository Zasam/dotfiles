#!/usr/bin/env bash
# Shared helpers for the focus-* bar modules — all three surface data collected by
# atlas-focus-agent (running on this machine) via Atlas's Focus module API.
_FOCUS_COMMON_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=atlas-env.sh
source "$_FOCUS_COMMON_DIR/atlas-env.sh"
FOREVER="9999-12-31 23:59:59"

# Seconds -> "1d 2h" / "2h 15m" / "15m" / "<1m"
fmt_duration() {
    local secs=$1
    if   [ "$secs" -ge 86400 ]; then printf '%dd %dh' $((secs / 86400)) $(((secs % 86400) / 3600))
    elif [ "$secs" -ge 3600 ];  then printf '%dh %dm' $((secs / 3600)) $(((secs % 3600) / 60))
    elif [ "$secs" -ge 60 ];    then printf '%dm' $((secs / 60))
    else printf '<1m'
    fi
}

# Safely package text/tooltip/class into the JSON the bar's command modules expect —
# jq's --arg handles quote/newline escaping, so callers can build tooltips with plain
# multi-line bash strings. Only class:"active" is visually distinguished by the bar
# (bold/highlighted), so callers pick "active" deliberately when a block/state is live.
emit() {
    jq -cn --arg text "$1" --arg tooltip "$2" --arg class "$3" '{text:$text, tooltip:$tooltip, class:$class}'
}
