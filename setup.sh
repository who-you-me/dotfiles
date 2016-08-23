#!/bin/sh

set -eu

if ! type zsh >/dev/null 2>&1; then
  apt-get -y install zsh
fi

zsh install_prezto.sh
chsh -s $(which zsh)

curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh
