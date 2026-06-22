#!/usr/bin/env bash

set -e

out() {
    printf "[development/github-ssh] %s\n" "$1"
}

read -p "GitHub username: " GITHUB_USER
read -p "GitHub email: " GITHUB_EMAIL
read -s -p "SSH passphrase (leave empty for none): " PASSPHRASE
echo

KEY_PATH="$HOME/.ssh/id_ed25519_github_$GITHUB_USER"

mkdir -p "$HOME/.ssh"

if [ -z "$PASSPHRASE" ]; then
    ssh-keygen -t ed25519 -C "$GITHUB_EMAIL" -f "$KEY_PATH" -N ""
else
    ssh-keygen -t ed25519 -C "$GITHUB_EMAIL" -f "$KEY_PATH" -N "$PASSPHRASE"
fi

out "Key generated"

eval "$(ssh-agent -s)"
ssh-add "$KEY_PATH"

PUB_KEY="$KEY_PATH.pub"
if command -v xclip >/dev/null 2>&1; then
    cat "$PUB_KEY" | xclip -selection clipboard
    out "Copied public key to keyboard (link with GitHub)"
else
    out "WARNING: xclip not found. Displaying key."
    cat "$PUB_KEY"
fi
out "Enter to continue..."
read -r

ssh-keyscan github.com >> "$HOME/.ssh/known_hosts" 2>/dev/null

ssh -T git@github.com || true
out "github connection tested"
