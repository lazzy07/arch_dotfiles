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

echo "[matugen-wall] using wallpaper: $IMG" >> "$LOG"

# 1) Generate colors with Matugen
if ! command -v matugen >/dev/null 2>&1; then
  echo "[matugen-wall] ERROR: matugen not found in PATH" | tee -a "$LOG" >&2
  exit 1
fi

echo "[matugen-wall] running: matugen image \"$IMG\"" >> "$LOG"
matugen image "$IMG" >> "$LOG" 2>&1 || {
  echo "[matugen-wall] ERROR: matugen failed" | tee -a "$LOG" >&2
  exit 1
}

# 2) Ensure swww exists
if ! command -v swww >/dev/null 2>&1; then
  echo "[matugen-wall] ERROR: swww not found in PATH" | tee -a "$LOG" >&2
  exit 1
fi

# 3) Ensure swww-daemon is running
if ! pgrep -x swww-daemon >/dev/null 2>&1; then
  echo "[matugen-wall] starting swww-daemon" >> "$LOG"
  swww-daemon --format xrgb >> "$LOG" 2>&1 &
  sleep 0.3
else
  echo "[matugen-wall] swww-daemon already running" >> "$LOG"
fi

# 4) Get outputs from swww query (correct format)
# Expected lines like: "Output DP-1 ..."
OUTPUTS=$(swww query 2>>"$LOG" | awk '/^Output/ {print $2}')

if [[ -z "$OUTPUTS" ]]; then
  echo "[matugen-wall] WARNING: no outputs from swww query, applying once without -o" | tee -a "$LOG" >&2
  # Try at least once (some swww versions use a default output)
  swww img --transition-type center "$IMG" >>"$LOG" 2>&1 || {
    echo "[matugen-wall] ERROR: swww img failed without outputs" | tee -a "$LOG" >&2
    exit 1
  }
else
  echo "[matugen-wall] outputs: $OUTPUTS" >> "$LOG"
  for out in $OUTPUTS; do
    echo "[matugen-wall] swww img -o $out \"$IMG\"" >> "$LOG"
    swww img -o "$out" --transition-type center "$IMG" >>"$LOG" 2>&1
  done
fi

# 5) Generate restore script
RESTORE="$HOME/.local/bin/swww-restore.sh"
echo "[matugen-wall] writing restore script to $RESTORE" >> "$LOG"

cat > "$RESTORE" <<EOF
#!/usr/bin/env bash
set -euo pipefail

IMG="$IMG"

if ! command -v swww >/dev/null 2>&1; then
  echo "[swww-restore] ERROR: swww not found in PATH" >&2
  exit 1
fi

if ! pgrep -x swww-daemon >/dev/null 2>&1; then
  swww-daemon --format xrgb >/dev/null 2>&1 &
  sleep 0.3
fi

sleep 1.5

OUTPUTS=\$(swww query 2>/dev/null | awk '/^Output/ {print \$2}')

if [[ -z "\$OUTPUTS" ]]; then
  echo "[swww-restore] WARNING: no outputs from swww query, applying once without -o" >&2
  swww img --transition-type center "\$IMG"
  exit 0
fi

for out in \$OUTPUTS; do
  swww img -o "\$out" --transition-type center "\$IMG"
done
EOF

chmod +x "$RESTORE"
echo "[matugen-wall] DONE, restore script ready" >> "$LOG"

