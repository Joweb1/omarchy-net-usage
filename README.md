# Omarchy Network Usage (`jovibe.net-usage`)

A lightweight status bar widget for [Omarchy](https://omarchy.org/) that shows
live session data usage and persistent daily data consumption.

![Omarchy Bar](preview.png)

## Features

- **Active session usage (`↕`)** — total traffic for the current connection.
  Hidden while offline, starts from zero on a new connection, and switches
  cleanly between Wi-Fi, Ethernet, and mobile hotspot.
- **Daily usage (`▦`)** — cumulative traffic for today, visible even when
  offline. Persists across reboots and sleep/resume and rolls over at local
  midnight.
- **Lightweight** — samples `/proc/net/dev` and NetworkManager directly,
  ignores loopback/virtual interfaces, and writes live values to
  `$XDG_RUNTIME_DIR` (tmpfs).
- **Theme aware** — uses the active Omarchy bar foreground color.

## Install

```sh
omarchy plugin add https://github.com/Joweb1/omarchy-net-usage.git --enable
```

If `--enable` prints `omarchy-shell is not responding`, the shell is still
busy reloading plugins and the clone has already succeeded. Give the IPC call
more time (or enable it afterwards):

```sh
OMARCHY_SHELL_IPC_TIMEOUT=20s omarchy plugin add \
  https://github.com/Joweb1/omarchy-net-usage.git --enable
```

The widget starts and stops its own monitor process. There is no installer
script, no systemd unit, and no file copied outside the plugin directory.

## Usage

The widget appears in the bar's right section by default. Hover either value
for download/upload details.

Move it:

```sh
omarchy bar move jovibe.net-usage --section right
```

Daily history is kept in `~/.local/state/omarchy/network-usage/`. Live values
are written to `$XDG_RUNTIME_DIR/omarchy-net/`.

## Dependencies

- `python3`
- `python-gobject` (PyGObject) and `libnm` for NetworkManager access
- `NetworkManager` (a kernel `/proc/net/dev` fallback is used if libnm is
  unavailable)

## Upgrading from the standalone service

Older versions were installed with `install.sh`: a copy of the monitor in
`~/.local/bin/` plus an enabled `omarchy-net-monitor.service` systemd user unit.
Two monitors would overwrite each other's usage files, so the widget now retires
the old install itself the first time it starts after you update. In order, it:

1. backs up your history to `~/.local/state/omarchy/network-usage/daily.json.pre-migration`,
2. stops and disables the old service (it saves its counters when stopped), and removes the unit,
3. stops any leftover old monitor process and removes `~/.local/bin/omarchy-net-monitor`,
4. only then loads `daily.json` and takes over, so your daily history carries on unbroken.

It only removes things that are provably the old install: a unit whose `ExecStart`
runs `omarchy-net-monitor`, and a script that carries the old monitor's signature. A
unit or file you customised is left alone. If the old service cannot be stopped,
the new monitor refuses to start rather than run alongside it, and tries again every
few seconds. A lock also guarantees only one monitor runs at a time.

To run the migration by hand, or check it is finished:

```sh
python3 ~/.config/omarchy/plugins/jovibe.net-usage/bin/omarchy-net-monitor --migrate-legacy
```

If the log mentions an autostart file (for example in `~/.config/hypr/`) that still
starts the old monitor, delete that line.

## Remove

```sh
omarchy plugin remove jovibe.net-usage
```

The monitor stops with the widget. If you still have the old standalone service
(you never updated), the removal does not touch it, so run the migration above first,
or retire it directly:

```sh
systemctl --user disable --now omarchy-net-monitor.service
rm -f ~/.config/systemd/user/omarchy-net-monitor.service ~/.local/bin/omarchy-net-monitor
systemctl --user daemon-reload
```

Optionally delete the saved daily history:

```sh
rm -rf ~/.local/state/omarchy/network-usage
```

## License

MIT. See [LICENSE](LICENSE).
