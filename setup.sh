#!/bin/bash

set -eu

DOTFILES_REPO="$HOME/dotfiles"
if [ ! -e "$DOTFILES_REPO" ]; then
  echo 'dotfilesリポジトリをcloneします'
  git clone git@github.com:who-you-me/dotfiles.git "$DOTFILES_REPO"
fi

if ! which brew > /dev/null; then
  echo 'HomeBrewをインストールします'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$CONFIG_DIR/backup"
mkdir -p "$BACKUP_DIR"

echo '必要なパッケージをインストールします'

ln -snf "$DOTFILES_REPO/Brewfile" "$CONFIG_DIR/Brewfile"
brew bundle --file "$CONFIG_DIR/Brewfile"

# HomeBrewでインストールしたpython3.9を python3 や python に設定
ln -snf $(which python3.9) /usr/local/bin/python3
ln -snf $(which python3.9) /usr/local/bin/python
ln -snf $(which pip3.9) /usr/local/bin/pip3
ln -snf $(which pip3.9) /usr/local/bin/pip

# Pythonのライブラリをインストール
echo 'Pythonのライブラリをインストールします'
ln -snf "$DOTFILES_REPO/requirements.txt" "$CONFIG_DIR/requirements.txt"
python3.9 -m pip install \
  --upgrade \
  --upgrade-strategy=eager \
  -r "$CONFIG_DIR/requirements.txt"

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
  tar -xzf "$HOME/google-cloud-sdk.tar.gz"
  rm -f "$HOME/google-cloud-sdk.tar.gz"

  sh "$HOME/google-cloud-sdk/install.sh" \
    --usage-reporting false \
    --command-completion false \
    --path-update false \
    --install-python false
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
