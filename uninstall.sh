#!/bin/bash
set -euo pipefail

echo "==> Stopping and disabling omarchy-net-monitor service..."
systemctl --user stop omarchy-net-monitor.service 2>/dev/null || true
systemctl --user disable omarchy-net-monitor.service 2>/dev/null || true

echo "==> Removing systemd service file..."
rm -f "$HOME/.config/systemd/user/omarchy-net-monitor.service"
systemctl --user daemon-reload

echo "==> Removing omarchy-net-monitor binary..."
rm -f "$HOME/.local/bin/omarchy-net-monitor"

echo "==> Cleaning up runtime cache..."
rm -rf "${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/omarchy-net"

echo "==> omarchy-net-monitor removed successfully!"
