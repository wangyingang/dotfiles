#!/usr/bin/env bash
set -euo pipefail

DOTFILES_REMOTE="${DOTFILES_REMOTE:-https://github.com/wangyingang/dotfiles.git}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/Development/Working/dotfiles}"

log() {
  printf '[bootstrap] %s\n' "$*"
}

if ! xcode-select -p >/dev/null 2>&1; then
  log "Command Line Tools are missing. macOS will show an installer prompt."
  xcode-select --install || true
  log "Re-run this script after Command Line Tools finish installing."
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  log "Installing Homebrew."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

if ! command -v git >/dev/null 2>&1; then
  log "Installing git."
  brew install git
fi

if ! command -v chezmoi >/dev/null 2>&1; then
  log "Installing chezmoi."
  brew install chezmoi
fi

mkdir -p "$(dirname "$DOTFILES_DIR")"

if [[ ! -d "$DOTFILES_DIR/.git" ]]; then
  log "Cloning dotfiles into $DOTFILES_DIR."
  git clone "$DOTFILES_REMOTE" "$DOTFILES_DIR"
else
  log "Updating existing dotfiles checkout."
  git -C "$DOTFILES_DIR" pull --ff-only
fi

log "Applying chezmoi source from $DOTFILES_DIR."
chezmoi init --source "$DOTFILES_DIR"
chezmoi apply --source "$DOTFILES_DIR"

log "Done. Review MIGRATION.md for manual App Store, secrets, and paid app steps."

