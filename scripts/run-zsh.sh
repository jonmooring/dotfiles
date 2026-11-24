#!/usr/bin/env bash
# Exercise real interactive startup, including terminal-dependent plugins.
set -euo pipefail
[[ "$#" == 1 ]] || { echo 'Usage: run-zsh.sh <zsh command>' >&2; exit 1; }
export DOTFILES_ZSH_COMMAND="$1"
export TERM="${TERM:-xterm-256color}"
case "$(uname -s)" in
  Linux) exec script -q -e -c 'exec zsh -ic "$DOTFILES_ZSH_COMMAND"' /dev/null </dev/null ;;
  Darwin) exec script -q -e /dev/null zsh -ic "$DOTFILES_ZSH_COMMAND" </dev/null ;;
  *) echo 'Unsupported platform for interactive shell checks.' >&2; exit 1 ;;
esac
