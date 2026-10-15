# Matt's dotfiles

This repo borrows heavily from Mathias Bynens's [dotfiles](https://github.com/mathiasbynens/dotfiles/) and Dries Vints's [dotfiles](https://github.com/driesvints/dotfiles).

This also includes `tmux` files from [this repo](https://github.com/gpakosz/.tmux).

## Layout

- `home/` mirrors `$HOME` — every file and directory in here gets rsync'd on top of your home directory by `01-bootstrap.sh`. Edit files here, not in `~`, then re-run `01-bootstrap.sh` to apply the change.
- `home/.local/bin/` holds small command-line tools; `~/.local/bin` is on `PATH` (`home/.exports`). `codex-usage status` shows Codex plan usage and reset credits (`--json` for raw); `codex-usage reset --yes` spends a reset credit. It needs `codex` installed and logged in.
- The numbered scripts at the repo root set up a machine, in order (see below). They mutate the machine (installs, macOS `defaults write`, moving files into `$HOME`) — only run them deliberately.
- `Brewfile.common` / `Brewfile.personal` / `Brewfile.work` are Homebrew bundles: common is always installed, and either personal or work is layered on top depending on the machine.
- `init/` holds terminal color themes (`.terminal` files, an `.itermcolors` file) and saved app settings (`com.if.Amphetamine.plist`) that `03-macos.sh` applies; `init/` is not mirrored to `$HOME`.

## Installation

**Warning:** If you want to give these dotfiles a try, you should first fork this repository, review the code, and remove things you don't want or need. Don't blindly use my settings unless you know what that entails. Use at your own risk!

### Quick instructions overview

1. Update macOS to the latest version
1. Install the Xcode command line developer tools (required for `git`): `xcode-select --install`
1. Clone this repo over https (no SSH key needed yet; `02-brew.sh` switches it to ssh later)
   1. `mkdir -p ~/github/warmlogic`
   1. `cd ~/github/warmlogic/`
   1. `git clone https://github.com/warmlogic/dotfiles.git`
   1. `cd ~/github/warmlogic/dotfiles/`
1. Run `01-bootstrap.sh` to copy `home/` into `$HOME` (first run asks for your git name and email)
1. If installing Mac App Store apps with Brew, sign in to the Mac App Store
1. Ensure the Brewfiles include only the programs you want to install
   1. Run `02-brew.sh` to install apps (add `--work` on a work machine to layer `Brewfile.work` instead of `Brewfile.personal`). At the end it signs you in to GitHub with `gh`, which can create an SSH key and add it to your account. Give the key a passphrase when asked; see [SSH key passphrase](#ssh-key-passphrase). If it doesn't, see [SSH key](#ssh-key).
1. Run `03-macos.sh` to set up macOS preferences (add `--work` on a work machine)
1. Restart your computer
1. Run `04-python.sh` to set up Python via `uv`
1. Before first launching Claude Code or Codex, restore their config: see [Claude Code and Codex config](#claude-code-and-codex-config)
1. Run `./check.sh` (add `--work` on a work machine) to confirm every step finished; it's read-only and safe to run any time
1. Sign in to and set up apps: see [App sign-in checklist](#app-sign-in-checklist)
1. [Set up "Open in Safari or Chrome URL in Other Browser AppleScript + Automator Workflow](https://gist.github.com/warmlogic/e6b2f30640b4c5de2077373fb53f6df3)

More details below.

### App sign-in checklist

Apps from the Brewfiles that need an account, license, or one-time enabling. Apps not listed work without setup.

All machines:

- [ ] 1Password (do this first; most other sign-ins come from it)
- [ ] Safari → Settings → Extensions: enable Wipr 2
- [ ] Google Chrome
- [ ] Slack
- [ ] Claude and ChatGPT
- [ ] Docker Desktop: accept the license, and sign in if your company pays for it
- [ ] Zoom
- [ ] Spotify
- [ ] Cursor and VS Code (GitHub sign-in / Settings Sync)
- [ ] Little Snitch Mini (approve its network extension)
- [ ] MonitorControl (grant Accessibility)

Work (`Brewfile.work`):

- [ ] AWS: install the samltoawsstskeys extension in the Chrome profile signed in as your work account, fill in the `AWS_GOOGLE_*` variables in `~/.exports.local`, then run `aws-auth-get-saml2sts-credentials`
- [ ] Lens and k9s: copy or create `~/.kube/config` (e.g. `aws eks update-kubeconfig`)
- [ ] Loom
- [ ] Postman

Personal (`Brewfile.personal`):

- [ ] Ableton Live Lite
- [ ] Loopback (license)
- [ ] Steam
- [ ] Amazon Kindle

### Using Git and the bootstrap script

Clone the repository wherever you want (I keep it in `~/github/warmlogic/dotfiles`). The bootstrapper script (`01-bootstrap.sh`) will pull in the latest version and rsync everything under `home/` into your home folder.

`cd` into your local `dotfiles` repository, and start the installation:

```sh
source 01-bootstrap.sh
```

### Personal settings (`~/.exports.local`)

This repo is public, so personal values (PATH additions, account emails, SSO URLs) don't go in `home/`. They go in `~/.exports.local`, which `01-bootstrap.sh` creates once from `exports.local.template` and then never touches. Uncomment and fill in what you need. It's sourced right after `~/.exports`, so it can also override anything there. The git equivalent is `~/.gitconfig.local` (next section).

Don't edit `~/.exports` (or any other file `home/` provides) directly: `01-bootstrap.sh` overwrites it, and `check.sh` reports the difference.

### Git identity

Git `user.name` and `user.email` aren't in this repo. `home/.gitconfig` includes `~/.gitconfig.local`, which `01-bootstrap.sh` creates on first run by asking for both (pressing Enter keeps any identity the machine already has). After that it's left alone; edit it with `git config --file ~/.gitconfig.local user.email you@example.com`.

`02-brew.sh` also sets up commit signing once you're signed in to GitHub: it points `~/.gitconfig.local` at `~/.ssh/id_ed25519.pub` with `gpg.format ssh`, and uploads that key to GitHub as a signing key, so your commits show as Verified. It's skipped if you have no `~/.ssh/id_ed25519.pub` or signing is already configured.

### SSH key

`02-brew.sh` signs you in with `gh auth login --git-protocol ssh`, which offers to generate `~/.ssh/id_ed25519` and add it to GitHub. Accept that and give the key a passphrase. If `gh` was already signed in, `02-brew.sh` skips the login, so no key gets created. The same happens if you decline. In that case, make the key yourself, then re-run `02-brew.sh` so it sets up commit signing with the key:

```sh
ssh-keygen -t ed25519 -C "$(git config user.email)"        # writes ~/.ssh/id_ed25519; prompts for a passphrase
ssh-add --apple-use-keychain ~/.ssh/id_ed25519              # store the passphrase in the Keychain
gh ssh-key add ~/.ssh/id_ed25519.pub --title "$(scutil --get ComputerName)"
```

### SSH key passphrase

Give your SSH key a passphrase, and macOS remembers it in the Keychain so you don't have to type it. `home/.ssh/config.d/dotfiles` turns on `UseKeychain` (bootstrap adds an `Include` for it to the top of `~/.ssh/config`, which otherwise stays yours, so hosts that tools like the AWS Toolkit add there survive re-runs), and `home/.zprofile` loads the key into the agent at login so commit signing works too.

```sh
ssh-keygen -p -f ~/.ssh/id_ed25519                # add or change the passphrase
ssh-add --apple-use-keychain ~/.ssh/id_ed25519    # store it in the Keychain (once per machine)
```

### GitHub access

- **ssh** (`git@github.com:` remotes) uses your SSH key; see [SSH key passphrase](#ssh-key-passphrase). On a network that blocks port 22, prefix the command with `git443` (e.g. `git443 pull`, defined in `home/.functions`) to reach GitHub's ssh on port 443 instead.
- **https** (`https://github.com/` URLs, e.g. private git gems in a Gemfile) uses your `gh` login: `home/.gitconfig` sets `gh` as the credential helper for GitHub.

### Install Homebrew formulae

When setting up a new Mac, you may want to install some common [Homebrew](http://brew.sh/) formulae. This installs the Xcode command line developer tools, Homebrew, `Brewfile.common`, and then either `Brewfile.personal` or `Brewfile.work`.

```sh
./02-brew.sh          # personal machine
./02-brew.sh --work    # work machine
```

**One owner per tool:** each tool is installed either by a Brewfile or by its own installer in a numbered script, never both. A self-updating tool installed through brew gets re-downloaded every `brew upgrade`, fighting its own updater. `uv` is the current example: it's installed by `04-python.sh` via its official installer, not by any Brewfile, so `uv self update` stays in charge of its own version. Casks for self-updating apps (Docker Desktop, Claude, ChatGPT) are fine in a Brewfile: Homebrew marks them `auto_updates`, and `brew upgrade` leaves them alone unless you pass `--greedy`.

### Set macOS Preferences

When setting up a new Mac, you may want to set some sensible macOS defaults:

```sh
./03-macos.sh
```

### Python setup

Python is managed with [`uv`](https://docs.astral.sh/uv/) (installed by `04-python.sh` via its own installer, see the "One owner per tool" note above):

- `uv tool install <name>` for global CLIs (ruff, pre-commit, ipython, jupyterlab)
- `~/.venvs/<name>` for ad-hoc, throwaway environments — activate with the `workon` shell function (e.g. `workon scratch`), defined in `home/.functions`
- `uv run` inside a project directory for project-scoped dependencies

The oh-my-zsh `uv` plugin (enabled in `home/.zshrc`) provides completions and short aliases (e.g. `uvr` = `uv run`); `workon <name>` activates ad-hoc venvs.

```sh
./04-python.sh
```

### Claude Code and Codex config

`~/.claude` and `~/.codex` config (CLAUDE.md, rules, settings, hooks, Codex `config.toml`) lives in the private repo [warmlogic/dotfiles-private](https://github.com/warmlogic/dotfiles-private). It's a bare repo whose work tree is `$HOME`, so the live files are the tracked files: an edit to `~/.claude/CLAUDE.md` shows up in `git status` with no copying and no symlinks. The `dfp` alias in `home/.aliases` is plain git pointed at that repo; `~/.config/dotfiles-private/allowlist` lists what's tracked, and everything else in `$HOME` is ignored.

Restore it before first launching Claude Code or Codex. If either already ran, quit it; the backup keeps the files it created, and `-f` replaces them:

```sh
git clone --bare git@github.com:warmlogic/dotfiles-private.git ~/.dotfiles-private
alias dfp='git --git-dir=$HOME/.dotfiles-private --work-tree=$HOME'   # already defined once bootstrap has run
cp -R ~/.claude ~/.claude.bak 2>/dev/null; cp -R ~/.codex ~/.codex.bak 2>/dev/null
dfp checkout -f
dfp config core.excludesFile ~/.config/dotfiles-private/allowlist
dfp config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
dfp fetch && dfp branch -u origin/main main
```

Day to day: `dfp status`, then `dfp add <path> && dfp commit -m "..." && dfp push`. A new file to track needs a `!` line in the allowlist. Credentials, transcripts, plugin caches, and Claude's auto-memory are deliberately untracked; the private repo's README has the rest.

### Additional setup

#### Lock Screen

- Set recovery info message: System Preferences -> Security and Privacy -> General -> Show a message when the screen is locked
  - Hi! I belong to `$NAME`. If I'm lost and you find me, please contact `$NAME` at `$CONTACT_INFO`

#### Calendar

- Add accounts with your calendars to Internet Accounts (System Preferences)
- Itsycal format: `h:mm a`, show day

#### Terminal themes

- `init/` holds `.terminal` and `.itermcolors` files. `03-macos.sh` installs the `.terminal` themes into Terminal.app; iTerm2/Ghostty themes need to be imported manually.

#### Safari Extensions

- Installed via the Brewfiles

#### Visual Studio Code

- Turn on syncing

## Feedback

Suggestions/improvements [welcome](https://github.com/warmlogic/dotfiles/issues)!
