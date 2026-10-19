#!/usr/bin/env zsh

# ${0:A:h} is zsh for "this script's directory" (works whether run or sourced)
cd "${0:A:h}";

# pull the current branch
git pull origin $(git rev-parse --abbrev-ref HEAD);

MY_SHELL=$(ps -p $$ -ocomm=)

# A file in ~ that matches no version of its home/ copy in git history was
# edited outside this repo, by you or by an app (an installer appending a PATH
# line). The rsync below would drop that edit, so show it and stop; copy what
# you want to keep into home/ (or ~/.exports.local), or pass --force.
# Lines matching $ignore are ones apps rewrite on their own (Docker Desktop
# swaps $HOME for the literal path), as in check.sh.
case "${1:-}" in
    "" | --force) ;;
    *) echo "Usage: 01-bootstrap.sh [--force]" >&2; return 2 ;;
esac
ignore='\.docker/bin';
edited=();
for f in ${(f)"$(rsync -rcn --out-format='%n' --exclude .DS_Store home/ ~ | grep -v '/$')"}; do
    [[ -f ~/$f ]] || continue;
    command diff -q -I "$ignore" "home/$f" ~/"$f" > /dev/null && continue;
    git log --all --format= --raw --no-abbrev -- "home/$f" | grep -qF " $(git hash-object ~/"$f") " && continue;
    edited+=("$f");
done
if (( ${#edited} )) && [[ "${1:-}" != --force ]]; then
    for f in $edited; do
        print "── ~/$f: lines marked - exist only in ~ and would be lost";
        command diff -u ~/"$f" "home/$f" | tail -n +3;
    done
    print "\nThese files in ~ were edited outside this repo. Copy what you want to keep into home/ (or ~/.exports.local) and re-run, or re-run with --force to overwrite them.";
    return 1;
fi

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
    # SSH settings live in ~/.ssh/config.d/dotfiles; ~/.ssh/config itself stays
    # yours, since tools (AWS Toolkit, VS Code Remote) add hosts to it. Put the
    # Include first so its settings apply to every host.
    local ssh_include='Include ~/.ssh/config.d/dotfiles';
    touch ~/.ssh/config;
    # Writes in place (not via mv) so a symlinked ~/.ssh/config stays a symlink.
    # Only checks that the line exists, not that it's first: a hand edit that
    # moves it below a Host block makes it conditional.
    if ! grep -qxF "$ssh_include" ~/.ssh/config; then
        local ssh_config="$(<~/.ssh/config)";
        printf '%s\n\n%s\n' "$ssh_include" "$ssh_config" > ~/.ssh/config;
    fi;
    # ssh refuses a config or Include'd file that's group- or world-writable
    chmod 600 ~/.ssh/config ~/.ssh/config.d/dotfiles;
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
