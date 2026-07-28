#!/usr/bin/env bash
# Float the focused window if it is still managed, then place it on a grid.
# Toggling unconditionally would re-manage an already-floating window, and
# yabai refuses to grid a managed window.
# Usage: float-grid.sh GRID   (e.g. float-grid.sh 7:5:4:0:1:1)

grid="$1"
[ "$(yabai -m query --windows --window | jq -r '."is-floating"')" = "false" ] &&
    yabai -m window --toggle float
yabai -m window --grid "$grid"
