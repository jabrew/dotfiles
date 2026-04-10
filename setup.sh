#!/usr/bin/env bash
#
# Dotfiles setup — run on a fresh macOS machine after cloning to ~/dotfiles.
#
# Usage:
#   ./setup.sh                    # install everything
#   ./setup.sh --record-versions  # update Brewfile.versions from current installs
#
# Steps that need a password or external action are printed as manual
# instructions rather than run silently.
#
set -euo pipefail

# ── Platform check ──────────────────────────────────────────────────
if [[ "$(uname)" != "Darwin" ]]; then
  echo "Error: this setup script only supports macOS." >&2
  exit 1
fi

DOT="$HOME/dotfiles"
VERSIONS_FILE="$DOT/Brewfile.versions"

section() { printf '\n\033[1;34m==> %s\033[0m\n' "$1"; }

# ── --record-versions mode ──────────────────────────────────────────
if [[ "${1:-}" == "--record-versions" ]]; then
  section "Recording currently-installed versions to Brewfile.versions"
  {
    echo "# Known-working versions of Brewfile packages on this dotfiles setup."
    echo "# See comment in setup.sh. Regenerate with: ./setup.sh --record-versions"
    echo "# Format: <package> <version>"
    grep -E '^brew "' "$DOT/Brewfile" | sed 's/brew "\([^"]*\)"/\1/' | while read -r pkg; do
      brew list --versions "$pkg" 2>/dev/null || echo "# MISSING: $pkg"
    done
  } > "$VERSIONS_FILE"
  echo "Wrote $VERSIONS_FILE"
  exit 0
fi

# ── 1. Homebrew ──────────────────────────────────────────────────────
section "Homebrew"
if command -v brew &>/dev/null; then
  echo "Homebrew already installed."
else
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# ── 2. Packages ──────────────────────────────────────────────────────
section "Brew packages (from Brewfile)"
brew bundle --file="$DOT/Brewfile"

# Warn if installed versions drift from Brewfile.versions
if [[ -f "$VERSIONS_FILE" ]]; then
  drift=0
  while IFS=' ' read -r pkg recorded; do
    [[ "$pkg" =~ ^#.*$ || -z "$pkg" ]] && continue
    actual=$(brew list --versions "$pkg" 2>/dev/null | awk '{print $2}')
    if [[ -n "$actual" && "$actual" != "$recorded" ]]; then
      echo "  drift: $pkg installed=$actual recorded=$recorded"
      drift=1
    fi
  done < "$VERSIONS_FILE"
  if [[ "$drift" == 1 ]]; then
    echo "  (run './setup.sh --record-versions' after verifying things work)"
  fi
fi

# fzf key bindings and completion (idempotent)
"$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-bash --no-fish --no-update-rc

# ── 3. Default shell ─────────────────────────────────────────────────
section "Default shell"
if [[ "$SHELL" == */zsh ]]; then
  echo "Already using zsh."
else
  echo "Run manually (needs password):  chsh -s /bin/zsh"
fi

# ── 4. Plugins ───────────────────────────────────────────────────────
section "Plugins (from plugins.lock)"
"$DOT/install-plugins.sh"

# ── 5. Symlinks ──────────────────────────────────────────────────────
section "Symlinks"

# Create symlink; fail if dst already exists as something other than the
# correct symlink (real file, wrong symlink, directory, etc.).
link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [[ -L "$dst" ]]; then
    if [[ "$(readlink "$dst")" == "$src" ]]; then
      return  # already correct
    fi
    echo "Error: $dst is a symlink pointing to $(readlink "$dst"), expected $src" >&2
    exit 1
  fi
  if [[ -e "$dst" ]]; then
    echo "Error: $dst already exists (not a symlink). Remove it first." >&2
    exit 1
  fi
  ln -s "$src" "$dst"
  echo "  $dst -> $src"
}

# zsh
link "$DOT/zprezto/zshrc"        "$HOME/.zshrc"
link "$DOT/zprezto/zpreztorc"    "$HOME/.zpreztorc"
link "$DOT/zprezto/theme_p10k.zsh" "$HOME/.p10k.zsh"

# tmux
link "$DOT/tmux/tmux.conf"       "$HOME/.tmux.conf"

# git
link "$DOT/git/gitconfig"        "$HOME/.gitconfig"

# atuin
link "$DOT/atuin/config.toml"    "$HOME/.config/atuin/config.toml"

# fd global ignore (applies to fzf Ctrl-T/Ctrl-F)
link "$DOT/fd/fdignore"          "$HOME/.config/fd/ignore"

# claude code
link "$DOT/claude/settings.json"         "$HOME/.claude/settings.json"
link "$DOT/claude/CLAUDE.md"             "$HOME/.claude/CLAUDE.md"
link "$DOT/claude/claude-powerline.json" "$HOME/.claude/claude-powerline.json"
link "$DOT/claude/hooks/notify-done.sh"  "$HOME/.claude/hooks/notify-done.sh"
link "$DOT/claude/hooks/notify-input.sh" "$HOME/.claude/hooks/notify-input.sh"
link "$DOT/claude/hooks/set-indicator.sh" "$HOME/.claude/hooks/set-indicator.sh"
chmod +x "$DOT/claude/hooks/"*.sh

# hammerspoon
link "$DOT/hammerspoon/hammerspoon.lua" "$HOME/.hammerspoon/init.lua"

# ── 6. Import history ────────────────────────────────────────────────
section "Atuin history import"
if command -v atuin &>/dev/null; then
  atuin import auto 2>/dev/null || echo "No history to import (or already imported)."
else
  echo "Skipped — atuin not found."
fi

# ── 7. Manual steps ──────────────────────────────────────────────────
section "Manual steps remaining"
cat <<'EOF'
  iTerm2:
    - Font: SauceCodePro Nerd Font, 15pt
    - Window size: 120x45
    - Shift+Enter binding: Profiles → Keys → Key Mappings → +
      Keyboard shortcut: Shift+Enter, Action: Send escape sequence, value: \r

  GitHub SSH:
    - Generate key and add to GitHub

  Hammerspoon:
    - Run: hs.ipc.cliInstall('/Users/jbrewer')  (from Hammerspoon console)
    - May need: mkdir ~/bin
    - System Settings → Notifications → Hammerspoon → Allow Notifications

  Karabiner Elements:
    - Application -> Right Command
    - Caps lock -> F19
    - Right option -> right command (only on MS Natural)
    - Right command -> right option (only on MS Natural)
EOF

section "Done — restart your shell with: exec zsh"
