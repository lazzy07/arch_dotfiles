#!/usr/bin/env bash
set -euo pipefail

IMG=/home/lazzy07/documents/wallpapers/01_rocky_landscape.jpg

if ! command -v awww >/dev/null 2>&1; then
  echo "[awww-restore] ERROR: awww not found in PATH" >&2
  exit 1
fi

if ! pgrep -x awww-daemon >/dev/null 2>&1; then
  awww-daemon >/dev/null 2>&1 &
fi

# Wait (up to 10s) until the daemon answers and has registered the outputs
for _ in $(seq 1 100); do
  awww query 2>/dev/null | grep -q . && break
  sleep 0.1
done

# awww img without -o applies to every output
awww img --transition-type center "$IMG"
