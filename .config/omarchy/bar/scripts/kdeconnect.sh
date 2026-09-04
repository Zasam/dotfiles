#!/usr/bin/env bash
# custom/kdeconnect — glance at the paired phone's reachability + battery level.
# Device id is looked up live via kdeconnect-cli rather than hardcoded, so re-pairing
# (a new device id) doesn't silently break this module. --list-available already only
# lists paired devices that are currently reachable, so an empty result IS the
# disconnected state — no separate isReachable check needed.

DEV_ID=$(kdeconnect-cli --list-available --id-only 2>/dev/null | head -n1)

if [ -z "$DEV_ID" ]; then
    printf '{"text":" —","tooltip":"No phone paired or reachable","class":"disconnected"}\n'
    exit
fi

DEV_NAME=$(kdeconnect-cli --list-available --id-name-only 2>/dev/null | head -n1 | cut -d' ' -f2-)
[ -z "$DEV_NAME" ] && DEV_NAME="Phone"

CHARGE=$(busctl --user get-property org.kde.kdeconnect \
    "/modules/kdeconnect/devices/$DEV_ID/battery" \
    org.kde.kdeconnect.device.battery charge 2>/dev/null | awk '{print $2}')
CHARGING=$(busctl --user get-property org.kde.kdeconnect \
    "/modules/kdeconnect/devices/$DEV_ID/battery" \
    org.kde.kdeconnect.device.battery isCharging 2>/dev/null | awk '{print $2}')

if [ -z "$CHARGE" ]; then
    jq -cn --arg text " $DEV_NAME" --arg tooltip "$DEV_NAME — connected, battery unknown" \
        '{text:$text, tooltip:$tooltip, class:"connected"}'
    exit
fi

CLASS="connected"
BOLT=""
CHARGE_NOTE=""
if [ "$CHARGING" = "true" ]; then
    BOLT="⚡"
    CLASS="charging"
    CHARGE_NOTE=" (charging)"
elif [ "$CHARGE" -le 20 ]; then
    CLASS="low"
fi

TEXT=" ${BOLT}${CHARGE}%"
TOOLTIP="$DEV_NAME — ${CHARGE}% battery${CHARGE_NOTE}
Click: open KDE Connect
Right-click: ping phone"

jq -cn --arg text "$TEXT" --arg tooltip "$TOOLTIP" --arg class "$CLASS" \
    '{text:$text, tooltip:$tooltip, class:$class}'
