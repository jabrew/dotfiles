#!/usr/local/bin/zsh

echo "
# Install middleClick
# https://github.com/artginzburg/MiddleClick-Ventura
# Forked from https://github.com/cl3m/MiddleClick
brew install --cask --no-quarantine middleclick

Todo: Consider also adding to login items

# Change shell after installing zsh
chsh -s /bin/zsh
"

echo "
iTerm:
- Inconsolata-g for Powerline, 15
  - 120x45 for new windows
"

echo "
Install zprezto from https://github.com/sorin-ionescu/prezto
"

# Exit on any error
set -e

echo "
Apps
1. scm_breeze
"

echo "
Homebrew installs:
brew install zsh
brew install tmux
brew install the_silver_searcher
brew install jq
# brew install scmpuff
# cli tools
brew install fd git-delta exa bat

# For tmux
brew install reattach-to-user-namespace
"

cat << EOM
Neovim:
xcode-select --install
brew install --head neovim
pip3 install --user neovim

Glrnvim:
brew cask install alacritty
mkdir ~/bin
cd ~/bin

clone glrnvim repo
# Note: Likely no longer needed
# Make following edits to main.rs:
# +    let path = env::current_dir().unwrap();
# +    command.arg("--working-directory");
# +    command.arg(path.into_os_string());
#      command.arg("--class");

# Set ~/bin/gnv to:
# #!/bin/sh
# ~/bin/glrnvim/target/release/glrnvim "$@"

ln -s ~/glrnvim/target/release/glrnvim ~/bin/lgv

# Note: Path printed after 'lgv -h' - seems to change
# ln -s ~/VimConfig/glrnvim.yml ~/Library/Preferences/
ln -s ~/VimConfig/glrnvim.yml ~/Library/Application\ Support/glrnvim/config.yml
EOM

echo "
Github setup:
- Generate key with https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
- Add to github with https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account
Note: Each repo needs to use ssh instead of https - use git remote -v to check (should be git://)
"

echo "
Hammerspoon
- Run hammerspoon setup script ~/dotfiles/setup-hammerspoon.sh
- Run hs.ipc.cliInstall() from console
  - hs.ipc.cliInstall('/Users/jbrewer')
  - Test by running 'hs' from cli
  - May need to mkdir ~/bin first

Karabiner elements:
  - Application -> Right Command
  - Caps lock -> F19
  - Right option -> right command (only on MS Natural)
  - Right command -> right option (only on MS Natural)

Font for nvim: Source Code Pro for Powerline
Currently use regular Source Code Pro (slightly larger)
  mkdir ~/bin/powerline; cd ~/bin/powerline
  git clone https://github.com/powerline/fonts.git
NOTE: Actually for sidebar.nvim use nerd font - extension from https://www.nerdfonts.com/font-downloads
  SauceCodePro Nerd Font [Or SauceCodePro Nerd Font Mono]
"

echo "
Plugin installs:
tmux-copycat
"
