#!/usr/bin/env bash
DIR=$(cat ~/.cache/current_project_dir 2>/dev/null)
if [ -z "$DIR" ]; then
    printf '{"text":"—","tooltip":""}\n'
    exit
fi

SHORT="${DIR#/home/nicklas/dev/}"
BRANCH=$(git -C "$DIR" rev-parse --abbrev-ref HEAD 2>/dev/null)
ICON=$''

if [ -n "$BRANCH" ]; then
    printf '{"text":"%s  %s %s","tooltip":"Path: %s\\nBranch: %s"}\n' \
        "$SHORT" "$ICON" "$BRANCH" "$DIR" "$BRANCH"
else
    printf '{"text":"%s","tooltip":"Path: %s"}\n' "$SHORT" "$DIR"
fi
