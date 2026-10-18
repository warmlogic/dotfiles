#!/usr/bin/env zsh
set -euo pipefail

# Coding agents: Claude Code, Codex and roborev, their private config (dfp),
# gstack, and every Claude plugin settings.json declares. Safe to re-run:
# each step skips what's already in place.
# Needs 01 (the sync scripts in ~/.local/bin), 02 (bun, and an SSH key GitHub
# knows, for the private repo) and 04 (python3 for codex-sync-rules).

cd "${0:A:h}"
# On PATH before the installers run, so none of them edits ~/.zprofile
export PATH="$HOME/.local/bin:$PATH"

# Each tool installs and updates itself, so none is in a Brewfile (the
# `claude` cask is the desktop app, not Claude Code).
command -v claude >/dev/null || curl -fsSL https://claude.ai/install.sh | bash
command -v codex >/dev/null || curl -fsSL https://chatgpt.com/codex/install.sh | sh
command -v roborev >/dev/null || curl -fsSL https://roborev.io/install.sh | bash

# Private config: ~/.claude, ~/.codex and ~/.roborev files tracked in
# warmlogic/dotfiles-private, a bare repo whose work tree is $HOME (see the
# README's "Claude Code and Codex config"). Runs until main tracks origin,
# the last step, so a re-run finishes a restore that failed partway. Every
# tracked file already in $HOME is copied to ~/.dotfiles-private-backup-<time>
# first, then replaced.
dfp=(git --git-dir="$HOME/.dotfiles-private" --work-tree="$HOME")
[[ -d ~/.dotfiles-private ]] || git clone --bare git@github.com:warmlogic/dotfiles-private.git ~/.dotfiles-private
if ! $dfp rev-parse -q --verify 'main@{upstream}' >/dev/null; then
  backup=~/.dotfiles-private-backup-$(date +%Y%m%d-%H%M%S)
  # Assigned first: errexit catches a failed assignment, not a failed for list
  tracked=$($dfp ls-tree -r -z --name-only HEAD)
  for f in ${(0)tracked}; do
    if [[ -e ~/$f || -L ~/$f ]]; then
      mkdir -p "$backup/${f:h}"
      cp -pP ~/"$f" "$backup/$f"
    fi
  done
  [[ -d "$backup" ]] && print "Backed up the files dfp replaces to $backup"
  $dfp checkout -f
  $dfp config core.excludesFile ~/.config/dotfiles-private/allowlist
  $dfp config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
  $dfp fetch
  $dfp branch -u origin/main main
fi

# gstack (https://github.com/garrytan/gstack): setup runs until gstack's
# install registry lists the global Claude install, so a re-run finishes a
# failed one, and not after, since re-running setup rewrites settings.json.
# gstack updates itself with /gstack-upgrade. The flag keeps setup from asking
# about its plan-tune hooks, which only enforce answers saved with
# /plan-tune; `./setup --plan-tune-hooks` turns them on.
[[ -d ~/.claude/skills/gstack ]] || git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/.claude/skills/gstack
grep -qs $'^claude\tglobal' ~/.gstack/installs.tsv || ~/.claude/skills/gstack/setup --no-plan-tune-hooks

# roborev's skills and agent hooks (both idempotent). Codex only: Claude's
# roborev hooks are already in the dfp-tracked settings.json, and installing
# them again re-sorts that whole file.
roborev skills install
roborev agent-hook install --agent codex

# Codex rules mirrored from Claude's permissions, then the marketplaces and
# plugins settings.json declares. Re-run both after a `dfp pull`.
codex-sync-rules
claude-sync-plugins

cat <<'EOF'

Done. Still by hand, once per machine:
  claude                     log in (first launch)
  codex login
  claude-setup-github-mcp    GitHub MCP over OAuth (README: "GitHub MCP for Claude Code")
After each dfp pull:   codex-sync-rules; claude-sync-plugins
EOF
