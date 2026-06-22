#!/bin/bash
set -euo pipefail

: "${DOTFILES:?DOTFILES is not set}"

out() { printf "[essential/scripts] %s\n" "$1"; }

BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"

# enable scripts
for file in "$DOTFILES_SCRIPTS"/*; do
    [[ -e "$file" ]] || continue
    if [[ -f "$file" ]]; then
        name="$(basename "$file")"
        target="$BIN_DIR/$name"

        out "$name"
        ln -sf "$file" "$target"
        [[ -x "$file" ]] || chmod +x "$file"
        [[ -x "$target" ]] || chmod +x "$target"
    fi
done
