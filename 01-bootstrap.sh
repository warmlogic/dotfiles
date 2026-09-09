#!/usr/bin/env zsh

cd "$(dirname "${BASH_SOURCE}")";

# pull the current branch
git pull origin $(git rev-parse --abbrev-ref HEAD);

MY_SHELL=$(ps -p $$ -ocomm=)

function doIt() {
    rsync -avh --no-perms --exclude .DS_Store --exclude .extra home/ ~;
    if [[ "$MY_SHELL" =~ 'zsh' ]]; then
        if [ -f ~/.zshrc ]; then
            source ~/.zshrc;
        fi;
    elif [[ "$MY_SHELL" =~ 'bash' ]]; then
        if [ -f ~/.bash_profile ]; then
            source ~/.bash_profile;
        fi;
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
