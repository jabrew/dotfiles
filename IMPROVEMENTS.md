# Dotfiles Improvement Plan

Status: Reviewed - comments on lines starting with ">"


## Phase 1: Quick Wins (low risk, high impact)

### 1. Remove `reattach-to-user-namespace`
- File: `tmux/tmux-macos`
- Not needed since tmux 2.6+ on macOS Yosemite+
- Just keep `set -g default-shell $SHELL` and `set -g mouse on`
- Effort: 2 min

### 2. Upgrade tmux to 3.6a
- Current: 3.3a, Latest: 3.6a (3 major versions behind)
- Gains: pane scrollbars, multi-line status bars, line continuation in config, SIXEL image support, better Unicode/emoji handling, case-insensitive search in copy mode
- `brew upgrade tmux`
- Effort: 5 min

### 3. Install fzf
- Not currently installed at all
- Provides: fuzzy history search (Ctrl-R), file finder (Ctrl-T), directory jump (Alt-C)
- `brew install fzf && $(brew --prefix)/opt/fzf/install`
- Single biggest UX improvement available
- Effort: 5 min

### 4. Replace fasd with zoxide
- fasd is abandoned/unmaintained
- zoxide is the modern replacement (Rust, fast, actively maintained)
- Can import existing data: `zoxide import --from=fasd ~/.fasd`
- Keeps `z` alias working, adds `zi` for interactive fzf picker
- Remove prezto `fasd` module, add `eval "$(zoxide init zsh)"` to zshrc
- Effort: 10 min

### 5. Wire up installed-but-unused tools
- `bat`: set `BAT_THEME` for solarized (no cat alias - use bat directly when wanted)
- `fd`: set as fzf default command (`export FZF_DEFAULT_COMMAND='fd --type f'`)
- `git-delta`: ensure configured in `~/.gitconfig` as pager
- `~/.gitconfig`: add to dotfiles repo and symlink (new tracked file)
- `ripgrep`: confirmed already available as `rg` at `/opt/homebrew/bin/rg` (not an alias, direct binary). `rgp` alias in zshrc is a convenience wrapper for `rg -t py`.
- Effort: 10 min

### 6. Clean up tmux-linux
- File: `tmux/tmux-linux`
- Remove all dead version checks for tmux < 2.1 and < 2.2
- Move vi-copy bindings to main config or remove
- Keep a linux-specific config file with just `set -g mouse on`
- Effort: 5 min

### 7. Fix setup.sh references
- `exa` was renamed to `eza` - update the brew install line
- Drop `the_silver_searcher` - ripgrep has superseded it
- Effort: 2 min


---

## Phase 2: Active Improvements

### 9. Set up vi-copy bindings
- Currently commented out and never finished
- Add native tmux 3.2+ bindings: `v` to begin-selection, `y` to copy-pipe-and-cancel with pbcopy/xclip
- Effort: 5 min

### 10. Enable new tmux 3.6 features
- Pane scrollbars: `set -g pane-scrollbars on`
- Consider multi-line status bar for richer info
- `set -g allow-passthrough on` for image protocols if using a capable terminal
- Effort: 10 min

### 12. Powerlevel10k - tune existing config
- Changes to make in `zprezto/theme_p10k.zsh`:
  - **`context` segment**: already in right prompt elements. Configure to only show on SSH or root (set `POWERLEVEL9K_CONTEXT_DEFAULT_CONTENT_EXPANSION=` to empty, keep `POWERLEVEL9K_CONTEXT_{REMOTE,ROOT}_*` defaults so it only renders in those cases).
  - **`time` segment**: NOT currently in right prompt elements array despite being configured. Add `time` to `POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS`.
> This is definitely already there, it may be setup differently than you anticipate, but I can see it in my prompt right now
  - **`command_execution_time`**: currently `POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3` (hidden under 3s). Change to `0` so it always shows.
  - **`status` (exit code on failure)**: currently `POWERLEVEL9K_STATUS_ERROR=false` which hides non-zero exit codes. Change to `true` so failed commands show their exit code. Signal and pipe errors already show.
> Make this this shows up on the right side
- Effort: 5 min

### 13. Install fzf-tab
- Replaces zsh default completion menu with fzf-powered fuzzy matching
- Works for all completions: files, dirs, command args, variables
- Must load after compinit but before autosuggestions/syntax-highlighting
- Effort: 10 min

### 14. Install Atuin (local mode)
- `brew install atuin`
- Add `eval "$(atuin init zsh)"` to zshrc
- Configure local-only mode (no network sync): set `sync_address = ""` and `auto_sync = false` in `~/.config/atuin/config.toml`
- Import existing zsh history: `atuin import auto`
- Effort: 15 min

### 15. Switch to fast-syntax-highlighting
- Drop-in replacement for `zsh-syntax-highlighting`
- Better git-aware highlighting, bracket matching, per-command themes
- `zdharma-continuum/fast-syntax-highlighting`
- Effort: 5 min

### 16. Evaluate Prezto vs lighter alternatives
- Prezto maintenance has slowed significantly
- Alternatives: antidote, zimfw, or just manual sourcing
- Will build a separate detailed plan before any implementation
- Effort: 1-2 hrs

### 18. Consolidate tmux-macos and tmux-linux
- Keep separate OS-specific config files
- Clean up linux file to remove dead version checks while preserving linux-specific settings
- Main tmux.conf continues to source per-OS files via `if-shell`
- Effort: 10 min

### 19. Create documentation (KEYBINDINGS.md)
- New file in this repo documenting key bindings and workflows
- Cover: tmux keybindings (prefix key, window/pane navigation, copy mode, vi-copy bindings), zsh keybindings (history search, word movement, fzf shortcuts), and useful aliases defined in zshrc
- Keep it as a living reference that updates as config changes
- Effort: 15 min


---

## Phase 3: Cleanup

### 17. Remove stale/dead code
- Old tmux 2.6 color comments (lines 81-116 of tmux.conf)
- Old powerline references in zshrc
- Drop `the_silver_searcher` references
- Unused server-specific aliases if no longer relevant
- Effort: 15 min


---

## Future Work (to revisit later)

### 8. Install TPM and core plugins
- TPM (tmux plugin manager): `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
- Plugins to consider:
  - `tmux-plugins/tmux-sensible` - sane defaults
  - `tmux-plugins/tmux-resurrect` - save/restore sessions (prefix + Ctrl-s / Ctrl-r)
  - `tmux-plugins/tmux-continuum` - auto-save sessions every 15 min
  - `tmux-plugins/tmux-yank` - clipboard integration
  - `tmux-plugins/tmux-open` - open URLs/files from copy mode

### 11. Add tmux-fzf or session management
- `sainnhe/tmux-fzf` - fuzzy session/window/pane switching
- `fcsonline/tmux-thumbs` / `Morantron/tmux-fingers` - vimium-style quick copy from pane output

### 16. Evaluate Prezto vs lighter alternatives
- Prezto is working fine and not blocking anything
- All modern plugins (fzf-tab, fast-syntax-highlighting, zoxide, atuin) already bypass prezto
- Prezto is mostly just a bootloader for compinit and default options at this point
- Migration risk: subtle breakages from missed options/bindings set by prezto modules
- No functionality gain - purely preventative against future prezto abandonment
- If pursued, use "gradual extraction" approach: read each module, copy needed lines, remove one at a time
- Alternatives: antidote (simple static bundler), zimfw (faster framework), or no manager at all


---

## Completed

Items 1, 2, 3, 4, 5, 6, 7, 9, 10, 12, 13, 14, 15, 17, 18, 19 (covered by TEST-CHECKLIST.md)
