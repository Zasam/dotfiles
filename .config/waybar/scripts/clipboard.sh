#!/usr/bin/env bash
# Requires wl-clipboard
text=$(wl-paste -n 2>/dev/null | head -c 30)
if [ -z "$text" ]; then
  echo "📋 —"
else
  echo "📋 $text"
fi
