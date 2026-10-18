#!/usr/bin/env zsh

# Report whether each setup step (01–05) is complete. Read-only: changes
# nothing, so it's safe to run any time. Exits non-zero if anything failed.
# Usage: ./check.sh [--work]

case "${1:-}" in
  "") profile=personal ;;
  --work) profile=work ;;
  *) echo "Usage: $0 [--work]" >&2; exit 2 ;;
esac

cd "${0:A:h}"

fails=0
ok()   { print -P "%F{green}✓%f $1"; }
bad()  { print -P "%F{red}✗%f $1${2:+  →  $2}"; (( fails++ )); }
warn() { print -P "%F{yellow}!%f $1${2:+  →  $2}"; }
check() { local label="$1" hint="$2"; shift 2; if "$@" &>/dev/null; then ok "$label"; else bad "$label" "$hint"; fi; }

print "── Prerequisites"
check "Xcode command line tools" "xcode-select --install" xcode-select -p

print "── 01-bootstrap.sh"
# Differences are a warning, not a failure: they're either your un-applied
# edits in home/, or an app (e.g. an installer) edited a file in ~.
# Lines matching $ignore are ones apps rewrite on their own (Docker Desktop
# swaps $HOME for the literal path); those don't count.
ignore='\.docker/bin'
drift=()
for f in ${(f)"$(rsync -rcn --out-format='%n' --exclude .DS_Store home/ ~ | grep -v '/$')"}; do
  command diff -q -I "$ignore" "home/$f" ~/"$f" &>/dev/null || drift+=("$f")
done
if (( ${#drift} )); then
  warn "~ differs from home/: ${(j:, :)drift}" "diff home/<file> ~/<file>; keep an app's change by copying it into home/, then ./01-bootstrap.sh"
else
  ok "home/ matches ~"
fi
check "git identity in ~/.gitconfig.local" "./01-bootstrap.sh" \
  eval '[[ -n "$(git config --file ~/.gitconfig.local user.name)" && -n "$(git config --file ~/.gitconfig.local user.email)" ]]'
check "~/.exports.local exists" "./01-bootstrap.sh" test -f ~/.exports.local

print "── 02-brew.sh"
check "Homebrew installed" "./02-brew.sh" command -v brew
check "Brewfile.common installed" "brew bundle --file=Brewfile.common" brew bundle check --file=Brewfile.common
check "Brewfile.$profile installed" "brew bundle --file=Brewfile.$profile" brew bundle check --file="Brewfile.$profile"
check "login shell is Homebrew zsh" "chsh -s /opt/homebrew/bin/zsh" \
  eval '[[ "$(dscl . -read ~ UserShell)" == *"/opt/homebrew/bin/zsh" ]]'
check "Oh My Zsh + spaceship + plugins" "./02-brew.sh" \
  test -d ~/.oh-my-zsh/custom/themes/spaceship-prompt -a -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting -a -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
check "gh signed in" "gh auth login --git-protocol ssh --web" gh auth status
installed_exts="$(gh extension list 2>/dev/null | cut -f2)"
for ext in ${(f)"$(sed -e 's/[[:space:]]*#.*//' -e '/^$/d' gh-extensions)"}; do
  check "gh extension: $ext" "gh extension install $ext" grep -qxF "$ext" <<<"$installed_exts"
done
check "SSH to GitHub works" "gh auth login --git-protocol ssh --web" \
  eval 'ssh -T -o BatchMode=yes -o ConnectTimeout=5 -o StrictHostKeyChecking=accept-new git@github.com 2>&1 | grep -q "successfully authenticated"'
check "commits signed with SSH key" "./02-brew.sh" \
  eval '[[ "$(git config commit.gpgsign)" == true && "$(git config gpg.format)" == ssh ]]'
check "~/.ssh/config includes the dotfiles SSH settings" "./01-bootstrap.sh" \
  grep -qxF 'Include ~/.ssh/config.d/dotfiles' ~/.ssh/config
check "SSH key has a passphrase" "ssh-keygen -p -f ~/.ssh/id_ed25519" \
  eval '! ssh-keygen -y -P "" -f ~/.ssh/id_ed25519'
check "dotfiles remote uses ssh" "./02-brew.sh" \
  eval '[[ "$(git remote get-url origin)" == git@github.com:* ]]'

print "── 03-macos.sh (spot checks)"
check "key repeat set" "./03-macos.sh" eval '[[ "$(defaults read NSGlobalDomain KeyRepeat)" == 2 ]]'
check "Dock size set" "./03-macos.sh" eval '[[ "$(defaults read com.apple.dock tilesize)" == 36 ]]'
check "auto-update on" "./03-macos.sh" eval '[[ "$(defaults read /Library/Preferences/com.apple.commerce AutoUpdate)" == 1 ]]'
check "FileVault on" "System Settings → Privacy & Security → FileVault" eval 'fdesetup status | grep -q "On"'

print "── 04-python.sh"
check "uv installed" "./04-python.sh" command -v uv
check "Python 3.13 available to uv" "./04-python.sh" uv python find 3.13
check "python is uv's" "./04-python.sh" eval '[[ "$(command -v python)" == "$HOME/.local/bin/python" ]]'
for tool in ruff pre-commit ipython jupyterlab; do
  check "uv tool: $tool" "./04-python.sh" eval "uv tool list | grep -q '^$tool '"
done
check "scratch venv" "./04-python.sh" test -d ~/.venvs/scratch

print "── 05-agents.sh"
for tool in claude codex roborev; do
  check "$tool installed" "./05-agents.sh" command -v "$tool"
done
check "private config restored (dfp)" "./05-agents.sh" \
  git --git-dir="$HOME/.dotfiles-private" rev-parse -q --verify 'main@{upstream}'
check "gstack installed" "./05-agents.sh" grep -q '^claude' ~/.gstack/installs.tsv
check "Claude plugins match settings.json" "claude-sync-plugins" claude-sync-plugins --check

print
if (( fails )); then print -P "%F{red}$fails check(s) failed%f"; exit 1; else print -P "%F{green}All checks passed%f"; fi
