#!/usr/bin/env bash
STATE_FILE="$HOME/.cache/omarchy-pomodoro"
WORK_SECS=1500   # 25 min
SHORT_SECS=300   #  5 min
LONG_SECS=900    # 15 min

if [ ! -f "$STATE_FILE" ]; then
    printf '{"text":" ","tooltip":"Click to start Pomodoro (25 min)","class":"idle"}\n'
    exit
fi

# shellcheck disable=SC1090
source "$STATE_FILE"
STATE=${STATE:-idle}

fmt_time() {
    local secs=$1
    printf '%02d:%02d' $((secs / 60)) $((secs % 60))
}

case "$STATE" in
    idle)
        printf '{"text":" ","tooltip":"Click to start Pomodoro (25 min)","class":"idle"}\n'
        ;;
    work|break_short|break_long)
        NOW=$(date +%s)
        REMAINING=$((END_EPOCH - NOW))
        if [ "$REMAINING" -le 0 ]; then
            # Session finished — notify and flip to done
            if [ "$STATE" = "work" ]; then
                NEW_SESSIONS=$((SESSIONS + 1))
                notify-send -u normal "Pomodoro" "Work session done! Time for a break." 2>/dev/null || true
                printf 'STATE=done_work\nEND_EPOCH=0\nREMAINING=0\nSESSIONS=%d\n' "$NEW_SESSIONS" > "$STATE_FILE"
                printf '{"text":" Done!","tooltip":"Session %d complete. Click to start break.","class":"active"}\n' "$NEW_SESSIONS"
            else
                notify-send -u normal "Pomodoro" "Break over! Ready to focus?" 2>/dev/null || true
                printf 'STATE=done_break\nEND_EPOCH=0\nREMAINING=0\nSESSIONS=%d\n' "${SESSIONS:-0}" > "$STATE_FILE"
                printf '{"text":" Ready","tooltip":"Break done. Click to start work.","class":"active"}\n'
            fi
        else
            TIME=$(fmt_time "$REMAINING")
            if [ "$STATE" = "work" ]; then
                # class:"active" highlights the widget while a work session is running —
                # the bar's command modules only special-case the literal string "active",
                # unlike old waybar's per-class CSS colors (work/break/paused/done).
                printf '{"text":" %s","tooltip":"Pomodoro — session %d\\nClick to pause","class":"active"}\n' "$TIME" "${SESSIONS:-0}"
            else
                printf '{"text":" %s","tooltip":"Break time\\nClick to pause","class":"break"}\n' "$TIME"
            fi
        fi
        ;;
    paused_*)
        ORIG="${STATE#paused_}"
        TIME=$(fmt_time "${REMAINING:-0}")
        if [ "$ORIG" = "work" ]; then
            printf '{"text":" %s","tooltip":"Paused — click to resume\\nSession %d","class":"paused"}\n' "$TIME" "${SESSIONS:-0}"
        else
            printf '{"text":" %s","tooltip":"Break paused — click to resume","class":"paused"}\n' "$TIME"
        fi
        ;;
    done_work)
        printf '{"text":" Done!","tooltip":"Session %d complete. Click to start break.","class":"active"}\n' "${SESSIONS:-0}"
        ;;
    done_break)
        printf '{"text":" Ready","tooltip":"Break done. Click to start work.","class":"active"}\n'
        ;;
    *)
        printf '{"text":" ","tooltip":"Click to start Pomodoro","class":"idle"}\n'
        ;;
esac
