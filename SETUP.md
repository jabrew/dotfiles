# New Machine Setup

## Quick Start

```sh
git clone git@github.com:jabrew/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

This installs Homebrew (if needed), all packages from `Brewfile`, plugins from
`plugins.lock`, creates symlinks, and imports shell history into atuin. Manual
steps that need interaction (iTerm2, SSH keys, Karabiner, Hammerspoon) are
printed at the end.


## Updating

**Brew packages:**
```sh
# Add/remove lines in Brewfile, then:
brew bundle --file=~/dotfiles/Brewfile
```

**Plugins:**
```sh
# Update all plugins to latest:
./install-plugins.sh --update
# Then update the SHAs in plugins.lock to pin the new versions.
```

**Re-run full setup** (idempotent — safe to re-run):
```sh
./setup.sh
```


## Usage Reference

**fzf (fuzzy finder) - searches the filesystem:**
- `Ctrl-R` - fuzzy search command history (atuin)
- `Ctrl-T` - fuzzy find files under cwd, paste path onto command line
- `Ctrl-F` - fuzzy find directories under cwd and cd into selection

**zoxide (directory jumping) - searches places you've been:**
- `z <query>` - jump to the best-matching directory you've visited before (ranked by frequency + recency)
- `zi` - interactive fzf picker over your visited directories

fzf searches the filesystem as it is now. zoxide remembers where you've been and gets smarter over time. On a fresh install, zoxide's database is empty and populates as you cd around.

**fzf-tab (fuzzy tab completion):**
- Any `<TAB>` completion uses fzf instead of the default zsh menu
- `/` on a selected directory drills into it (continuous completion)
- `<` and `>` cycle between completion groups (e.g. "common commands" vs "aliases" in git)
- `cd` and `ls` completions show an eza directory preview

**atuin (shell history TUI) - `Ctrl-R` to open:**
- Type to fuzzy filter, `Enter` to execute, `Tab` to paste without executing
- `Ctrl-S` cycles search mode: fuzzy / prefix / fulltext / subsequence
- `Ctrl-R` (while TUI is open) cycles filter: global / host / session / directory
- `Ctrl-D` deletes a history entry
- Directory filter is the killer feature: cd into a project and only see commands run there
- `atuin stats` shows most-used commands, `atuin history list` browses full history

**tmux copy mode (vi bindings) + tmux-yank:**
- Enter copy mode: `prefix + [` (then navigate with vi keys)
- `v` - start selection
- `V` - select whole line
- `Ctrl-v` - toggle rectangle/block selection
- `y` - yank selection to system clipboard (auto-detects pbcopy/xclip/xsel/wl-copy)
- `q` - exit copy mode
- `prefix + y` (in normal mode) - copy current command line to clipboard
- `prefix + Y` (in normal mode) - copy current working directory to clipboard

**extrakto (token extraction from tmux pane):**
- `prefix + Tab` - opens fzf picker over all text/tokens in the current pane
- Type to fuzzy filter, `Enter` to insert the selection, `Ctrl-Y` to copy to clipboard
- `Tab` cycles between word / path / url / line extraction modes
- Great for grabbing file paths, URLs, hashes, or any text visible in the pane

**tmux-fingers (vimium-style hints):**
- `prefix + /` - highlights copyable items (paths, URLs, hashes, IPs, etc.) with hint labels
- Type the hint label to copy that item to clipboard
- Similar to Vimium's link hints in a browser

**tmux window navigation:**
- `Shift-Left` / `Shift-Right` - previous/next window
- `Ctrl+Alt+Shift-Left` / `Ctrl+Alt+Shift-Right` - move window left/right
- `Alt-1` through `Alt-9` - jump to window by number
- `prefix + ;` - command prompt
- `prefix + :` - last pane

**tmux copy helpers:**
- `prefix + o` - copy last command's output to clipboard
- In copy mode: `o` - select and copy the command+output block at cursor
- In copy mode: `{` / `}` - jump between shell prompts
