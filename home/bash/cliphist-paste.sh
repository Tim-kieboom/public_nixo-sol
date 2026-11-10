#!/usr/bin/env sh
entry=$(cliphist list | wofi --dmenu --style ~/.local/state/theme/wofi.css) || exit
[ -n "$entry" ] || exit
printf '%s' "$entry" | cliphist decode | wl-copy
sleep 0.2
wtype -M ctrl v -m ctrl


