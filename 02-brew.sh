#!/usr/bin/env zsh

# Install command-line tools using Homebrew.
# Usage: ./02-brew.sh [--work]

case "${1:-}" in
  "") PROFILE=personal ;;
  --work) PROFILE=work ;;
  *) echo "Usage: $0 [--work]" >&2; exit 2 ;;
esac

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
brew bundle --file="Brewfile.$PROFILE"

# Sign in to GitHub. With the ssh protocol, gh offers to generate an SSH key
# (if you have none) and upload it to your account.
if ! gh auth status &>/dev/null; then
  gh auth login --hostname github.com --git-protocol ssh --web --scopes admin:ssh_signing_key
fi

# Sign commits with the same SSH key, and register it with GitHub as a signing
# key so commits show as Verified. Identity-specific, so it goes in ~/.gitconfig.local.
if [[ -f ~/.ssh/id_ed25519.pub ]] && ! git config --file ~/.gitconfig.local gpg.format &>/dev/null; then
  gh auth status 2>&1 | grep -q admin:ssh_signing_key || gh auth refresh --hostname github.com --scopes admin:ssh_signing_key
  gh ssh-key add ~/.ssh/id_ed25519.pub --type signing --title "$(scutil --get ComputerName)" &&
    git config --file ~/.gitconfig.local gpg.format ssh &&
    git config --file ~/.gitconfig.local user.signingkey ~/.ssh/id_ed25519.pub &&
    git config --file ~/.gitconfig.local commit.gpgsign true &&
    git config --file ~/.gitconfig.local tag.gpgsign true
fi

# Work: fetch GitHub over ssh even when a URL says https (BranchServer's private gems)
if [[ "$PROFILE" == work ]]; then
  git config --file ~/.gitconfig.local url."git@github.com:".insteadOf https://github.com/
fi

# The first clone can be over https (public repo, no key needed yet); switch
# it to ssh now that GitHub knows your key
origin="$(git -C "${0:A:h}" remote get-url origin)"
if [[ "$origin" == https://github.com/* ]]; then
  git -C "${0:A:h}" remote set-url origin "git@github.com:${${origin#https://github.com/}%.git}.git"
fi

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
