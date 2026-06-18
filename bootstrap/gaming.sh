#!/usr/bin/env bash
set -euo pipefail

out() { echo "[bootstrap/apps] $1"; }

out "flatpak"
if ! command -v flatpak >/dev/null 2>&1; then
    sudo pacman -S --needed --noconfirm flatpak
fi
if ! flatpak remote-list | grep -q flathub; then
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

out "Spotify"
if ! flatpak list | grep -q com.spotify.Client; then
    flatpak install -y flathub com.spotify.Client
fi

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
