#!/usr/bin/env bash
set -euo pipefail

out() { echo "[bootstrap/desktop] $1"; }

sudo pacman -S --needed --noconfirm \
    i3-wm \
    i3status \
    i3lock \
    picom \
    konsole \
    polybar \
    pavucontrol \
    firefox \
    rofi

out "Desktop stack installed successfully (i3 + picom + konsole)"

config link i3 picom konsole polybar pavucontrol rofi
homefile link xinitrc
