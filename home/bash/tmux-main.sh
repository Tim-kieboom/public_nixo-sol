#!/usr/bin/env bash
# usage: tmux-main <window-name> [command...]
win="${1:-shell}"; shift

# create the main session once
tmux has-session -t main 2>/dev/null || tmux new-session -d -s main -n shell

# create the named window if it doesn't exist yet
tmux list-windows -t main -F '#W' | grep -qx "$win" \
  || tmux new-window -d -t main: -n "$win" "$@"

# grouped session: shares windows with main, but each kitty can show a different one
exec tmux new-session -t main -s "view-$$" \; \
  set-option destroy-unattached on \; \
  select-window -t "$win"