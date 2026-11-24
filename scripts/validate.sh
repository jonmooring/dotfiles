#!/usr/bin/env bash
set -euo pipefail
repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
failures=0
export PATH="$HOME/.local/bin:$PATH"
check() {
  if "$@"; then
    printf 'PASS %s\n' "$*"
  else
    printf 'FAIL %s\n' "$*" >&2
    failures=$((failures + 1))
  fi
}
if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
check env HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --no-upgrade --verbose --file="$repo/packages/Brewfile.linux"
if [[ "$(uname -s)" == Linux ]]; then
  check test "$(getent passwd "$(id -un)" | cut -d: -f7)" = "$(command -v zsh)"
fi
for file in .editorconfig .gitconfig .gitignore_global .p10k.zsh .tmux.conf .zsh_plugins.txt .zshrc .config/nvim; do
  check test "$(readlink "$HOME/$file" || true)" = "$repo/$file"
done
check bash "$repo/scripts/run-zsh.sh" '
  failures=0
  for tool in bash comby fd fzf git gpg grpcurl herdr htop jq jwt lazygit luarocks lsof nvim nginx redis-server rg stow tmux tmuxinator tree tree-sitter wget yarn zsh; do
    if (( $+commands[$tool] )); then
      print "PASS command $tool"
    else
      print -u2 "FAIL command $tool"
      (( failures += 1 ))
    fi
  done
  (( $+functions[antidote] )) || (( failures += 1 ))
  [[ "$EDITOR" == nvim ]] || (( failures += 1 ))
  [[ "${aliases[vim]}" == nvim ]] || (( failures += 1 ))
  if [[ "$OSTYPE" == linux* ]]; then
    [[ "${aliases[ls]}" == "ls --color=auto" ]] || (( failures += 1 ))
  fi
  (( failures == 0 ))'
check bash -c '
  set +u
  export NVM_DIR="$HOME/.nvm"
  source "$NVM_DIR/nvm.sh" || exit
  [[ "$(node --version)" == "v$(cat "$1/packages/node-version")" ]]
' bash "$repo"
check env DOTFILES_NVIM_CHECK="$repo/scripts/validate-nvim.lua" nvim --headless '+lua dofile(vim.env.DOTFILES_NVIM_CHECK)'
socket="dotfiles-validation-$$"
trap 'tmux -L "$socket" kill-server 2>/dev/null || true' EXIT
check tmux -L "$socket" -f "$HOME/.tmux.conf" new-session -d -s validation
check test "$(tmux -L "$socket" show-option -gv prefix)" = C-Space
tmux -L "$socket" kill-server
trap - EXIT

printf '\nGit identity/signing:\n'
check test -n "$(git config --global --includes --get user.name || true)"
check test -n "$(git config --global --includes --get user.email || true)"
git config --global --includes --get commit.gpgsign || true
printf '\nFailures: %s\n' "$failures"
[[ "$failures" == 0 ]]
