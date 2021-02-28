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
brew 'gpatch'
brew 'less'
# https://xgboost.readthedocs.io/en/latest/build.html#building-on-osx
brew 'libomp'  # for xgboost
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

# Easy cd https://github.com/rupa/z
brew 'z'

# Mac Swiss Army Knife https://github.com/rgcr/m-cli
brew 'm-cli'

# Support for Mac App Store apps https://github.com/mas-cli/mas
brew 'mas'

# Heroku; run this after to use autocomplete with the CLI tools: heroku autocomplete --refresh-cache
brew 'heroku/brew/heroku'

# Install additional applications

cask '1password'  # 1Password 7
cask 'slack'
cask 'visual-studio-code'
cask 'spotify'
cask 'jupyter-notebook-viewer'
cask 'spectacle'  # window manager
cask 'itsycal'
cask 'google-chrome'
cask 'firefox'
cask 'vlc'
cask 'omnidisksweeper'
cask 'protonvpn'  # VPN
cask 'wordservice'
cask 'transmission'
cask 'kindle'
cask 'docker'

# # Not installing these applications via brew cask

# cask 'sublime-text'
# cask 'keybase'
# cask 'oversight'  # alert on camera or mic usage
# cask 'mactex-no-gui'  # latex
# cask 'postico'  # databases
# cask 'postgres'  # add to ~/.bash_profile: PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"
# cask 'arq'  # backup
# cask 'zoomus'
# cask 'hammerspoon'  # https://github.com/Hammerspoon/hammerspoon
# cask 'yujitach-menumeters'
# cask 'noisy'
# cask 'tunnelblick'  # VPN
# cask 'aquamacs'
# cask 'shiftit'  # window manager
# cask 'google-chrome-canary'
# cask 'google-drive-file-stream'  # gsuite
# cask 'google-backup-and-sync'  # personal
# cask 'google-cloud-sdk'
# cask 'keepingyouawake'  # replacement for Caffeine
# cask 'dropbox'
# cask 'postman'
# cask 'insomnia'
# cask 'macdown'
# cask 'ngrok'
# cask 'lastfm'
# cask 'quicksilver'
# cask 'github-desktop'
# cask 'sourcetree'
# cask 'selfcontrol'
# cask 'sublime-text-dev'
# cask 'iterm2'
# cask 'harvest'
# cask 'adobe-reader'

# Install QuickLook plugins https://github.com/sindresorhus/quick-look-plugins
cask 'qlstephen'  # view plain text files without a file extension
cask 'qlmarkdown'
cask 'betterzip'  # preview archives
cask 'qlcolorcode'  # syntax highlighting
cask 'quicklook-json'
# cask 'qlvideo'
# cask 'qlprettypatch'  # view .patch files
# cask 'qlimagesize'  # display image size and resolution
# cask 'quicklook-csv'
# cask 'suspicious-package'

# Install apps via Mac App Store
mas 'The Unarchiver', id: 425424353
mas 'Deliveries', id: 924726344
mas 'Amphetamine', id: 937984704
mas 'JustFocus', id: 1142151959
mas 'Binaural', id: 946812450
mas 'Table Tool', id: 1122008420  # CSV viewer/editor and quicklook
mas 'Tot', id: 1491071483
mas 'Poolside FM', id: 1514817810
# mas '1Password', id: 1333542190  # 1Password 7
# mas 'Slack', id: 803453959
# mas 'Mail Notifr', id: 808154494
# mas 'Keynote', id: 409183694
# mas 'Numbers', id: 409203825
# mas 'Pages', id: 409201541
# mas 'GarageBand', id: 682658836
# mas 'iMovie', id: 408981434

# Install Safari extensions via Mac App Store
mas 'Wipr', id: 1320666476
mas 'CleanLinksForGoogle', id: 1467225874  # Safari extension to remove Google redirect URLs
mas 'DuckDuckGo Privacy Essentials', id: 1482920575
mas 'Hush', id: 1544743900
# mas 'Polyglot', id: 1471801525  # Safari extension for translation
