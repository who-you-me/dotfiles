# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

autoload -U +X bashcompinit && bashcompinit

# direnv
eval "$(direnv hook zsh)"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# rbenv
eval "$(rbenv init - zsh)"

# nodenv
eval "$(nodenv init -)"

# Docker
export PATH="$HOME/.docker/cli-plugins:$PATH"

# Terraform
complete -o nospace -C $(which terraform) terraform

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Google Cloud
. "$HOME/google-cloud-sdk/path.zsh.inc"
. "$HOME/google-cloud-sdk/completion.zsh.inc"

# alias
alias be="bundle exec"
alias dcu="docker-compose up -d && docker-compose logs -f"
alias gst="git status"
