# dotfiles

Personal macOS dotfiles/bootstrap repo. `home/` mirrors `$HOME` 1:1 — every file
under `home/` gets rsync'd on top of `~` by `01-bootstrap.sh`.

Numbered scripts run in order and each **mutates the machine** (installs
software, moves files into `$HOME`, sets `defaults write`): `01-bootstrap.sh`
→ `02-brew.sh [--work]` → `03-macos.sh` → `04-python.sh`. Never run any of
them in a session without being explicitly asked to.

Homebrew is split into `Brewfile.common` (always) plus `Brewfile.personal` or
`Brewfile.work` depending on the machine. Python is `uv`-only (no conda, no
Poetry) — see `04-python.sh`.

Edit files in `home/`, not in `~`, then re-run `01-bootstrap.sh` to apply.
