# The following lines were added by Docker Desktop to add commands to your PATH.
export PATH="$PATH:$HOME/.docker/bin"
# End of Docker Desktop section.

# Set up Homebrew (guarded: 01-bootstrap.sh installs this file before 02-brew.sh installs brew)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  # Add Homebrew tab completion
  # https://docs.brew.sh/Shell-Completion
  FPATH="${HOMEBREW_PREFIX}/share/zsh/site-functions:${FPATH}"
fi

# Load SSH key passphrases from the macOS Keychain into the agent, so git commit
# signing works after a restart without asking (see ~/.ssh/config)
ssh-add --apple-load-keychain -q 2>/dev/null
