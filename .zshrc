# powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Initialize Homebrew
homebrew_path="/opt/homebrew"
if [[ "$OSTYPE" == linux* ]]; then
  homebrew_path="/home/linuxbrew/.linuxbrew"
elif [[ $(uname -m) == "x86_64" ]]; then
  homebrew_path="/usr/local"
fi
eval "$($homebrew_path/bin/brew shellenv)"

# Initialize Antidote
source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh
antidote load

# Initialize powerlevel10k
[[ ! -f "$HOME/.p10k.zsh" ]] || source $HOME/.p10k.zsh

# Initialize nvm
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && \. "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && \. "$NVM_DIR/bash_completion"

# Initialize fzf
if [[ -f "$HOME/.fzf.zsh" ]]; then
  source "$HOME/.fzf.zsh"
else
  source <(fzf --zsh)
fi

# Always use neovim instead of vim
alias vim="nvim"

# ls colors
if [[ "$OSTYPE" == linux* ]]; then
  alias ls="ls --color=auto"
else
  alias ls="ls -G"
fi

# Shortcuts for common commands
alias c="cursor --classic"
alias g="git"
alias v="vim"
alias dot="pushd $HOME/.dotfiles > /dev/null && stow --no-folding . && popd > /dev/null && source $HOME/.zshrc"

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
