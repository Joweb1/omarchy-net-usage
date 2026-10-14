# Omarchy Network Usage Indicator (`jovibe.net-usage`)

A lightweight, beautiful, resource-efficient status bar widget for [Omarchy](https://omarchy.org/) Linux that displays live active network session data usage and persistent daily data consumption.

![Omarchy Bar](https://raw.githubusercontent.com/Joweb1/omarchy-net-usage/main/preview.png)

## Features

- **Indicator 1: Active Session Usage (`↕`)**
  - Displays total data consumed during the active network connection session (e.g. `↕ 245 MB`).
  - Automatically hidden when disconnected.
  - Automatically starts counting from zero when a new session begins or switches between Wi-Fi, Ethernet, and mobile hotspot.
  - Tracks upload and download totals separately with detailed hover tooltip.
- **Indicator 2: Daily Usage (`▦`)**
  - Displays cumulative daily network traffic (e.g. `▦ 1.42 GB`).
  - Remains visible even when offline.
  - Persists across reboots, sleep/resume, and connection cycles.
  - Automatically rolls over and resets at local midnight (using system timezone).
  - Handles interface counter resets cleanly without losing recorded data.
- **Theme & Wallpaper Harmonized**
  - Defaults to the exact theme foreground color of the active Omarchy theme and wallpaper.
- **Ultra-Lightweight**
  - Uses < 0.05% CPU on low-power hardware (such as dual-core Intel Celeron Bay Trail).
  - Directly samples Linux kernel `/proc/net/dev` and NetworkManager via `libnm`.
  - Excludes loopback (`lo`) and virtual interfaces (`tun*`, `tailscale*`, `docker*`), avoiding double counting.
  - Writes live indicators to RAM-backed tmpfs (`$XDG_RUNTIME_DIR`), causing zero flash/disk wear.

---

## Installation

### Method 1: Via Omarchy Plugin Manager (Recommended)

```bash
omarchy plugin add https://github.com/Joweb1/omarchy-net-usage.git --enable --yes
```

Run the background accounting daemon:
```bash
~/.config/omarchy/plugins/jovibe.net-usage/install.sh
```

### Method 2: Manual Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Joweb1/omarchy-net-usage.git ~/.config/omarchy/plugins/jovibe.net-usage
   ```
2. Install and enable the background service:
   ```bash
   ~/.config/omarchy/plugins/jovibe.net-usage/install.sh
   ```
3. Enable the plugin in your Omarchy status bar:
   ```bash
   omarchy plugin enable jovibe.net-usage
   ```

---

## Status and Verification

Inspect live statistics anytime from your terminal:
```bash
~/.local/bin/omarchy-net-monitor --status
```

Check the background service:
```bash
systemctl --user status omarchy-net-monitor.service
```

Manual resets (optional):
```bash
~/.local/bin/omarchy-net-monitor --reset-session
~/.local/bin/omarchy-net-monitor --reset-daily
```

---

## License

MIT License. See [LICENSE](LICENSE) for details.
