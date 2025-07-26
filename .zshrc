# powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Initialize Homebrew
homebrew_path="/opt/homebrew"
if [[ `uname -m` == "x86_64" ]] homebrew_path="/usr/local"
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
[[ -f "$HOME/.fzf.zsh" ]] && source $HOME/.fzf.zsh

# Always use neovim instead of vim
alias vim="nvim"

# ls colors
alias ls="ls -G"

# Shortcuts for common commands
alias c="cursor"
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

# Allow for custom local config
if [[ -f "$HOME/.local.zshrc" ]] source $HOME/.local.zshrc
