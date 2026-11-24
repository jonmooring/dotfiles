# dotfiles

## Install

Run the folling script from your terminal prompt:

```
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/jonmooring/dotfiles/HEAD/install.sh)"
```

## Extensions

Zsh supports macOS and Linux with Homebrew installed. It loads
`~/.config/zsh/conf.d/*.zsh` in lexical order before `~/.local.zshrc`.
Machine or employer-specific repositories can supply these drop-ins and link
this repo's shared config with their own installer. The installer above remains
macOS-only.
