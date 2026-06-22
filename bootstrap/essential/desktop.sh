#!/usr/bin/env bash
set -euo pipefail

out() { echo "[essential/desktop] $1"; }

sudo pacman -S --needed --noconfirm \
    i3-wm \
    i3status \
    i3lock \
    picom \
    konsole \
    polybar \
    firefox \
    rofi

yay -S \
    cable

out "Desktop stack installed successfully"

config link \
    i3 \
    picom \
    konsole \
    polybar \
    pavucontrol \
    rofi \
    cable
homefile link \
    xinit
