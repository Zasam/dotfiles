#!/usr/bin/env bash
STATE_FILE="$HOME/.cache/omarchy-pomodoro"
WORK_SECS=1500
SHORT_SECS=300
LONG_SECS=900

[ ! -f "$STATE_FILE" ] && printf 'STATE=idle\nEND_EPOCH=0\nREMAINING=0\nSESSIONS=0\n' > "$STATE_FILE"
# shellcheck disable=SC1090
source "$STATE_FILE"
STATE=${STATE:-idle}
NOW=$(date +%s)

case "$STATE" in
    idle|done_break)
        printf 'STATE=work\nEND_EPOCH=%d\nREMAINING=%d\nSESSIONS=%d\n' \
            $((NOW + WORK_SECS)) "$WORK_SECS" "${SESSIONS:-0}" > "$STATE_FILE"
        ;;
    done_work)
        SESS=${SESSIONS:-0}
        if [ $((SESS % 4)) -eq 0 ] && [ "$SESS" -gt 0 ]; then
            printf 'STATE=break_long\nEND_EPOCH=%d\nREMAINING=%d\nSESSIONS=%d\n' \
                $((NOW + LONG_SECS)) "$LONG_SECS" "$SESS" > "$STATE_FILE"
        else
            printf 'STATE=break_short\nEND_EPOCH=%d\nREMAINING=%d\nSESSIONS=%d\n' \
                $((NOW + SHORT_SECS)) "$SHORT_SECS" "$SESS" > "$STATE_FILE"
        fi
        ;;
    work|break_short|break_long)
        REM=$((END_EPOCH - NOW))
        [ "$REM" -lt 0 ] && REM=0
        printf 'STATE=paused_%s\nEND_EPOCH=0\nREMAINING=%d\nSESSIONS=%d\n' \
            "$STATE" "$REM" "${SESSIONS:-0}" > "$STATE_FILE"
        ;;
    paused_*)
        ORIG="${STATE#paused_}"
        printf 'STATE=%s\nEND_EPOCH=%d\nREMAINING=%d\nSESSIONS=%d\n' \
            "$ORIG" $((NOW + REMAINING)) "${REMAINING:-0}" "${SESSIONS:-0}" > "$STATE_FILE"
        ;;
esac

# No signal-based force-refresh needed (waybar's pkill -RTMIN+8 trick) — pomodoro.sh
# polls every 1s, so the next tick shows the new state with no perceptible delay.
