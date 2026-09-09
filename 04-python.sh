#!/usr/bin/env zsh
set -euo pipefail

# Python setup via uv.
# Model: `uv tool install` for global CLIs, `~/.venvs/<name>` for ad-hoc
# exploration (activate with the `workon` function, see .functions), and
# `uv run` inside individual projects for project-scoped dependencies.

# uv installs and upgrades itself (`uv self update`); it's deliberately NOT
# in a Brewfile so `brew upgrade` never fights the self-updater.
command -v uv >/dev/null || curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"

# Install a default interpreter uv can hand out to tools and venvs
uv python install 3.13

# Global CLI tools, each in its own isolated environment. Shims land in
# ~/.local/bin, which home/.exports puts on PATH.
for tool in ruff pre-commit ipython jupyterlab; do
  uv tool install "$tool"
done

# One shared scratch venv for ad-hoc exploration
if [ ! -d "$HOME/.venvs/scratch" ]; then
  uv venv "$HOME/.venvs/scratch" --python 3.13
fi
