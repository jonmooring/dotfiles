# powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Initialize Homebrew
for homebrew_path in /home/linuxbrew/.linuxbrew /opt/homebrew /usr/local; do
  if [[ -x "$homebrew_path/bin/brew" ]]; then
    eval "$("$homebrew_path/bin/brew" shellenv)"
    break
  fi
done
unset homebrew_path
typeset -U path
path=("$HOME/.local/bin" $path)

# Initialize Antidote
if [[ -r "$HOME/.antidote/antidote.zsh" ]]; then
  source "$HOME/.antidote/antidote.zsh"
elif (( $+commands[brew] )); then
  [[ ! -r "$(brew --prefix)/opt/antidote/share/antidote/antidote.zsh" ]] || source "$(brew --prefix)/opt/antidote/share/antidote/antidote.zsh"
fi
(( ! $+functions[antidote] )) || antidote load

# Initialize powerlevel10k
[[ ! -f "$HOME/.p10k.zsh" ]] || source $HOME/.p10k.zsh

# Initialize nvm
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && \. "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && \. "$NVM_DIR/bash_completion"

# Initialize fzf
[[ -f "$HOME/.fzf.zsh" ]] && source $HOME/.fzf.zsh
if [[ ! -f "$HOME/.fzf.zsh" ]] && (( $+commands[fzf] )); then
  source <(fzf --zsh)
fi

# Always use neovim instead of vim
alias vim="nvim"

# ls colors
if [[ "$OSTYPE" == darwin* ]]; then
  alias ls='ls -G'
else
  alias ls='ls --color=auto'
fi

# Shortcuts for common commands
alias c="cursor --classic"
alias g="git"
alias v="vim"
unalias dot 2>/dev/null
function dot {
  local repo="${${(%):-%x}:A:h}"
  bash "$repo/scripts/link.sh" && source "$HOME/.zshrc"
}

# Which processes are listening on TCP ports?
listening() {
    if [ $# -eq 0 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P
    elif [ $# -eq 1 ]; then
      output=$(sudo lsof -iTCP -sTCP:LISTEN -n -P)
      header=$(echo $output | sed 1q)
      processes=$(echo $output | sed 1d)

      echo $header
      echo $processes | grep -i --color $1
    else
        echo "Usage: listening [pattern]"
    fi
}

# Fixes file descriptor error when running `git status`
unset ZSH_AUTOSUGGEST_USE_ASYNC

# Set default editor to neovim
export EDITOR='nvim'

# Don't use vim bindings for zsh
bindkey -e

# Cmd+Left/Right to move to start or end of line
bindkey "^[[1;9D" vi-beginning-of-line
bindkey "^[[1;9C" vi-end-of-line

# Initialize command autocompletion
autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Allow for custom local config
for config_file in "$HOME"/.config/zsh/conf.d/*.zsh(N); do
  source "$config_file"
done
unset config_file
if [[ -f "$HOME/.local.zshrc" ]] source $HOME/.local.zshrc
