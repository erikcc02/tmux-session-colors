# tmux-session-colors

Automatically assigns a unique color to each tmux window's status bar. Colors change when you create or navigate between windows with no configuration required.

## How it works

Each window gets a color derived from its ID using the [golden angle](https://en.wikipedia.org/wiki/Golden_angle) (~222°), which guarantees maximum perceptual distance between consecutive windows on the color wheel. The text color (black or white) is chosen automatically for contrast.

## Installation

### With TPM (recommended)

1. Add to `~/.tmux.conf`:

```tmux
set -g @plugin 'erikcc02/tmux-session-colors'
```

2. Press `Prefix + I` inside tmux to install.

### Manual

1. Clone the repo:

```bash
git clone https://github.com/erikcc02/tmux-session-colors ~/.tmux/plugins/tmux-session-colors
```

2. Add to `~/.tmux.conf`:

```tmux
run-shell '~/.tmux/plugins/tmux-session-colors/session-colors.tmux'
```

3. Reload tmux:

```bash
tmux source ~/.tmux.conf
```

## Requirements

- tmux 2.4+
- bash
- awk (standard on macOS and Linux)

## Uninstall

Remove the `run-shell` line (or `@plugin` entry) from `~/.tmux.conf` and reload.
