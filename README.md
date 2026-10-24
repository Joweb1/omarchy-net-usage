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

## Remove

```sh
omarchy plugin remove jovibe.net-usage
```

The monitor stops with the widget. Optionally delete the saved daily history:

```sh
rm -rf ~/.local/state/omarchy/network-usage
```

## License

MIT. See [LICENSE](LICENSE).
