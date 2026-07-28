#!/usr/bin/env bash
# Move the focused window to the Nth space on the currently-focused display,
# then follow focus there.
# Usage: move-to-space.sh N   (N is 1-based, relative to the focused display)

n="$1"
target=$(yabai -m query --spaces --display | jq -r ".[$((n - 1))].index // empty")
[ -n "$target" ] && yabai -m window --space "$target" && yabai -m space --focus "$target"
