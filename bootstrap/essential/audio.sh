#!/usr/bin/env bash
set -euo pipefail

out() { echo "[essential/audio] $1"; }

if ! command -v pactl >/dev/null 2>&1; then
    out "PipeWire audio stack not found. Installing..."

    sudo pacman -S --needed --noconfirm \
        pipewire \
        pipewire-pulse \
        wireplumber
fi

if systemctl --user list-unit-files >/dev/null 2>&1; then
    systemctl --user enable --now \
        pipewire \
        pipewire-pulse \
        wireplumber || true
fi

if ! pactl info >/dev/null 2>&1; then
    out "Restarting PipeWire..."
    systemctl --user restart pipewire wireplumber pipewire-pulse || true
fi

pactl info >/dev/null 2>&1 || {
    out "Audio stack still not working"
    exit 1
}

out "Available audio sinks:"
pactl list short sinks

read -rp "Select sink: (None to skip) " SINK
[[ -z $SINK ]] && exit 0;
read -rp "Volume (e.g. 50%): " VOL
pactl set-sink-volume "$SINK" "$VOL"

config link pulse
