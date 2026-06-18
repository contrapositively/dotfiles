#!/usr/bin/env bash
set -euo pipefail

REPO="https://github.com/<user>/<repo>.git"
TARGET="dotfiles"
BRANCH="main"

out() { printf "[setup] %s\n" "$1"; }

cat <<EOF

===========================================================
 DOTFILES BOOTSTRAP
===========================================================

This program is meant only to run on a fresh installation of Arch Linux.

Type exactly:
    I UNDERSTAND

to continue.

EOF

read -r CONFIRM
[[ "$CONFIRM" == "I UNDERSTAND" ]] || exit 1

[[ -d /mnt/etc ]] || { out "ERROR: Missing /mnt"; exit 1; }

ping -c 1 archlinux.org >/dev/null || { out "ERROR: No internet"; exit 1; }

# root password
while true; do
    read -rsp "ROOT Password: " PASSWORD; echo
    [[ -n "$ROOT_PASSWORD" ]] || continue

    read -rsp "Confirm ROOT: " PASSWORD_CONFIRM; echo
    [[ "$ROOT_PASSWORD" == "$ROOT_PASSWORD_CONFIRM" ]] && break
    out "Passwords do not match"
done

# username
while true; do
    read -rp "Enter username: " USERNAME
    [[ "$USERNAME" =~ ^[a-z_][a-z0-9_-]*$ ]] && break
done

# password
while true; do
    read -rsp "Password: " PASSWORD; echo
    [[ -n "$PASSWORD" ]] || continue

    read -rsp "Confirm: " PASSWORD_CONFIRM; echo
    [[ "$PASSWORD" == "$PASSWORD_CONFIRM" ]] && break
    out "Passwords do not match"
done

# setup root
pacstrap /mnt \
    base linux linux-firmware \
    git sudo networkmanager
genfstab -U /mnt > /mnt/etc/fstab.new
mv /mnt/etc/fstab.new /mnt/etc/fstab

arch-chroot /mnt /bin/bash <<EOF
set -euo pipefail

printf 'root:%s\n' "$ROOT_PASSWORD" | chpasswd

id "$USERNAME" &>/dev/null || \
useradd -m -G wheel -s /bin/bash "$USERNAME"

printf '%s:%s\n' "$USERNAME" "$PASSWORD" | chpasswd

sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

systemctl is-enabled NetworkManager &>/dev/null || \
systemctl enable NetworkManager
EOF

arch-chroot /mnt /bin/bash -s <<EOF
set -euo pipefail

pacman -S --needed --noconfirm git

sudo -u "$USERNAME" bash <<INNER
set -e
cd ~
if [[ ! -d "$TARGET"/.git ]]; then
    git clone --depth=1 --single-branch --branch "$BRANCH" "$REPO" "$TARGET"
fi
INNER
EOF
