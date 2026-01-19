# File name: rotate-monitor.sh
# Project:
# Author: Lasantha M Senanayake
# Date created: 2025-12-25 12:31:27
# Date modified: 2025-12-25 12:33:54
# ------

#!/usr/bin/env bash

MONITOR="DP-2"

CURRENT=$(hyprctl monitors -j | jq -r \
  ".[] | select(.name==\"$MONITOR\") | .transform")

if [ "$CURRENT" = "0" ]; then
  hyprctl keyword monitor $MONITOR,transform,1
else
  hyprctl keyword monitor $MONITOR,transform,0
fi
