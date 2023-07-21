#!/usr/bin/env zsh

# Exit on any error
# set -e

# TODO:
# sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh

DOT_ROOT=~/dotfiles/zprezto

echo Zshrc
rm ~/.zshrc
ln -s $DOT_ROOT/zshrc ~/.zshrc

echo Zpreztorc
rm ~/.zpreztorc
ln -s $DOT_ROOT/zpreztorc ~/.zpreztorc

echo Prompt
# ln -s $DOT_ROOT/prompt_brewer_setup ~/.zprezto/modules/prompt/functions/
echo Also consider https://github.com/spaceship-prompt/spaceship-prompt
ln -s ~/dotfiles/zprezto/theme_p10k.zsh ~/.p10k.zsh

echo "-----------Diff-----------"
diff ~/.zprezto/runcoms/zpreztorc ~/dotfiles/zprezto/zpreztorc
cat <<-eos
----------------------
Ensure these are the only differences in above diff:
  diff ~/.zprezto/runcoms/zpreztorc ~/dotfiles/zprezto/zpreztorc

>   'osx' \
>   'git' \
>   'fasd' \
>   'python' \
>   'syntax-highlighting' \

< zstyle ':prezto:module:prompt' theme 'sorin'
> zstyle ':prezto:module:prompt' theme 'powerlevel10k'
eos
