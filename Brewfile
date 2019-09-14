# Install via
# $ brew tap Homebrew/bundle
# $ brew bundle

# This puts the applications in the correct folder
cask_args appdir: '/Applications'

# List of brew repositories
tap 'homebrew/bundle'
tap 'caskroom/versions'

# Use GNU instead of BSD commands
# the with-default-names uses normal name, rather than g-prefixed
brew 'coreutils'
brew 'findutils'
brew 'readline'
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

# Newest version of Bash
brew 'bash'
# Bash tab completion for Bash
brew 'bash-completion@2'
# Better top command
brew 'htop'

# Git and some surrounds
brew 'git'
brew 'git-lfs'
brew 'git-flow'
brew 'git-extras'

# Simple cheat-sheets; install and run `$ cheat tar`
brew 'cheat'

brew 'file-formula' # guess file type
brew 'gcc'
brew 'gcc@5' # for `pip install -U xgboost` because it won't use gcc-7
brew 'gcc@7'
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

cask '1password'  # 1Password 7
cask 'slack'
cask 'visual-studio-code'
cask 'sublime-text'
cask 'jupyter-notebook-viewer'
cask 'docker'
cask 'arq'
cask 'spectacle'  # window manager
cask 'itsycal'
cask 'keybase'
cask 'firefox'
cask 'google-chrome'
cask 'vlc'
cask 'omnidisksweeper'
cask 'protonvpn'  # VPN
cask 'wordservice'
cask 'kindle'
cask 'postico'  # databases
cask 'oversight'  # alert on camera or mic usage
cask 'mactex-no-gui'
# cask 'zoomus'

# # Not installing these applications via brew cask

# cask 'hammerspoon'  # https://github.com/Hammerspoon/hammerspoon
# cask 'yujitach-menumeters'
# cask 'noisy'
# cask 'tunnelblick'  # VPN
# cask 'transmission'
# cask 'aquamacs'
# cask 'shiftit'  # window manager
# cask 'google-chrome-canary'
# cask 'google-drive-file-stream'  # gsuite
# cask 'google-backup-and-sync'  # personal
# cask 'google-cloud-sdk'
# cask 'keepingyouawake'  # replacement for Caffeine
# cask 'dropbox'
# cask 'rescuetime'  # creepy
# cask 'postman'
# cask 'insomnia'
# cask 'macdown'
# cask 'ngrok'
# cask 'lastfm'
# cask 'quicksilver'
# cask 'github-desktop'
# cask 'sourcetree'
# cask 'flux'
# cask 'selfcontrol'
# cask 'sublime-text-dev'
# cask 'iterm2'
# cask 'harvest'
# cask 'adobe-reader'
# cask 'spotify'
# cask 'spotify-notifications'

# Install QuickLook plugins https://github.com/sindresorhus/quick-look-plugins
cask 'qlcolorcode'  # syntax highlighting
cask 'qlmarkdown'
cask 'quicklook-json'
cask 'qlstephen'  # view plain text files without a file extension
cask 'qlvideo'
cask 'qlprettypatch'  # view .patch files
cask 'qlimagesize'  # display image size and resolution
cask 'betterzip'  # preview archives
# cask 'quicklook-csv'
# cask 'suspicious-package'

# Install Mac App Store apps
mas 'Mail Notifr', id: 808154494
mas 'The Unarchiver', id: 425424353
mas 'Deliveries', id: 924726344
mas 'Amphetamine', id: 937984704  # replacement for Caffeine
mas 'JustFocus', id: 1142151959
mas 'Wipr', id: 1320666476
mas 'Binaural', id: 946812450
mas 'Keynote', id: 409183694
mas 'Numbers', id: 409203825
mas 'Pages', id: 409201541
mas 'Polyglot', id: 1471801525  # Safari extension for translation
mas 'Table Tool', id: 1122008420  # CSV viewer/editor and quicklook
# mas '1Password', id: 443987910  # 1Password 6
# mas 'GarageBand', id: 682658836
# mas 'iMovie', id: 408981434
# mas 'Slack', id: 803453959
