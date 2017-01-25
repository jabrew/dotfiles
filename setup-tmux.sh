#!/usr/local/bin/zsh

# Exit on any error
set -e

DOT_ROOT=~/dotfiles/tmux

echo Tmux conf
ln -s $DOT_ROOT/tmux.conf ~/.tmux.conf
