# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

autoload -U +X bashcompinit && bashcompinit

# direnv
if which direnv > /dev/null; then
  eval "$(direnv hook zsh)"
fi

# kubectl
if which kubectl > /dev/null; then
  source <(kubectl completion zsh)
fi

# terraform
if which terraform > /dev/null; then
  complete -o nospace -C $(which terraform) terraform
fi

# pyenv
if [ -d "$HOME/.pyenv" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

# rbenv
if [ -d "$HOME/.rbenv" ]; then
  export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH"
  eval "$(rbenv init -)"
fi

alias be="bundle exec"

# nodenv
if [ -d "$HOME/.nodenv" ]; then
  export PATH="$HOME/.nodenv/versions/*/bin:$PATH"
  eval "$(nodenv init -)"
fi

# golang
if [ -d "$HOME/go/bin" ]; then
  export PATH="$HOME/go/bin:$PATH"
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
  . "$HOME/google-cloud-sdk/path.zsh.inc"
fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ];
  then . "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

# alias
alias gst="git status"
alias dcu="docker-compose up -d && docker-compose logs -f"

# PATH
export PATH="$HOME/.local/bin:$HOME/.bin:$PATH"