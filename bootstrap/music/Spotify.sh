#!/usr/bin/env bash
set -euo pipefail

out() { echo "[music/Spotify] $1"; }

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

