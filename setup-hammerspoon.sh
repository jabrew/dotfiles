#!/usr/local/bin/zsh

# Exit on any error
set -e

DOT_ROOT=~/dotfiles/hammerspoon

echo Hammerspoon conf
ln -s $DOT_ROOT/hammerspoon.lua ~/.hammerspoon/init.lua
