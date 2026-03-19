#!/usr/bin/env bash
# Notify when Claude needs user input (Notification hook)
[[ "$(uname)" == "Darwin" ]] || exit 0

INPUT=$(cat)

CWD=$(echo "$INPUT" | jq -r '.cwd // ""')
DIR=$(basename "${CWD:-unknown}")
DIR="${DIR//\'/}"

# notification_type distinguishes why Claude is waiting, e.g.:
#   "permission_prompt" - needs approval to run a tool
#   "idle_prompt"       - waiting for next message
NOTIF_TYPE=$(echo "$INPUT" | jq -r '.notification_type // "input needed"')
case "$NOTIF_TYPE" in
  permission_prompt) REASON="Needs permission to run a tool" ;;
  idle_prompt)       REASON="Waiting for your next message" ;;
  *)                 REASON="${NOTIF_TYPE}" ;;
esac
REASON="${REASON//\'/}"

HS=/Users/jbrewer/bin/hs
if [[ -x "$HS" ]]; then
  "$HS" -c "hs.notify.new({title='Claude Code', subtitle='${DIR}', informativeText='${REASON}', soundName='Ping'}):send()" 2>/dev/null
else
  osascript -e "display notification \"${REASON}\" with title \"Claude Code\" subtitle \"${DIR}\" sound name \"Ping\""
fi

# Set tmux indicator
if [[ -n "$TMUX" ]]; then
  case "$NOTIF_TYPE" in
    permission_prompt) tmux set -p @indicator "⚡" 2>/dev/null ;;
    *)                 tmux set -p @indicator "💤" 2>/dev/null ;;
  esac
fi

exit 0
