#!/usr/bin/env bash
# Usage: set_color.sh <session_name> <window_id>
# window_id format: @N (e.g., @1, @12)

SESSION_NAME="$1"
WINDOW_ID="$2"

if [ -z "$SESSION_NAME" ]; then
  exit 0
fi

# If window_id not provided (e.g. called after a window close), query the current active window.
if [ -z "$WINDOW_ID" ]; then
  WINDOW_ID=$(tmux display-message -t "$SESSION_NAME" -p '#{window_id}' 2>/dev/null)
fi

if [ -z "$WINDOW_ID" ]; then
  exit 0
fi

# Extract numeric part from window_id (e.g., "@12" -> "12")
WIN_NUM="${WINDOW_ID#@}"

# Golden angle (≈222.5°): consecutive windows land maximally far apart on the hue wheel.
GOLDEN_ANGLE=222
HUE=$(( (WIN_NUM * GOLDEN_ANGLE) % 360 ))

# Fixed saturation / lightness: vivid but not blinding
SATURATION=65
LIGHTNESS=42

# Single awk call: HSL → RGB + auto-contrast FG. Pure POSIX awk, no gawk extensions.
COLORS=$(awk -v h="$HUE" -v s="$SATURATION" -v l="$LIGHTNESS" 'BEGIN {
    s /= 100; l /= 100
    abs2l1 = 2*l - 1; if (abs2l1 < 0) abs2l1 = -abs2l1
    c = (1 - abs2l1) * s
    hp = h / 60
    hp_mod2 = hp % 2
    tmp = hp_mod2 - 1; if (tmp < 0) tmp = -tmp
    x = c * (1 - tmp)
    m = l - c / 2
    sector = int(hp) % 6
    if      (sector == 0) { r=c; g=x; b=0 }
    else if (sector == 1) { r=x; g=c; b=0 }
    else if (sector == 2) { r=0; g=c; b=x }
    else if (sector == 3) { r=0; g=x; b=c }
    else if (sector == 4) { r=x; g=0; b=c }
    else                  { r=c; g=0; b=x }
    R = int((r+m)*255 + 0.5)
    G = int((g+m)*255 + 0.5)
    B = int((b+m)*255 + 0.5)
    lum = 0.299*R + 0.587*G + 0.114*B
    fg = (lum > 128) ? "#000000" : "#FFFFFF"
    printf "#%02X%02X%02X %s\n", R, G, B, fg
}')

BG="${COLORS% *}"
FG="${COLORS#* }"

# Apply colors — suppress all output; script must always exit 0 to avoid tmux error messages.
tmux set-option -t "$SESSION_NAME" status-bg "$BG" 2>/dev/null || true
tmux set-option -t "$SESSION_NAME" status-fg "$FG" 2>/dev/null || true

exit 0
