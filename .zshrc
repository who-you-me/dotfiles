# -----------------
# Zsh configuration
# -----------------

WORDCHARS=${WORDCHARS//[\/]}

setopt HIST_IGNORE_ALL_DUPS
setopt CORRECT
setopt AUTO_CD

function chpwd() { ls }

bindkey -v

# --------------------
# Module configuration
# --------------------

zstyle ':zim:git' aliases-prefix 'g'

ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# ------------------
# Initialize modules
# ------------------

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi

if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi

source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

zmodload -F zsh/terminfo +p:terminfo
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key

# -----------------
# Tool configuration
# -----------------

fpath+=~/.zfunc

# direnv
eval "$(direnv hook zsh)"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# poetry
export POETRY_HOME="$HOME/.local/poetry"
export PATH="$HOME/.local/poetry/bin:$PATH"

# go
export PATH="$HOME/go/bin:$PATH"

# rbenv
eval "$(rbenv init - zsh)"

# nodenv
eval "$(nodenv init -)"

# Docker
export PATH="$HOME/.docker/bin:$PATH"

# Terraform
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C $(which terraform) terraform

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Google Cloud
. "$HOME/.local/google-cloud-sdk/path.zsh.inc"
. "$HOME/.local/google-cloud-sdk/completion.zsh.inc"

# -----------------
# Aliases
# -----------------

alias be="bundle exec"
alias dcu="docker-compose up -d && docker-compose logs -f"
alias gst="git status"
