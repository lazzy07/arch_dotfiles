#!/usr/bin/env bash
set -euo pipefail

IMG="/home/lazzy07/documents/wallpapers/Clearnight.jpg"

if ! command -v swww >/dev/null 2>&1; then
  echo "[swww-restore] ERROR: swww not found in PATH" >&2
  exit 1
fi

if ! pgrep -x swww-daemon >/dev/null 2>&1; then
  swww-daemon --format xrgb >/dev/null 2>&1 &
  sleep 0.3
fi

sleep 1.5

OUTPUTS=$(swww query 2>/dev/null | awk '/^Output/ {print $2}')

if [[ -z "$OUTPUTS" ]]; then
  echo "[swww-restore] WARNING: no outputs from swww query, applying once without -o" >&2
  swww img --transition-type center "$IMG"
  exit 0
fi

for out in $OUTPUTS; do
  swww img -o "$out" --transition-type center "$IMG"
done
