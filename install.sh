#!/usr/bin/env bash
set -euo pipefail
DOTFILES_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
export DOTFILES_ROOT
case "$(uname -s)" in
  Linux) exec bash "$DOTFILES_ROOT/scripts/install-linux.sh" "$@" ;;
  Darwin) exec zsh "$DOTFILES_ROOT/scripts/install-macos.zsh" "$@" ;;
  *) echo "Unsupported operating system: $(uname -s)" >&2; exit 1 ;;
esac
