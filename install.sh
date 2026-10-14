#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Installing omarchy-net-monitor daemon..."
mkdir -p "$HOME/.local/bin"
cp -f "$SCRIPT_DIR/bin/omarchy-net-monitor" "$HOME/.local/bin/"
chmod +x "$HOME/.local/bin/omarchy-net-monitor"

echo "==> Installing systemd user service..."
mkdir -p "$HOME/.config/systemd/user"
cp -f "$SCRIPT_DIR/systemd/omarchy-net-monitor.service" "$HOME/.config/systemd/user/"

systemctl --user daemon-reload
systemctl --user enable --now omarchy-net-monitor.service

echo "==> omarchy-net-monitor installed and running successfully!"
