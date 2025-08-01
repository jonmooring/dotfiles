#!/bin/zsh

if [[ -z $(xcode-select -p) ]]; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
  read "Press [Enter] key when install is complete."
fi

xcode_major_version=$(xcodebuild -version | grep '^Xcode\s' | sed -E 's/^Xcode[[:space:]]+([0-9\.]+)/\1/' | cut -d. -f1)
accepted_xcode_major_version=$(defaults read /Library/Preferences/com.apple.dt.Xcode 2> /dev/null | grep IDEXcodeVersionForAgreedToGMLicense | cut -d '"' -f 2 | cut -d. -f1)

if [[ "$xcode_major_version" != "$accepted_xcode_major_version" ]]; then
  echo "Accepting Xcode license..."
  sudo xcodebuild -license accept
fi

if [[ -z $(pgrep oahd) ]]; then
  echo "Installing Rosetta..."
  sudo softwareupdate --install-rosetta
fi

if [[ -z $(which brew) ]]; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  homebrew_path="/opt/homebrew"
  if [[ $(uname -m) == "x86_64" ]]; then
    homebrew_path="/usr/local"
  fi

  eval "$($homebrew_path/bin/brew shellenv)"
fi

installed_homebrew_packages=$(brew list -1)

homebrew_packages=(
  1password-cli
  antidote
  bash
  dockutil
  fd
  fzf
  gh
  git
  gnupg
  jq
  lazygit
  luarocks
  mas
  neovim
  pinentry-mac
  ripgrep
  stow
  tmux
  tmuxinator
  tree
  zsh
)

for package in ${homebrew_packages[@]}; do
  if [[ ! $(echo $installed_homebrew_packages | grep -E ^$package\$) ]]; then
    echo "Installing $package via Homebrew..."
    brew install $package
  fi
done

homebrew_cask_packages=(
  1password
  alacritty
  arc
  cursor
  discord
  dropbox
  fantastical
  figma
  font-sauce-code-pro-nerd-font
  middle
  mosaic
  slack
  spotify
  zoom
)

for package in ${homebrew_cask_packages[@]}; do
  if [[ ! $(echo $installed_homebrew_packages | grep -E ^$package\$) ]]; then
    echo "Installing $package cask via Homebrew..."

    if [[ $package == "alacritty" ]]; then
      brew install --cask $package --no-quarantine
    else
      brew install --cask $package
    fi
  fi
done

echo "Upgrading Homebrew packages..."
brew upgrade

echo "Cleaning up Homebrew..."
brew cleanup

installed_mac_app_store_apps=$(mas list)

declare -A mac_app_store_apps
mac_app_store_apps[amphetamine]="937984704"
mac_app_store_apps[xcode]="497799835"

for name id in ${(kv)mac_app_store_apps}; do
  if [[ ! $(echo $installed_mac_app_store_apps | grep $id) ]]; then
    echo "Installing $name via Mac App Store..."
    mas install $id
  fi
done

homebrew_zsh="$(brew --prefix)/bin/zsh"

if [[ ! $(cat /etc/shells | grep $homebrew_zsh) ]]; then
  echo "Adding $homebrew_zsh to /etc/shells..."
  echo $homebrew_zsh >> /etc/shells
fi

if [[ "$SHELL" != "$homebrew_zsh" ]]; then
  echo "Setting default shell to $homebrew_zsh..."
  chsh -s $homebrew_zsh
fi

if [[ ! -f "$HOME/.config/alacritty/catppuccin-mocha.toml" ]]; then
  echo "Downloading Catppuccin theme for Alacritty..."
  mkdir -p $HOME/.config/alacritty
  curl -LO --output-dir $HOME/.config/alacritty https://github.com/catppuccin/alacritty/raw/main/catppuccin-mocha.toml
fi

if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  echo "Cloning Tmux Plugin Manager repository..."
  mkdir -p $HOME/.tmux/plugins/tpm
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [[ ! -f "$HOME/.fzf.zsh" ]]; then
  echo "Configuring fzf..."
  $(brew --prefix)/opt/fzf/install
fi

if [[ ! -d "$HOME/.nvm" ]]; then
  echo "Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
  nvm install stable
fi

dotfiles_directory="$HOME/.dotfiles"

if [[ ! -d "$dotfiles_directory" ]]; then
  echo "Cloning dotfiles repository..."
  git clone https://github.com/jonmooring/dotfiles.git $dotfiles_directory
fi

if [[ ! -f "$HOME/.gnupg/gpg-agent.conf" ]]; then
  echo "Configuring GPG agent..."
  mkdir -p $HOME/.gnupg
  chmod 700 ~/.gnupg
  echo "pinentry-program $(which pinentry-mac)" > $HOME/.gnupg/gpg-agent.conf
  chmod 600 ~/.gnupg/gpg-agent.conf

  gpg_key_tag="personal"
  read "gpg_key_tag?GPG key tag ($gpg_key_tag): "

  op_item_name=$(op item list --tags gpg,$gpg_key_tag --format json | jq '.[0].title' -r)
  gpg_key=$(op item get $op_item_name --fields notesPlain --format json | jq '.value' -r)

  echo "Importing GPG key..."
  echo $gpg_key | gpg --import
  signing_key=$(gpg --list-secret-keys --keyid-format=long | grep -E 'sec\s*ed25519/(\w+)' -o | sed 's/^sec[[:space:]]*ed25519\///')
  git config --file ~/.local.gitconfig user.signingkey $signing_key
fi

echo "Linking dotfiles repository to home directory..."
pushd $dotfiles_directory > /dev/null && stow --no-folding . && popd > /dev/null

macos_defaults=(
  NSGlobalDomain,AppleShowAllExtensions,bool,true
  NSGlobalDomain,NSNavPanelExpandedStateForSaveMode,bool,true
  NSGlobalDomain,NSAutomaticQuoteSubstitutionEnabled,bool,false
  NSGlobalDomain,NSAutomaticDashSubstitutionEnabled,bool,false
  com.apple.finder,FXPreferredViewStyle,string,Clmv
  com.apple.finder,FXEnableExtensionChangeWarning,bool,false
  com.apple.dock,show-recents,bool,false
  com.apple.dock,recent-apps,array,
)

for default in $macos_defaults; do
  parts=(${(@s:,:)default})
  domain=$parts[1]
  key=$parts[2]
  value_type=$parts[3]
  value=$parts[4]
  current_value=$(defaults read $domain $key)

  [[ "$value_type" == "bool" && "$current_value" == "0" && $value == "false" ]] && continue
  [[ "$value_type" == "bool" && "$current_value" == "1" && $value == "true" ]] && continue
  [[ "$value_type" == "string" && "$current_value" == "$value" ]] && continue
  [[ "$value_type" == "array" && "$value" == "" && "$current_value" == $'(\n)' ]] && continue

  echo "Setting $domain.$key to $value..."
  defaults write $domain $key -$value_type $value
done

dock_apps=(
  /Applications/Arc.app
  /Applications/1Password.app
  /Applications/Alacritty.app
  /Applications/Cursor.app
  /Applications/zoom.us.app
  /System/Applications/Messages.app
  /Applications/Discord.app
  /Applications/Slack.app
  /Applications/Spotify.app
)

read -q "should_clear_dock?Remove all existing apps from dock? [yN] "

if [[ "$should_clear_dock" == "y" ]]; then
  echo "\nRemoving all existing apps from the dock..."
  dockutil --remove all --no-restart
fi

installed_dock_apps=$(dockutil -L)

for app in $dock_apps[@]; do
  if [[ ! $(echo $installed_dock_apps | grep $app) ]]; then
    echo "Adding $app to the dock..."
    dockutil --add $app --no-restart
  fi
done

read -q "should_restart_dock?Restart dock process? [yN] "

if [[ "$should_restart_dock" == "y" ]]; then
  echo "\nRestarting dock process..."
  killall Dock
fi

git_email=$(git config --global --includes --get user.email)

read "new_git_email?Git email ($git_email): "

if [[ ! -z "$new_git_email" ]]; then
  echo "Setting new Git email..."
  git config set --file ~/.local.gitconfig user.email $new_git_email
fi

host_name=$(scutil --get HostName)
trimmed_host_name=${host_name%.localdomain}

read "new_host_name?Host name ($trimmed_host_name): "

if [[ ! -z "$new_host_name" ]]; then
  echo "Setting new host name..."
  sudo scutil --set HostName $new_host_name.localdomain
  sudo scutil --set LocalHostName $new_host_name
  sudo scutil --set ComputerName $new_host_name
  dscacheutil -flushcache
fi

echo ""
echo "--------------------"
echo "| Manual Task List |"
echo "--------------------"
echo ""
echo "- Update internal keyboard modifier keys"
echo "- Update external display scaling and disable HDR"
echo "- Enable Apple Watch for unlocking apps and your Mac"
echo "- Set sample rate for DAC and speakers"
echo "- Update Sound settings to always show icon in menu bar"
echo "- Update Finder preferences to show the correct sidebar items"
echo "- Pair Bluetooth devices and update setting to always show icon in menu bar"
echo "- Open 1password, log in, and enable SSH agent"
echo "- Open Dropbox, log in, and set up selective sync"
echo "- Open Fantastical, log in, add Google accounts, and set default calendar and task list"
echo "- Open Mosaic and import settings"
echo "- Open Spotify, log in, and disable open at login"
echo "- Open Messages, log in, and enable Messages in iCloud"
echo "- Open Discord and log in"
echo "- Open Slack and log in to Atlassian Alumni and Browser Wranglers workspaces"
