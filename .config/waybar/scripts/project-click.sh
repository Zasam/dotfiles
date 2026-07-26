#!/usr/bin/env bash
DIR=$(cat ~/.cache/current_project_dir 2>/dev/null)
[ -z "$DIR" ] && exit
cd "$DIR" || exit
exec xdg-terminal-exec
