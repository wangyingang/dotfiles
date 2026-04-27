# dotfiles

Personal macOS dotfiles managed by chezmoi.

## Fresh macOS bootstrap

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/wangyingang/dotfiles/main/bootstrap.sh)"
```

The bootstrap script clones this repo to:

```text
~/Development/Working/dotfiles
```

Then it runs:

```bash
chezmoi init --source ~/Development/Working/dotfiles
chezmoi apply --source ~/Development/Working/dotfiles
```

## What this repo restores

- Core dotfiles: zsh, Git, Starship, Mise, Ghostty, Karabiner, btop, uv.
- Agent instructions: `~/.agents/AGENTS.md`, `~/.claude/CLAUDE.md`.
- Core Homebrew formulae/casks via `Brewfile`, including CLI basics, fonts, Ghostty, Git Credential Manager, Chrome, VS Code, Karabiner-Elements, Raycast, Rectangle, OrbStack, Obsidian, and selected favorite casks.
- Conservative macOS defaults via chezmoi run scripts.
- Optional App Store app list in `Brewfile.mas`; run it manually after signing in to the correct Apple ID.

## What this repo intentionally does not store

- `~/.ssh`, API keys, access tokens, app login sessions, browser profiles.
- Claude/Codex/GitHub/Bitwarden/Apple account secrets.
- Paid app license files.
- Runtime caches, shell history, logs, old backups.

See `MIGRATION.md` for the full reinstall checklist.
