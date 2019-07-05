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
ln -s $DOT_ROOT/prompt_brewer_setup ~/.zprezto/modules/prompt/functions/

echo "-----------Diff-----------"
diff ~/dotfiles/zprezto/zpreztorc ~/.zprezto/runcoms/zpreztorc
cat <<-eos
----------------------
Ensure these are the only differences in above diff:
  diff ~/dotfiles/zprezto/zpreztorc ~/.zprezto/runcoms/zpreztorc

'completion' \ 
+  'homebrew' \ 
+  'osx' \ 
+  'git' \ 
+  'fasd' \ 
+  'python' \ 
+  'syntax-highlighting' \ 
+  'history-substring-search' \ 
'prompt'

+# zstyle ':prezto:module:prompt' theme 'sorin'
+zstyle ':prezto:module:prompt' theme 'brewer'
eos
