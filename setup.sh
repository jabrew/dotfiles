#!/usr/local/bin/zsh

# Exit on any error
set -e

echo "
Pre-setup steps:
1. Install iTerm
2. Install homebrew
3. Install MacVim (don't use homebrew!)
4. Install YouCompleteMe
"

echo "
Apps
1. scm_breeze
"

echo "
Homebrew installs:
brew install python
brew install python3
brew install zsh
brew install tmux
brew install the_silver_searcher
brew install jq
# brew install scmpuff

# Needed for devdocs
brew install ruby

# For tmux
brew install reattach-to-user-namespace

# For YCM in vim
brew install cmake
"

cat << EOM
Neovim:
xcode-select --install
brew install --head neovim
pip install --user neovim
pip3 install --user neovim
pip3 insall jedi pandas scikit-learn numpy scipy
ln -s ~/VimConfig/_style.yapf ~/.style.yapf

Install dein to ~/.nvim/dein

Glrnvim:
brew cask install alacritty
mkdir ~/bin
cd ~/bin

clone repo
Make following edits to main.rs:
+    let path = env::current_dir().unwrap();
+    command.arg("--working-directory");
+    command.arg(path.into_os_string());
     command.arg("--class");

Set ~/bin/gnv to:
#!/bin/sh
~/bin/glrnvim/target/release/glrnvim "$@"

ln -s ~/VimConfig/glrnvim.yml ~/Library/Preferences/
EOM

echo "
Other software (Mac)

brew install fzf

Hammerspoon
- Run hammerspoon setup script ~/dotfiles/setup-hammerspoon.sh
- Run hs.ipc.cliInstall() from console

Karabiner elements:
  - Application -> Right Command
  - Caps lock -> F19
  - Right option -> right command (only on MS Natural)
  - Right command -> right option (only on MS Natural)

Font: Source Code Pro for Powerline
  mkdir ~/bin/powerline; cd ~/bin/powerline
  git clone https://github.com/powerline/fonts.git

Ctags:
brew tap universal-ctags/universal-ctags
brew install --with-jansson universal-ctags/universal-ctags/universal-ctags
ln -s /usr/local/opt/universal-ctags/bin/ctags ~/bin/ctags
# Ensure `ctags --list-features` includes json
"

echo "
Plugin installs:
tmux-copycat
"
