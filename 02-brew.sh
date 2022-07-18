#!/usr/bin/env zsh

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

# Remove outdated versions from the cellar
brew cleanup

# Set Homebrew’s installed location
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

# Install Oh-My-Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc --unattended
source ~/.zshrc

# Install Spaceship theme for Oh-My-Zsh
git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
source ~/.zshrc

# # Use autocomplete with the Heroku CLI tools
# heroku autocomplete --refresh-cache

# Ruby
# https://stackoverflow.com/a/66379795/2592858
rbenv install $(rbenv install -l | grep -v - | tail -1)
rbenv global $(rbenv install -l | grep -v - | tail -1)
# zsh
echo '' >> ~/.zshrc
echo '# Ruby' >> ~/.zshrc
echo 'eval "$(rbenv init -)"' >> ~/.zshrc
echo 'export PATH="${HOMEBREW_PREFIX}/ruby/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
# bash
echo '' >> ~/.bash_profile
echo '# Ruby' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
echo 'export PATH="${HOMEBREW_PREFIX}/ruby/bin:$PATH"' >> ~/.bash_profile
source ~/.bashrc
gem install solargraph

# Remove the quarantine attribute for QuickLook plugins
# https://github.com/sindresorhus/quick-look-plugins#catalina-notes
xattr -d -r com.apple.quarantine ~/Library/QuickLook
