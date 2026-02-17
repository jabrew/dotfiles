# New Machine Setup

Step-by-step guide for setting up a new machine from this dotfiles repo.


## 1. Homebrew

Install Homebrew if not already present:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```


## 2. Core Packages

```sh
brew install zsh tmux jq

# CLI tools
brew install fd ripgrep git-delta eza bat

# Fuzzy finder
brew install fzf
$(brew --prefix)/opt/fzf/install --key-bindings --completion --no-bash --no-fish --no-update-rc

# Directory jumping (replaces fasd)
brew install zoxide

# Shell history
brew install atuin

# Git status numbering
brew install scmpuff
```


## 3. Shell

Set zsh as default shell if not already:

```sh
chsh -s /bin/zsh
```


## 4. Prezto

```sh
git clone --recursive https://github.com/sorin-ionescu/prezto.git ${ZDOTDIR:-$HOME}/.zprezto
```


## 5. Symlinks

```sh
DOT_ROOT=~/dotfiles

# zsh
ln -sf $DOT_ROOT/zprezto/zshrc ~/.zshrc
ln -sf $DOT_ROOT/zprezto/zpreztorc ~/.zpreztorc
ln -sf $DOT_ROOT/zprezto/theme_p10k.zsh ~/.p10k.zsh

# tmux
ln -sf $DOT_ROOT/tmux/tmux.conf ~/.tmux.conf

# git
ln -sf $DOT_ROOT/git/gitconfig ~/.gitconfig
```


## 6. Atuin (local mode, no network)

```sh
mkdir -p ~/.config/atuin
cat > ~/.config/atuin/config.toml << 'EOF'
## Local-only mode - no network sync
sync_address = ""
auto_sync = false
EOF
```

Import existing zsh history if available:

```sh
atuin import auto
```


## 7. Zoxide - import fasd data (if migrating)

Only needed if migrating from a machine that used fasd:

```sh
zoxide import --from=fasd ~/.fasd
```


## 8. Usage Reference

**fzf (fuzzy finder) - searches the filesystem:**
- `Ctrl-R` - fuzzy search command history
- `Ctrl-T` - fuzzy find files under cwd, paste path onto command line
- `Ctrl-F` - fuzzy find directories under cwd and cd into selection

**zoxide (directory jumping) - searches places you've been:**
- `z <query>` - jump to the best-matching directory you've visited before (ranked by frequency + recency)
- `zi` - interactive fzf picker over your visited directories

fzf searches the filesystem as it is now. zoxide remembers where you've been and gets smarter over time. On a fresh install, zoxide's database is empty and populates as you cd around.

**tmux copy mode (vi bindings):**
- Enter copy mode: `prefix + [` (then navigate with vi keys)
- `v` - start selection
- `V` - select whole line
- `Ctrl-v` - toggle rectangle/block selection
- `y` - yank selection to system clipboard (pbcopy on macOS, xclip on Linux)
- `q` - exit copy mode

**tmux window navigation:**
- `Shift-Left` / `Shift-Right` - previous/next window
- `Alt-1` through `Alt-9` - jump to window by number
- `prefix + ;` - command prompt
- `prefix + :` - last pane


## 9. Manual Steps

**iTerm2:**
- Font: SauceCodePro Nerd Font, 15pt
- Window size: 120x45

**Github SSH:**
- Generate key: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
- Add to github: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account
- Ensure repos use ssh: `git remote set-url origin git@github.com:jabrew/dotfiles.git`

**Hammerspoon:**
- Run `~/dotfiles/setup-hammerspoon.sh`
- Run `hs.ipc.cliInstall('/Users/jbrewer')` from Hammerspoon console
- May need to `mkdir ~/bin` first

**Karabiner Elements:**
- Application -> Right Command
- Caps lock -> F19
- Right option -> right command (only on MS Natural)
- Right command -> right option (only on MS Natural)


## 9. Restart Shell

```sh
exec zsh
```
