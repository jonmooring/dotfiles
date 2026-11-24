# dotfiles

The shared source for my macOS and Linux shell, Git, tmux, Neovim, and package
configuration. Platform or employer-specific repositories layer on this base;
they should not copy these files or maintain parallel package installers.

## Install

```sh
git clone https://github.com/jonmooring/dotfiles.git ~/.dotfiles
bash ~/.dotfiles/install.sh
```

`install.sh` selects the platform. The Mac installer remains interactive and
includes desktop apps and system preferences. The Linux installer uses Homebrew
for portable packages, installs the pinned Node/npm/Corepack versions, restores
tmux and Neovim plugins, and sets Zsh as the login shell. It requires passwordless
sudo for system prerequisites and shell registration.

The Linux package list is `packages/Brewfile.linux`. It covers portable packages
explicitly installed on the host, with Linux builds and dependencies resolved by
Homebrew. Versions and binaries can differ from macOS. Services are not started.
See `inventory/README.md` for the package snapshot and platform exclusions.

## Configuration and extensions

`bash scripts/link.sh` links an explicit config allowlist. Conflicting files are
preserved under `${XDG_STATE_HOME:-~/.local/state}/dotfiles/backups/`. It never
links installer code or repository metadata into the home directory.

Zsh loads `~/.config/zsh/conf.d/*.zsh` in lexical order, followed by
`~/.local.zshrc`. These are extension points for machine or employer-specific
settings. Git includes `~/.local.gitconfig` first for author details, transport
settings, or other local overrides. Layers own their own drop-ins; the base
linker leaves them alone.

Run `dot` to relink shared config and reload Zsh. For linking on a laptop without
rerunning the interactive Mac setup, use `bash scripts/link.sh` directly.

Git author values can be supplied through `DOTFILES_GIT_NAME` and
`DOTFILES_GIT_EMAIL`; the installer fills missing fields in `~/.local.gitconfig`
while preserving existing overrides. Commit signing remains enabled. Private
keys, credentials, and signing-agent configuration are not migrated.

## Validation

After installation:

```sh
bash scripts/validate.sh
```

Checks cover package availability, the login shell, config links, Zsh aliases,
the pinned standalone Node version, tmux settings, locked Neovim plugin commits,
and Git author identity. Platform-specific layers should validate their own
settings and tools separately. Interactive shell checks use a pseudo-terminal so
prompt and line-editor plugins initialize as they do in a terminal. Package
checks match the installer's no-upgrade policy: installed older formula versions
are accepted; missing packages still fail.

The Linux installer and base checks passed on 2026-11-24, including use through
a separate platform layer. Prompt initialization is exercised in a pseudo-terminal;
some installed syntax-highlighting widgets still emit nonfatal startup warnings.
