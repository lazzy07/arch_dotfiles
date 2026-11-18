#!/usr/bin/env bash
set -euo pipefail

LOG="/tmp/matugen-wall.log"
echo "----------------------------" >> "$LOG"
echo "[matugen-wall] start $(date)" >> "$LOG"

IMG="${1:-}"

if [[ -z "$IMG" || ! -f "$IMG" ]]; then
  echo "[matugen-wall] ERROR: wallpaper file not found: '$IMG'" | tee -a "$LOG" >&2
  exit 1
fi

# Store an absolute path: the restore script runs from a different directory.
IMG="$(realpath -- "$IMG")"

echo "[matugen-wall] using wallpaper: $IMG" >> "$LOG"

# 1) Generate colors with Matugen
if ! command -v matugen >/dev/null 2>&1; then
  echo "[matugen-wall] ERROR: matugen not found in PATH" | tee -a "$LOG" >&2
  exit 1
fi

echo "[matugen-wall] running: matugen image \"$IMG\" --mode dark" >> "$LOG"
matugen image "$IMG" --mode dark >> "$LOG" 2>&1 || {
  echo "[matugen-wall] ERROR: matugen failed" | tee -a "$LOG" >&2
  exit 1
}

# 2) Ensure awww exists
if ! command -v awww >/dev/null 2>&1; then
  echo "[matugen-wall] ERROR: awww not found in PATH" | tee -a "$LOG" >&2
  exit 1
fi

# 3) Ensure awww-daemon is running and has registered the outputs
if ! pgrep -x awww-daemon >/dev/null 2>&1; then
  echo "[matugen-wall] starting awww-daemon" >> "$LOG"
  awww-daemon >> "$LOG" 2>&1 &
else
  echo "[matugen-wall] awww-daemon already running" >> "$LOG"
fi

for _ in $(seq 1 100); do
  awww query 2>/dev/null | grep -q . && break
  sleep 0.1
done

# 4) Apply the wallpaper (awww img without -o applies to every output)
echo "[matugen-wall] outputs: $(awww query 2>>"$LOG" | awk -F': ' '{print $2}' | xargs)" >> "$LOG"
awww img --transition-type center "$IMG" >>"$LOG" 2>&1 || {
  echo "[matugen-wall] ERROR: awww img failed" | tee -a "$LOG" >&2
  exit 1
}

# 5) Generate restore script (autostart + manual re-apply via keybind)
RESTORE="$HOME/.local/bin/awww-restore.sh"
echo "[matugen-wall] writing restore script to $RESTORE" >> "$LOG"

cat > "$RESTORE" <<EOF
#!/usr/bin/env bash
set -euo pipefail

IMG=$(printf '%q' "$IMG")

if ! command -v awww >/dev/null 2>&1; then
  echo "[awww-restore] ERROR: awww not found in PATH" >&2
  exit 1
fi

if ! pgrep -x awww-daemon >/dev/null 2>&1; then
  awww-daemon >/dev/null 2>&1 &
fi

# Wait (up to 10s) until the daemon answers and has registered the outputs
for _ in \$(seq 1 100); do
  awww query 2>/dev/null | grep -q . && break
  sleep 0.1
done

# awww img without -o applies to every output
awww img --transition-type center "\$IMG"
EOF

chmod +x "$RESTORE"
echo "[matugen-wall] DONE, restore script ready" >> "$LOG"
