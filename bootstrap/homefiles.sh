#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
DOTFILES="$(cd -- "$SCRIPT_DIR/.." && pwd -P)"

out() { printf "[bootstrap/homefiles] %s\n" "$1"; }

out "~/.bashrc_dotfiles"
if [[ -f "$HOME/.bashrc_dotfiles" ]]; then
    rm "$HOME/.bashrc_dotfiles"
fi
cat > "$HOME/.bashrc_dotfiles" <<EOF
export DOTFILES="$DOTFILES"
export DOTFILES_SCRIPTS="\$DOTFILES/scripts"
export DOTFILES_CONFIG="\$DOTFILES/configs"
export DOTFILES_TEMPLATES="\$DOTFILES/templates"
export DOTFILES_HOMEFILES="\$DOTFILES/homefiles"
EOF


for file in "$DOTFILES"/homefiles/bash/*; do
    name=$(basename "$file")
    source="$file"
    target="$HOME/.$name"
    ln -fs "$source" "$target"
    out "~/.$name"
done
