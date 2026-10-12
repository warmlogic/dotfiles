#!/usr/bin/env zsh

# ${0:A:h} is zsh for "this script's directory" (works whether run or sourced)
cd "${0:A:h}";

# pull the current branch
git pull origin $(git rev-parse --abbrev-ref HEAD);

MY_SHELL=$(ps -p $$ -ocomm=)

function doIt() {
    # Note any existing git identity before rsync replaces ~/.gitconfig
    local git_name="$(git config --global user.name)";
    local git_email="$(git config --global user.email)";
    rsync -avh --no-perms --exclude .DS_Store home/ ~;
    # Git identity lives in ~/.gitconfig.local (included by ~/.gitconfig) so
    # it never lands in this repo. Ask once; Enter keeps the shown default.
    if [ ! -f ~/.gitconfig.local ]; then
        local answer;
        printf "Git user.name [%s]: " "$git_name"; read -r answer; git_name="${answer:-$git_name}";
        printf "Git user.email [%s]: " "$git_email"; read -r answer; git_email="${answer:-$git_email}";
        if [ -n "$git_name" ] && [ -n "$git_email" ]; then
            git config --file ~/.gitconfig.local user.name "$git_name";
            git config --file ~/.gitconfig.local user.email "$git_email";
        else
            echo "Skipped git identity (name and email are both required); re-run 01-bootstrap.sh to set it.";
        fi;
    fi;
    # Personal env vars live in ~/.exports.local; start it from the template once
    [ -f ~/.exports.local ] || cp exports.local.template ~/.exports.local;
    if [[ "$MY_SHELL" =~ 'zsh' ]]; then
        # .zshrc needs Oh My Zsh, which 02-brew.sh installs
        if [ -f ~/.zshrc ] && [ -d ~/.oh-my-zsh ]; then
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

unset -f doIt;
