#!/usr/bin/env bash
set -euo pipefail
# Preserve workspace overrides. Only migrate the author name and email.
if [[ -n "${DOTFILES_GIT_NAME:-}" && -z "$(git config --file "$HOME/.local.gitconfig" --includes --get user.name || true)" ]]; then
  git config --file "$HOME/.local.gitconfig" user.name "$DOTFILES_GIT_NAME"
fi
if [[ -n "${DOTFILES_GIT_EMAIL:-}" && -z "$(git config --file "$HOME/.local.gitconfig" --includes --get user.email || true)" ]]; then
  git config --file "$HOME/.local.gitconfig" user.email "$DOTFILES_GIT_EMAIL"
fi
