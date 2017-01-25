#!/usr/local/bin/zsh

# Exit on any error
set -e

DOT_ROOT=~/dotfiles/zprezto

echo Zshrc
rm ~/.zshrc
ln -s $DOT_ROOT/zshrc ~/.zshrc

echo Prompt
ln -s $DOT_ROOT/prompt_brewer_setup ~/.zprezto/modules/prompt/functions/

echo Note: Still need to setup zpreztorc (see wiki)
