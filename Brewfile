# Install via
# $ brew tap Homebrew/bundle
# $ brew bundle

# This puts the applications in the correct folder
cask_args appdir: '/Applications'

# List of brew repositories
tap 'homebrew/bundle'
tap 'homebrew/dupes'
tap 'caskroom/versions'
tap 'homebrew/versions'

# Use GNU instead of BSD commands
# the with-default-names uses normal name, rather than g-prefixed
brew 'coreutils'
brew 'findutils'
brew 'gawk'
brew 'gnu-indent', args: ['with-default-names']
brew 'gnu-sed', args: ['with-default-names']
brew 'gnu-tar', args: ['with-default-names']
brew 'gnu-which', args: ['with-default-names']
brew 'gnutls', args: ['with-default-names']
brew 'grep', args: ['with-default-names']
brew 'gzip'
brew 'screen'
brew 'watch'
brew 'wdiff', args: ['with-gettext']
brew 'wget', args: ['with-iri']

# Update tools that already exist on Mac

# Newest version of Bash 4.x
brew 'bash'
# Bash tab completion for Bash 4.x
brew 'bash-completion2'
# Better top command
brew 'htop'

# Git and some surrounds
brew 'git'
brew 'git-lfs'
brew 'git-flow'
brew 'git-extras'

# Amazon command line interface
brew 'awscli'

# Simple cheat-sheets; install and run `$ cheat tar`
brew 'cheat'

brew 'file-formula' # guess file type
brew 'gcc'
brew 'gcc@5' # for `pip install -U xgboost` because it won't use gcc-7
brew 'gpatch'
brew 'less'
brew 'make'
brew 'rsync'
brew 'imagemagick', args: ['with-webp']

brew 'graphviz' # for python tree model plotting

brew 'pandoc'
brew 'rename'
brew 'tmux'
# Helps tmux work on macOS https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard
brew 'reattach-to-user-namespace'

# Visualize directory structure
brew 'tree'

brew 'unrar'
brew 'unzip'
brew 'vim', args: ['override-system-vi']
brew 'emacs', args: ['--with-cocoa']

# Mac Swiss Army Knife https://github.com/rgcr/m-cli
brew 'm-cli'

# Support for Mac App Store apps https://github.com/mas-cli/mas
brew 'mas'

# # not installing
# brew 'binutils'
# brew 'diffutils'
# brew 'hub'
# brew 'ctags'
# brew 'gpg'
# brew 'jsonpp'
# brew 'svn'
# brew 'the_silver_searcher'
# brew 'most'
# # Don't use non-native ssh if storing passphrase in Keychain
# brew 'openssh'
# brew 'ssh-copy-id'

# Install additional applications

cask 'slack'
cask 'sublime-text'
cask 'aquamacs'
cask 'google-chrome'
cask 'google-drive-file-stream'
cask 'google-cloud-sdk'
cask 'dropbox'
cask 'box-sync'
cask 'github-desktop'
cask 'arq'
cask 'spectacle'
cask 'yujitach-menumeters'
cask 'itsycal'
cask 'caffeine'
cask 'keybase'
cask 'omnidisksweeper'
cask 'noisy'
cask 'rescuetime'
cask 'transmission'
cask 'vlc'
cask 'lastfm'
cask 'wordservice'
cask 'kindle'
cask 'docker'
cask 'quicksilver'

# # Not installing these applications via brew cask

# cask 'flux'
# cask 'harvest'
# cask 'selfcontrol'
# cask 'google-chrome-canary'
# cask 'google-backup-and-sync'
# cask 'box-edit'
# cask 'sublime-text-dev'
# cask 'slack-beta'
# cask 'iterm2'
# cask 'macdown'
# cask 'toggldesktop'
# cask 'sourcetree'
# cask 'adobe-reader'
# cask 'spotify'
# cask 'spotify-notifications'
# cask 'oversight'
# cask 'mactex'
# cask 'ngrok'
# cask 'shiftit'

# Install QuickLook plugins https://github.com/sindresorhus/quick-look-plugins
cask 'qlcolorcode'
cask 'qlmarkdown'
cask 'quicklook-json'
cask 'quicklook-csv'
cask 'qlstephen'
cask 'qlvideo'
cask 'betterzipql'
# cask 'suspicious-package'
# cask 'qlimagesize'
# cask 'quicklookase'
# cask 'qlprettypatch'

# Install Mac App Store apps
mas '1Password', id: 443987910
# mas 'Slack', id: 803453959
mas 'Mail Notifr', id: 808154494
mas 'The Unarchiver', id: 425424353
mas 'Deliveries', id: 924726344
mas 'JustFocus', id: 1142151959
mas 'GarageBand', id: 682658836
mas 'iMovie', id: 408981434
mas 'Keynote', id: 409183694
mas 'Numbers', id: 409203825
mas 'Pages', id: 409201541

# # This installs helper functions for downloading jupyter notebook templates
# # https://github.com/jbwhit/homebrew-tap
# # https://github.com/jbwhit/automation
# tap 'jbwhit/tap'
# brew 'nb3automation'
