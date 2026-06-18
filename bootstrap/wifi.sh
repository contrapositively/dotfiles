#!/usr/bin/env bash
set -euo pipefail

out() { echo "[bootstrap/wifi] $1"; }


command -v nmcli >/dev/null 2>&1 || {
    out "nmcli not installed. Installing..."
    sudo pacman -S --needed --noconfirm networkmanager
}
systemctl is-active --quiet NetworkManager || {
    out "NetworkManager is not running. Starting..."
    sudo systemctl enable --now NetworkManager
}

out "Available network devices:"

nmcli device status

read -rp "Enter Wi-Fi device name (e.g. wlan0 / wlp2s0): (None to skip) " DEVICE
[[ -z $DEVICE ]] && exit 0;

# validate device exists and is wifi
TYPE=$(nmcli -t -f DEVICE,TYPE device status | awk -F: -v d="$DEVICE" '$1==d {print $2}')

if [[ "$TYPE" != "wifi" ]]; then
    out "Error: '$DEVICE' is not a Wi-Fi device"
    exit 1
fi

out "Scanning networks on $DEVICE..."
nmcli device wifi rescan ifname "$DEVICE"
nmcli device wifi list ifname "$DEVICE"

read -rp "SSID: " SSID
read -rsp "Password (leave empty for open networks): " PASS

if [[ -n "$PASS" ]]; then
    nmcli device wifi connect "$SSID" password "$PASS" ifname "$DEVICE"
else
    nmcli device wifi connect "$SSID" ifname "$DEVICE"
fi

out "Testing connection..."
ping -c 1 archlinux.org && out "Connected"
