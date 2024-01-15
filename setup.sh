#!/bin/bash

set -eu

if ! which brew > /dev/null; then
  echo 'HomeBrewをインストールします'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if ! which git > /dev/null; then
  brew install git
fi

DOTFILES_REPO="$HOME/dotfiles"
if [ ! -e "$DOTFILES_REPO" ]; then
  echo 'dotfilesリポジトリをcloneします'
  git clone https://github.com/who-you-me/dotfiles.git "$DOTFILES_REPO"
fi

CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$CONFIG_DIR/backup"
mkdir -p "$BACKUP_DIR"

echo '必要なパッケージをインストールします'

ln -snf "$DOTFILES_REPO/Brewfile" "$CONFIG_DIR/Brewfile"
brew bundle --file "$CONFIG_DIR/Brewfile"

# Pythonの最新版をインストール
pyenv install 3.11
pyenv rehash
pyenv global 3.11

# Poetry
if ! which poetry > /dev/null; then
  echo 'Poetryをインストールします'
  curl -sSL https://install.python-poetry.org | POETRY_HOME="$HOME/.local/poetry" python3 -

  mkdir -p ~/.zfunc
  $HOME/.local/poetry/bin/poetry completions zsh > ~/.zfunc/_poetry
fi

# Pythonのライブラリをインストール
echo 'Pythonのライブラリをインストールします'
ln -snf "$DOTFILES_REPO/requirements.txt" "$CONFIG_DIR/requirements.txt"
python3.11 -m pip install -r "$CONFIG_DIR/requirements.txt"
pyenv rehash

# Rust
if ! which cargo > /dev/null; then
  echo 'Rustをインストールします'
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# Google Cloud SDK
if ! which gcloud > /dev/null; then
  echo 'Google Cloud SDKをインストールします'

  curl -sSf -o "$HOME/google-cloud-sdk.tar.gz" \
    https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-426.0.0-darwin-x86_64.tar.gz
  tar -xzf "$HOME/google-cloud-sdk.tar.gz" -C "$HOME/.local/"
  rm -f "$HOME/google-cloud-sdk.tar.gz"

  sh "$HOME/.local/google-cloud-sdk/install.sh" \
    --usage-reporting false \
    --command-completion false \
    --path-update false \
    --install-python false
fi

# Zim
if [ ! -e ~/.zim ]; then
  echo 'Zimをインストールします'
  curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
fi

echo '設定ファイルへのシンボリックリンクを貼ります'

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
