#!/usr/bin/env bash
# File name: rotate-monitor.sh
# Project:
# Author: Lasantha M Senanayake
# Date created: 2025-12-25 12:31:27
# Date modified: 2025-12-25 12:33:54
# ------

MONITOR="DP-2"

CURRENT=$(hyprctl monitors -j | jq -r \
  ".[] | select(.name==\"$MONITOR\") | .transform")

if [ "$CURRENT" = "0" ]; then
  NEW=1
else
  NEW=0
fi

# Lua config: `hyprctl keyword monitor` is not available, monitor rules are set with eval.
# A rule with only `transform` keeps the monitor's other settings.
hyprctl eval "hl.monitor({ output = \"$MONITOR\", transform = $NEW })"
