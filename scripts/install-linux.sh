#!/usr/bin/env bash
set -euo pipefail
repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
[[ "$(uname -s)" == Linux ]] || { echo 'This installer requires Linux.' >&2; exit 1; }
[[ "$EUID" -ne 0 ]] || { echo 'Run as your workspace user, not root.' >&2; exit 1; }

# Homebrew supplies current Neovim/fzf and the same package names as the host.
if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
if ! command -v brew >/dev/null; then
  command -v apt-get >/dev/null || { echo 'Install Homebrew first on this Linux distribution.' >&2; exit 1; }
  sudo -n apt-get update
  sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential procps curl file git ca-certificates
  brew_installer=$(mktemp)
  trap 'rm -f "$brew_installer"' EXIT
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o "$brew_installer"
  NONINTERACTIVE=1 bash "$brew_installer"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  rm -f "$brew_installer"
  trap - EXIT
fi
HOMEBREW_NO_AUTO_UPDATE=1 brew bundle install --no-upgrade --file="$repo/packages/Brewfile.linux"

# Install config before plugins so they see the right plugin list.
export DOTFILES_GIT_NAME="${DOTFILES_GIT_NAME:-$(git config --global --includes --get user.name || true)}"
export DOTFILES_GIT_EMAIL="${DOTFILES_GIT_EMAIL:-$(git config --global --includes --get user.email || true)}"
bash "$repo/scripts/link.sh"
bash "$repo/scripts/configure-git.sh"
export PATH="$HOME/.local/bin:$PATH"
if [[ ! -d "$HOME/.tmux/plugins/tpm/.git" ]]; then
  git clone --depth=1 https://github.com/tmux-plugins/tpm.git "$HOME/.tmux/plugins/tpm"
fi
bootstrap_session="dotfiles-bootstrap-$$"
tmux new-session -d -s "$bootstrap_session"
trap 'tmux kill-session -t "$bootstrap_session" 2>/dev/null || true' EXIT
tmux source-file "$HOME/.tmux.conf"
"$HOME/.tmux/plugins/tpm/bin/install_plugins"
tmux kill-session -t "$bootstrap_session"
trap - EXIT

export NVM_DIR="$HOME/.nvm"
if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
  git clone --depth=1 --branch v0.40.3 https://github.com/nvm-sh/nvm.git "$NVM_DIR"
fi
# nvm is not compatible with nounset.
set +u
source "$NVM_DIR/nvm.sh"
nvm install "$(cat "$repo/packages/node-version")"
nvm alias default "$(cat "$repo/packages/node-version")"
npm install --global npm@11.13.0 corepack@0.35.0
set -u
bash "$repo/scripts/run-zsh.sh" 'antidote load'
nvim --headless '+Lazy! restore' +qa
zsh_path=$(command -v zsh)
if ! grep -Fxq "$zsh_path" /etc/shells; then
  printf '%s\n' "$zsh_path" | sudo -n tee -a /etc/shells >/dev/null
fi
if [[ "$(getent passwd "$(id -un)" | cut -d: -f7)" != "$zsh_path" ]]; then
  sudo -n chsh -s "$zsh_path" "$(id -un)"
fi
printf '\nSetup complete. Start zsh, then run: bash %q/scripts/validate.sh\n' "$repo"
