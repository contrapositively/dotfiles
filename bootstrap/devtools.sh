#!/usr/bin/env bash
set -euo pipefail

out() { echo "[bootstrap/devtools] $1"; }

out "Installing LSPs..."
sudo pacman -S --needed --noconfirm \
    lua-language-server \
    pyright \
    ccls \
    clang \
    clang-tools-extra \
    texlab \
    godot \
    neovim

out "Installing tools..."
sudo pacman -S --needed --noconfirm \
    tree \
    make \
    gcc \
    bear \
    git

out "Configuring neovim..."
config link nvim

homefile link git

out "Configuring ~/proj..."
mkdir -p ~/proj/
touch ~/proj/.gitconfig
