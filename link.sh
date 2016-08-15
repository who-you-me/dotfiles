#!/bin/sh

DOTFILES=( .zshrc .vimrc .atom )

for file in ${DOTFILES[@]}
do
  if [ -L $HOME/$file ]; then
    ln -sb $HOME/repos/dotfiles/$file $HOME/$file
  else
    ln -sb $HOME/repos/dotfiles/$file $HOME/$file
  fi
done
