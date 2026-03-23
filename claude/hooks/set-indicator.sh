#!/usr/bin/env bash
# Set tmux @indicator based on Claude hook events.
# Called from UserPromptSubmit, Stop, and Notification hooks.

# Fast path: if $TMUX is inherited, use it directly.
if [[ -n "$TMUX" && -n "$TMUX_PANE" ]]; then
  _set() { tmux set -p -t "$TMUX_PANE" @indicator "$1" 2>/dev/null; }
else
  # Hooks may not inherit $TMUX. Find the right server and pane
  # by walking up the PID tree across all tmux servers.
  TMUX_DIR="/private/tmp/tmux-$(id -u)"
  [[ -d "$TMUX_DIR" ]] || exit 0

  SOCK=""
  PANE=""
  pid=$$
  while [[ "$pid" -gt 1 && -z "$PANE" ]]; do
    for sock in "$TMUX_DIR"/*; do
      [[ -S "$sock" ]] || continue
      PANE=$(tmux -S "$sock" list-panes -a -F '#{pane_pid} #{pane_id}' 2>/dev/null \
        | awk -v p="$pid" '$1==p {print $2; exit}')
      if [[ -n "$PANE" ]]; then
        SOCK="$sock"
        break
      fi
    done
    pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
  done
  [[ -n "$PANE" ]] || exit 0

  _set() { tmux -S "$SOCK" set -p -t "$PANE" @indicator "$1" 2>/dev/null; }
fi

INPUT=$(cat)
EVENT=$(echo "$INPUT" | jq -r '.hook_event_name // ""')

case "$EVENT" in
  UserPromptSubmit) _set "⏳" ;;
  Stop)             _set "💤" ;;
  Notification)
    NOTIF_TYPE=$(echo "$INPUT" | jq -r '.notification_type // ""')
    case "$NOTIF_TYPE" in
      permission_prompt) _set "⚡" ;;
      *)                 _set "💤" ;;
    esac
    ;;
esac

exit 0
