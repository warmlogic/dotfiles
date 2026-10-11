#!/usr/bin/env zsh

# Install command-line tools using Homebrew.
# Usage: ./02-brew.sh [--work]

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until `02-brew.sh` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Get homebrew
# Modified from: https://github.com/pathikrit/mac-setup-script/blob/master/install.sh
if test ! "$(command -v brew)"; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # ~/.zprofile (from 01-bootstrap.sh) sets this up for future shells
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  if [[ -z "${CI}" ]]; then
    echo "Updating Homebrew..."
    brew update
    brew upgrade
    brew doctor
  fi
fi

# Install everything shared, then the personal or work overlay
brew bundle --file=Brewfile.common
case "${1:-}" in
  "")
    brew bundle --file=Brewfile.personal
    ;;
  --work)
    brew bundle --file=Brewfile.work
    ;;
  *)
    echo "Usage: $0 [--work]" >&2
    exit 2
    ;;
esac

# Remove outdated versions from the cellar
brew cleanup

# Set Homebrew's installed location
HOMEBREW_PREFIX=$(brew --prefix)

# # Switch to using brew-installed bash as default shell
# if ! fgrep -q "${HOMEBREW_PREFIX}/bin/bash" /etc/shells; then
#   echo "${HOMEBREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
#   chsh -s "${HOMEBREW_PREFIX}/bin/bash";
# fi;

# Switch to using brew-installed zsh as default shell
if ! fgrep -q "${HOMEBREW_PREFIX}/bin/zsh" /etc/shells; then
  echo "${HOMEBREW_PREFIX}/bin/zsh" | sudo tee -a /etc/shells;
  chsh -s "${HOMEBREW_PREFIX}/bin/zsh";
fi;

# Install Oh-My-Zsh (skipped on re-runs); --keep-zshrc preserves the ~/.zshrc from 01-bootstrap.sh
if [[ ! -d ~/.oh-my-zsh ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Install Spaceship theme for Oh-My-Zsh
[[ -d "$ZSH_CUSTOM/themes/spaceship-prompt" ]] || git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
ln -sf "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

# Install zsh syntax highlighting for Oh-My-Zsh
[[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]] || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# Install zsh autosuggestions for Oh-My-Zsh
[[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]] || git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

source ~/.zshrc

# Ruby (only installed via Brewfile.work)
# https://stackoverflow.com/a/66379795/2592858
if command -v rbenv &>/dev/null; then
  rbenv install --skip-existing $(rbenv install -l | grep -v - | tail -1)
  rbenv global $(rbenv install -l | grep -v - | tail -1)
  eval "$(rbenv init - zsh)"
  # Install gems
  gem install solargraph
fi
