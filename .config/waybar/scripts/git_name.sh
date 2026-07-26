#!/usr/bin/env bash
DIR=$(cat ~/.cache/current_project_dir 2>/dev/null)
[ -z "$DIR" ] && exit
cd "$DIR" || exit
branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
[ -n "$branch" ] && echo " $branch" || echo ""
