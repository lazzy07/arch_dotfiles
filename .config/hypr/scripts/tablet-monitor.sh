#!/usr/bin/env bash

# Auto-rotate Huion Kamvas when connected in Hyprland
# Runs in a loop in the USER session (exec-once in hyprland.conf)

STATE_FILE="/tmp/kamvas-connected"

# Optional: if you know exact monitor name, set it here to skip auto-detect:
# FORCE_OUTPUT_NAME="HDMI-A-1"
FORCE_OUTPUT_NAME="DP-2"

echo "" >>"$LOG"
echo "==== Kamvas autorotate started at $(date) ====" >>"$LOG"

while true; do
  # Get monitors list
  MONS="$(hyprctl monitors 2>/dev/null)"

  if [ -z "$MONS" ]; then
    echo "$(date): hyprctl monitors returned nothing" >>"$LOG"
    sleep 2
    continue
  fi

  # Detect Kamvas output
  if [ -n "$FORCE_OUTPUT_NAME" ]; then
    TABLET_OUTPUT="$FORCE_OUTPUT_NAME"
  else
    # Look for HUION / Kamvas line and grab the monitor name from previous line
    TABLET_OUTPUT="$(
      echo "$MONS" | awk '
                /Monitor / { name=$2 }
                /HUION/ || /Kamvas/ { print name }
            ' | head -n1
    )"
  fi

  if [ -n "$TABLET_OUTPUT" ]; then
    # Kamvas is connected
    if [ ! -f "$STATE_FILE" ]; then
      echo "$(date): Detected Kamvas on $TABLET_OUTPUT, applying rotation" >>"$LOG"

      # Rotate display 180° (left-handed). Adjust if needed.
      hyprctl keyword monitor "$TABLET_OUTPUT,preferred,auto,1,transform,2" >>"$LOG" 2>&1

      # If you later get otd-cli, you can also map pen here.
      # Example (uncomment when available):
      # otd-cli mapping set "Huion Kamvas 13 Gen 3 Pen" --output "$TABLET_OUTPUT" --rotation 180 >>"$LOG" 2>&1

      touch "$STATE_FILE"
    fi
  else
    # Kamvas not found
    if [ -f "$STATE_FILE" ]; then
      echo "$(date): Kamvas disconnected, clearing state" >>"$LOG"
      rm -f "$STATE_FILE"

      # Optional: reset anything here (like pen mapping) if needed.
      # Example:
      # otd-cli mapping set "Huion Kamvas 13 Gen 3 Pen" --output all --rotation 0 >>"$LOG" 2>&1
    fi
  fi

  sleep 2
done
