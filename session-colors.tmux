#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Navigation: Ctrl-b n/p/0-9 and any explicit select-window.
tmux set-hook -g after-select-window \
  "run-shell '$CURRENT_DIR/scripts/set_color.sh \"#{session_name}\" \"#{window_id}\"'"

# Catch-all: fires whenever the client's focused window changes for any reason,
# including after a window is destroyed and tmux auto-switches.
tmux set-hook -g client-window-changed \
  "run-shell '$CURRENT_DIR/scripts/set_color.sh \"#{session_name}\" \"#{window_id}\"'"

# New window created/linked.
tmux set-hook -g window-linked \
  "run-shell '$CURRENT_DIR/scripts/set_color.sh \"#{session_name}\" \"#{window_id}\"'"

# Window destroyed (Ctrl+d, exit, kill-window, etc.) — #{window_id} is the dead window,
# so we pass only the session name and let the script query the now-active window.
tmux set-hook -g window-unlinked \
  "run-shell '$CURRENT_DIR/scripts/set_color.sh \"#{session_name}\"'"

# On plugin load: color the active window in each open session.
while IFS= read -r session; do
  wid="$(tmux display-message -t "$session" -p '#{window_id}' 2>/dev/null)"
  [ -n "$wid" ] && "$CURRENT_DIR/scripts/set_color.sh" "$session" "$wid"
done < <(tmux list-sessions -F '#S' 2>/dev/null)
