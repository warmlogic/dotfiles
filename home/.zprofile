# Set up Homebrew (guarded: 01-bootstrap.sh installs this file before 02-brew.sh installs brew)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  # Add Homebrew tab completion
  # https://docs.brew.sh/Shell-Completion
  FPATH="${HOMEBREW_PREFIX}/share/zsh/site-functions:${FPATH}"
fi
