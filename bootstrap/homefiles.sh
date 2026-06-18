#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
DOTFILES="$(cd -- "$SCRIPT_DIR/.." && pwd -P)"

out() { printf "[bootstrap/homefiles] %s\n" "$1"; }

# make .bashrc_dotfiles
out "bashrc_dotfiles"
if [[ -f "$HOME/.bashrc_dotfiles" ]]; then
    rm "$HOME/.bashrc_dotfiles"
fi
cat > "$HOME/.bashrc_dotfiles" <<EOF
export DOTFILES="$DOTFILES"
export DOTFILES_SCRIPTS="\$DOTFILES/scripts"
export DOTFILES_CONFIG="\$DOTFILES/config"
export DOTFILES_TEMPLATES="\$DOTFILES/file_templates"
export DOTFILES_HOMEFILES="\$DOTFILES/homefiles"
EOF

# link homefiles
for file in "$DOTFILES"/homefiles/*; do
    [[ -e "$file" ]] || continue

    name="$(basename "$file")"
    out "$name"
    source="$file"
	target="$HOME/.$name"
    if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
        continue
    fi
	if [[ -e "$target" || -L "$target" ]]; then
		out "Homefile $name already exists, replacing..."
		rm "$target"
	fi
	if [[ -f "$source" ]]; then
		ln -s "$source" "$target"
	else
		out "WARNING: Dotfile $name does not exist, skipping..."
	fi
done
