#!/usr/bin/env bash
set -euo pipefail

out() { echo "[essential/drivers] $1"; }

GPU_INFO="$(lspci | grep -E "VGA|3D|Display" || true)"

out "Detected GPU: $GPU_INFO"

out "Vulkan"
sudo pacman -S --needed --noconfirm \
    vulkan-icd-loader \
    vulkan-tools \
    lib32-vulkan-icd-loader

if echo "$GPU_INFO" | grep -qi nvidia; then
    out "NVIDIA"
    sudo pacman -S --needed --noconfirm \
        nvidia-open \
        nvidia-utils \
        lib32-nvidia-utils

elif echo "$GPU_INFO" | grep -qi amd; then
    out "AMD"

    sudo pacman -S --needed --noconfirm \
        mesa \
        lib32-mesa \
        vulkan-radeon \
        lib32-vulkan-radeon

elif echo "$GPU_INFO" | grep -qi intel; then
    out "Intel"

    sudo pacman -S --needed --noconfirm \
        mesa \
        lib32-mesa \
        vulkan-intel \
        lib32-vulkan-intel
else
    out "GPU Unknown"
fi

if command -v vulkaninfo >/dev/null 2>&1; then
    out "Vulkan OK"
fi
