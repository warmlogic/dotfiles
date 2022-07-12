# Matt's dotfiles

This repo borrows heavily from Mathias Bynens's [dotfiles](https://github.com/mathiasbynens/dotfiles/) and Dries Vints's [dotfiles](https://github.com/driesvints/dotfiles).

This also includes `tmux` files from [this repo](https://github.com/gpakosz/.tmux).

## Installation

**Warning:** If you want to give these dotfiles a try, you should first fork this repository, review the code, and remove things you don't want or need. Don't blindly use my settings unless you know what that entails. Use at your own risk!

Some of the functionality of these dotfiles depends on formulae installed by `02-brew.sh`. If you don't plan to run `02-brew.sh`, you should look carefully through the script and manually install any particularly important ones. A good example is Bash/Git completion: the dotfiles use a special version from Homebrew.

### Quick instructions overview

1. Update macOS to the latest version
1. Install the Xcode command line developer tools (required for `git`): `xcode-select --install`
1. While you're waiting, create credentials for this computer and add to GitHub.
    1. [Generate a new ssh key](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/): `ssh-keygen -t rsa -b 4096 -C "your_email@example.com"`
    1. [Log in to GitHub](https://github.com/login)
    1. [Add your new public key to your GitHub account settings](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/) [here](https://github.com/settings/keys): `pbcopy < ~/.ssh/id_rsa.pub`
1. Clone this repo
    1. `mkdir -p ~/github/warmlogic`
    1. `cd ~/github/warmlogic/`
    1. `git clone git@github.com:warmlogic/dotfiles.git`
    1. `cd ~/github/warmlogic/dotfiles/`
1. Run `01-bootstrap.sh` to copy necessary files (hidden and otherwise)
1. `cp .extra ~/.extra` and edit, if desired (explained below)
1. If installing Mac App Store apps with Brew, sign in to the Mac App Store
1. Ensure `Brewfile` includes only the programs you want to install
    1. Run `02-brew.sh` to install apps
1. Run `03-macos.sh` to set up macOS preferences
1. Restart your computer
1. Run `04-python.sh` to set up the `base` Python 3 conda environment
1. Run `05-python-updates.sh` to update the `base` environment, installing Python 3.10 and making additional convenient updates
1. Set up installed applications (look at `Brewfile` as a reminder of what was installed)
1. If needed, copy public and private ssh keys from previous computer to `~/.ssh/` and `chmod` to `600`
   - Set up `~/.ssh/config` to add ssh keys to Keychain ([instructions](https://github.com/jirsbek/SSH-keys-in-macOS-Sierra-keychain))
1. [Set up "Open in Safari or Chrome URL in Other Browser AppleScript + Automator Workflow](https://gist.github.com/warmlogic/e6b2f30640b4c5de2077373fb53f6df3)

More details below.

### Using Git and the bootstrap script

Clone the repository wherever you want (I keep it in `~/github/warmlogic/dotfiles`). The bootstrapper script (`01-bootstrap.sh`) will pull in the latest version and copy the files to your home folder.

`cd` into your local `dotfiles` repository, and start the installation:

```bash
source 01-bootstrap.sh
```

### Specify the `$PATH`

If `~/.path` exists, it will be sourced along with the other files before any feature testing (such as [detecting which version of `ls` is being used](https://github.com/mathiasbynens/dotfiles/blob/aff769fd75225d8f2e481185a71d5e05b76002dc/.aliases#L21-26)) takes place.

Here's an example `~/.path` file that adds `/usr/local/bin` to the `$PATH`:

```bash
export PATH="/usr/local/bin:$PATH"
```

### Add custom commands without creating a new fork

If `~/.extra` exists, it will be sourced along with the other files. You can use this to add a few custom commands without the need to fork this entire repository, or to add commands you don't want to commit to a public repository.

NB: `~/.extra` is included in the repo, but it is not automatically copied over by `01-bootstrap.sh`. Therefore, you'll want to run the following command and edit the new file's contents:

```bash
cp .extra ~/.extra
```

You can also use `~/.extra` to override settings, functions, and aliases. It's probably better to [fork this repository](https://github.com/warmlogic/dotfiles/fork) instead, though.

### Install Homebrew formulae

When setting up a new Mac, you may want to install some common [Homebrew](http://brew.sh/) formulae. This installs the Xcode command line developer tools, Homebrew, and everything listed in `Brewfile`.

```bash
./02-brew.sh
```

### Set macOS Preferences

When setting up a new Mac, you may want to set some sensible macOS defaults:

```bash
./03-macos.sh
```

### Python/Anaconda setup

You may also want Python and a number of useful packages related to data analysis (via [miniconda](https://docs.conda.io/en/latest/miniconda.html) or [miniforge](https://github.com/conda-forge/miniforge/)). This sets up a `base` conda environment installs everything listed in `init/environment.yml`.

```bash
./04-python.sh
./05-python-updates.sh
```

### Additional setup

#### Set applications to start at login

- Rectangle
- Amphetamine
- Tot

#### Lock Screen

- Set recovery info message: System Preferences -> Security and Privacy -> General -> Show a message when the screen is locked
  - Hi! I belong to `$NAME`. If I'm lost and you find me, please contact `$NAME` at `$CONTACT_INFO`

#### Calendar

- Add accounts with your calendars to Internet Accounts (System Preferences)
- Itsycal format: `h:mm a`, show day

#### Safari Extensions

- Installed via `Brewfile`

#### Visual Studio Code

- Turn on syncing

## Feedback

Suggestions/improvements [welcome](https://github.com/warmlogic/dotfiles/issues)!
