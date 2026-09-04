#!/usr/bin/env bash
# resources — CPU + RAM at a glance. No built-in omarchy.* widget covers this
# (omarchy.monitor is display brightness, not resource usage), so this stays a plain
# command module, same role the old waybar cpu/memory modules played, just combined into
# one widget instead of two adjacent ones.

# CPU%: two /proc/stat samples 200ms apart (a single reading has nothing to diff against).
read -r _ u1 n1 s1 i1 w1 q1 sq1 st1 _ < /proc/stat
sleep 0.2
read -r _ u2 n2 s2 i2 w2 q2 sq2 st2 _ < /proc/stat
IDLE1=$((i1 + w1)); IDLE2=$((i2 + w2))
TOTAL1=$((u1 + n1 + s1 + i1 + w1 + q1 + sq1 + st1))
TOTAL2=$((u2 + n2 + s2 + i2 + w2 + q2 + sq2 + st2))
TOTALD=$((TOTAL2 - TOTAL1)); IDLED=$((IDLE2 - IDLE1))
CPU_PCT=0
[ "$TOTALD" -gt 0 ] && CPU_PCT=$(( (100 * (TOTALD - IDLED)) / TOTALD ))

# RAM from /proc/meminfo (kB -> GiB, one decimal).
MEM_TOTAL_KB=$(awk '/^MemTotal:/{print $2}' /proc/meminfo)
MEM_AVAIL_KB=$(awk '/^MemAvailable:/{print $2}' /proc/meminfo)
MEM_USED_KB=$((MEM_TOTAL_KB - MEM_AVAIL_KB))
MEM_USED_GB=$(awk -v kb="$MEM_USED_KB" 'BEGIN{printf "%.1f", kb/1024/1024}')
MEM_TOTAL_GB=$(awk -v kb="$MEM_TOTAL_KB" 'BEGIN{printf "%.1f", kb/1024/1024}')
MEM_PCT=$(( MEM_TOTAL_KB > 0 ? (100 * MEM_USED_KB) / MEM_TOTAL_KB : 0 ))

CLASS="none"
[ "$CPU_PCT" -ge 85 ] || [ "$MEM_PCT" -ge 85 ] && CLASS="active"

jq -cn \
  --arg text "${CPU_PCT}%  ${MEM_USED_GB}G" \
  --arg tooltip "CPU: ${CPU_PCT}%
RAM: ${MEM_USED_GB} GiB / ${MEM_TOTAL_GB} GiB (${MEM_PCT}%)
Click: open btop" \
  --arg class "$CLASS" \
  '{text:$text, tooltip:$tooltip, class:$class}'
