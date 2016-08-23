#!/bin/bash

DOTFILES=( .zshrc .vimrc .atom )

for file in ${DOTFILES[@]}
do
  if [ -L $HOME/$file ]; then
    ln -sf $HOME/repos/dotfiles/$file $HOME/$file
  else
    ln -sb $HOME/repos/dotfiles/$file $HOME/$file
  fi
done
