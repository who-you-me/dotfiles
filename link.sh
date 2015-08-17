#!/bin/bash

DOTFILES=( .zshrc .vimrc .atom )

for file in ${DOTFILES[@]}
do
    ln -s $HOME/repos/dotfiles/$file $HOME/$file
done

