#!/bin/bash
# Focus (pomodoro-style) timer for waybar.
#
# Usage:
#   focus-timer.sh              print current status as JSON for waybar
#   focus-timer.sh toggle        start / pause / resume
#   focus-timer.sh reset         stop and reset to the configured duration
#   focus-timer.sh inc           add 5 minutes to the configured duration (idle only)
#   focus-timer.sh dec           remove 5 minutes from the configured duration (idle only)

STATE_DIR="${XDG_RUNTIME_DIR:-/tmp}/focus-timer"
STATE_FILE="$STATE_DIR/state"
DEFAULT_DURATION=$((25 * 60))
STEP=$((5 * 60))
MIN_DURATION=$((5 * 60))
MAX_DURATION=$((120 * 60))

mkdir -p "$STATE_DIR"

# state file: status(idle|running|paused) duration(seconds) remaining(seconds) end_epoch
load() {
    if [[ -f "$STATE_FILE" ]]; then
        source "$STATE_FILE"
    fi
    status="${status:-idle}"
    duration="${duration:-$DEFAULT_DURATION}"
    remaining="${remaining:-$duration}"
    end_epoch="${end_epoch:-0}"
}

save() {
    printf 'status=%s\nduration=%s\nremaining=%s\nend_epoch=%s\n' \
        "$status" "$duration" "$remaining" "$end_epoch" > "$STATE_FILE"
}

notify_done() {
    command -v notify-send >/dev/null 2>&1 && \
        notify-send -u critical -a "Focus Timer" "Focus session complete" "Time for a break." 2>/dev/null
}

fmt() {
    local s=$1
    printf '%02d:%02d' $((s / 60)) $((s % 60))
}

case "$1" in
    toggle)
        load
        now=$(date +%s)
        case "$status" in
            idle)
                status="running"
                end_epoch=$((now + remaining))
                ;;
            running)
                status="paused"
                remaining=$((end_epoch - now))
                (( remaining < 0 )) && remaining=0
                ;;
            paused)
                status="running"
                end_epoch=$((now + remaining))
                ;;
        esac
        save
        ;;
    reset)
        load
        status="idle"
        remaining="$duration"
        end_epoch=0
        save
        ;;
    inc)
        load
        if [[ "$status" == "idle" ]]; then
            duration=$((duration + STEP))
            (( duration > MAX_DURATION )) && duration=$MAX_DURATION
            remaining="$duration"
            save
        fi
        ;;
    dec)
        load
        if [[ "$status" == "idle" ]]; then
            duration=$((duration - STEP))
            (( duration < MIN_DURATION )) && duration=$MIN_DURATION
            remaining="$duration"
            save
        fi
        ;;
    *)
        load
        if [[ "$status" == "running" ]]; then
            now=$(date +%s)
            remaining=$((end_epoch - now))
            if (( remaining <= 0 )); then
                notify_done
                status="idle"
                remaining="$duration"
                end_epoch=0
                save
            fi
        fi

        case "$status" in
            running) icon="󰐎" ;;
            paused)  icon="󰏤" ;;
            *)       icon="󰄉" ;;
        esac

        printf '{"text":"%s %s","class":"%s","tooltip":"Focus timer (%s)\\nLeft click: start/pause\\nRight click: reset\\nScroll: +/- 5 min"}\n' \
            "$icon" "$(fmt "$remaining")" "$status" "$status"
        ;;
esac
