#!/usr/bin/env bash
# Notify when Claude finishes a response (Stop hook)
[[ "$(uname)" == "Darwin" ]] || exit 0

INPUT=$(cat)

# Guard: stop_hook_active=true means a Stop hook already ran this turn,
# skipping to prevent infinite loops.
STOP_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active // false')
if [ "$STOP_ACTIVE" = "true" ]; then
  exit 0
fi

CWD=$(echo "$INPUT" | jq -r '.cwd // ""')
DIR=$(basename "${CWD:-unknown}")
# Sanitize: remove single quotes so Lua string literal stays valid
DIR="${DIR//\'/}"

HS=/Users/jbrewer/bin/hs
if [[ -x "$HS" ]]; then
  "$HS" -c "hs.notify.new({title='Claude Code', subtitle='${DIR}', informativeText='Response complete', soundName='Glass'}):send()" 2>/dev/null
else
  osascript -e "display notification \"Response complete\" with title \"Claude Code\" subtitle \"${DIR}\" sound name \"Glass\""
fi

# Set tmux indicator to idle
if [[ -n "$TMUX" ]]; then
  tmux set -p @indicator "💤" 2>/dev/null
fi

exit 0
