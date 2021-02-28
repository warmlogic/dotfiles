#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until `02-brew.sh` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Get homebrew
# Modified from: https://github.com/pathikrit/mac-setup-script/blob/master/install.sh
if test ! "$(command -v brew)"; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> ~/.zprofile
  source ~/.zprofile
  echo '' >> ~/.bash_profile
  echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> ~/.bash_profile
  source ~/. bash_profile
else
  if [[ -z "${CI}" ]]; then
    echo "Updating Homebrew..."
    brew update
    brew upgrade
    brew doctor
  fi
fi

# Install everything in Brewfile
brew bundle

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/bash";
fi;

# # use autocomplete with the Heroku CLI tools
# heroku autocomplete --refresh-cache

echo '' >> ~/.bash_profile
echo 'export PATH="$(brew --prefix)/ruby/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

source ~/.bashrc

gem install solargraph

# Remove outdated versions from the cellar
brew cleanup
