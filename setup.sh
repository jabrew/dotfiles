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
Homebrew installs:
brew install python
brew install python3
brew install zsh
brew install tmux
brew install the_silver_searcher
brew install jq
brew install scmpuff
# Needed for devdocs
brew install ruby

# For tmux
brew install reattach-to-user-namespace
"

echo "
Plugin installs:
tmux-copycat
"
