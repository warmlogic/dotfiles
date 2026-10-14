# Keep PATH entries unique, so re-sourcing or nested shells don't pile up duplicates
typeset -gU PATH path  # both: -U on `path` alone misses `export PATH="x:$PATH"`; -g because 01-bootstrap.sh sources this from a function, where a bare typeset makes PATH local and empty

# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="spaceship"

# Correct misspelled command names but not arguments
setopt correct

# Update Oh My Zsh, and frequency (days)
zstyle ':omz:update' mode auto # (auto, reminder, disabled)
zstyle ':omz:update' frequency 7

# Standard plugins can be found in $ZSH/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    brew
    colored-man-pages
    colorize
    # common-aliases
    docker
    gh
    git
    history-substring-search
    kubectl
    macos
    python
    rails
    # rake
    rbenv
    # ruby
    uv
    virtualenv
    vscode
    web-search
    zoxide
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Load the shell dotfiles, and then some:
# * ~/.exports.local (machine-local, not in the repo) overrides ~/.exports.
for file in ~/.{exports,exports.local,aliases,functions}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Keep 100k entries of history (Oh My Zsh defaults to 50k in memory, 10k saved)
HISTSIZE=100000
SAVEHIST=100000

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari Music SystemUIServer Terminal" killall;
