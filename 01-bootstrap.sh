#!/usr/bin/env zsh

cd "$(dirname "${BASH_SOURCE}")";

# pull the current branch
git pull origin $(git rev-parse --abbrev-ref HEAD);

MY_SHELL=$(ps -p $$ -ocomm=)

function doIt() {
    rsync --exclude ".git/" \
        --exclude ".DS_Store" \
        --exclude ".extra" \
        --exclude "01-bootstrap.sh" \
        --exclude "02-brew.sh" \
        --exclude "03-macos.sh" \
        --exclude "04-python.sh" \
        --exclude "05-python-updates.sh" \
        --exclude "Brewfile" \
        --exclude "Brewfile_work" \
        --exclude "README.md" \
        --exclude "LICENSE-MIT.txt" \
        -avh --no-perms . ~;
    if [[ "$MY_SHELL" =~ 'zsh' ]]; then
        source ~/.zshrc;
    elif [[ "$MY_SHELL" =~ 'bash' ]]; then
        source ~/.bash_profile;
    fi;
}

if [[ "$MY_SHELL" =~ 'zsh' ]]; then
    read -q "REPLY?This may overwrite existing files in your home directory. Are you sure? (y/n) ";
elif [[ "$MY_SHELL" =~ 'bash' ]]; then
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
fi;

echo "";

if [[ $REPLY =~ ^[Yy]$ ]]; then
    doIt;
fi;

unset doIt;
