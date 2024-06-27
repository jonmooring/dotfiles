# Set default editor to neovim
export EDITOR='nvim'

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
alias c="code"
alias g="git"
alias v="vim"
alias dot="pushd $HOME/.dotfiles > /dev/null && stow --no-folding . && popd > /dev/null && source $HOME/.zshrc"

# Allow for custom local config
if [[ -f "$HOME/.zshrc.local" ]] source $HOME/.zshrc.local
