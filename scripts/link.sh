#!/usr/bin/env bash
set -euo pipefail
repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
backup_root="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/backups/$(date +%Y%m%d-%H%M%S)-$$"
# Explicit allowlist: never link installer code, manifests, or repository metadata.
files=(.editorconfig .gitconfig .gitignore_global .p10k.zsh .tmux.conf
       .zsh_plugins.txt .zshrc .config/nvim)
[[ "$(uname -s)" != Darwin ]] || files+=(.config/ghostty/config)
for file in "${files[@]}"; do
  dest="$HOME/$file"
  if [[ -L "$dest" && "$(readlink "$dest")" == "$repo/$file" ]]; then
    continue
  fi
  if [[ -e "$dest" || -L "$dest" ]]; then
    mkdir -p "$backup_root/$(dirname "$file")"
    mv -- "$dest" "$backup_root/$file"
    printf 'Backed up %s to %s\n' "$dest" "$backup_root/$file"
  fi
  mkdir -p "$(dirname "$dest")"
  ln -s -- "$repo/$file" "$dest"
done
