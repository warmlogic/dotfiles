# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# Set up Homebrew
eval $(/opt/homebrew/bin/brew shellenv)

# Add Homebrew tab completion
# https://docs.brew.sh/Shell-Completion
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
