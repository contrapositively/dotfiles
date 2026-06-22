#!/usr/bin/env bash
set -euo pipefail

out() { echo "[gaming/steam] $1"; }


sudo pacman -S --needed --noconfirm \
    steam \
    lutris \
    gamemode \
    mangohud \
    lib32-glibc \
    lib32-gcc-libs \
    vulkan-icd-loader \
    lib32-vulkan-icd-loader \
    wine \
    winetricks \
    gvfs \
    xorg-xrandr


command -v steam >/dev/null && out "Steam OK"
command -v lutris >/dev/null && out "Lutris OK"
command -v mangohud >/dev/null && out "MangoHud OK"
command -v gamemoderun >/dev/null && out "GameMode OK"
