#!/usr/bin/env bash
# Focus the Nth space on the currently-focused display.
# Usage: focus-space.sh N   (N is 1-based, relative to the focused display)

n="$1"
target=$(yabai -m query --spaces --display | jq -r ".[$((n - 1))].index // empty")
[ -n "$target" ] && yabai -m space --focus "$target"
