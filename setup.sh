#!/bin/bash

set -eu

DOTFILES_REPO="$HOME/dotfiles"
if [ ! -e "$DOTFILES_REPO" ]; then
  echo 'dotfilesリポジトリをcloneします'
  git clone https://github.com/who-you-me/dotfiles.git "$DOTFILES_REPO"
fi

echo '設定ファイルへのシンボリックリンクを貼ります'

CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$CONFIG_DIR/backup"
mkdir -p "$BACKUP_DIR"

# git
if [ -e ~/.gitconfig ]; then
  echo '~/.gitconfig が見つかったので、バックアップを取って削除します'
  mv ~/.gitconfig "$BACKUP_DIR/.gitconfig"
  rm -rf ~/.gitconfig
fi

mkdir -p "$CONFIG_DIR/git"
echo -e '\tgit/config'
ln -snf "$DOTFILES_REPO/git/config" "$CONFIG_DIR/git/config"

# ホームディレクトリに設置するファイル
cd "$DOTFILES_REPO"
git ls-files | grep -e '^\.' | while read DOTFILE; do
  DST="$HOME/$DOTFILE"
  if [ -e "$DST" ]; then
    if [ ! -L "$DST" ]; then
      echo -e "\t$DOTFILE が見つかったので、バックアップを取って削除します"
      mv "$DST" "$BACKUP_DIR/$DOTFILE"
      rm -rf "$DST"
    fi
  fi
  echo -e "\t$DOTFILE"
  ln -snf "$DOTFILES_REPO/$DOTFILE" "$DST"
done
