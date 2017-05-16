#!/usr/bin/env bash
echo "Install all Mac App Store apps first!"
echo "1Password"
echo "Slack"
echo "Mail Notifr"
echo "Deliveries"
echo "Just Focus"
echo "GarageBand"
echo "iMovie"
echo "Keynote"
echo "Numbers"
echo "Pages"
read -p "Press any key to continue... " -n1 -s
echo ""

# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Get homebrew
# Modified from: https://github.com/pathikrit/mac-setup-script/blob/master/setup.sh
if test ! $(which brew); then
  echo "Installing Xcode command line developer tools..."
  xcode-select --install

  echo "Installing Homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "Updating Homebrew..."
  brew update
  brew upgrade
fi

# Install everything in Brewfile
brew bundle

# Switch to using brew-installed bash as default shell
if ! fgrep -q '/usr/local/bin/bash' /etc/shells; then
  echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
  chsh -s /usr/local/bin/bash;
fi;

# Remove outdated versions from the cellar
brew cleanup
