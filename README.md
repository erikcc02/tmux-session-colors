# tmux-session-colors

Automatically assigns a unique, visually distinct color to each tmux **window's** status bar — changes on create or navigate. Zero config required.

## How it works

Each window's ID is multiplied by the golden angle (~222°) and taken mod 360 to produce a hue. This guarantees that even adjacent window IDs land far apart on the color wheel — no two neighboring windows share similar colors.

The foreground (text) color is automatically chosen for contrast (black on light backgrounds, white on dark).

## Installation

### With TPM (Tmux Plugin Manager)

Add to `~/.tmux.conf`:

```tmux
set -g @plugin 'erikcc02/tmux-session-colors'
```

Then press `Prefix + I` to install.

### Manual

Clone the repo and source the entry point in `~/.tmux.conf`:

```tmux
run-shell '/path/to/tmux-session-colors/session-colors.tmux'
```

## Requirements

- tmux 2.1+
- bash + awk (both available on macOS and Linux by default)
