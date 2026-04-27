# macOS Reinstall Migration Plan

Target machine: Apple MacBook M2 Max.  
Goal: erase local disk, reinstall macOS, and restore only intentional tools and settings without Time Machine.

## 1. Before Erase

- Confirm external disk backup is readable for:
  - `~/Documents` or the existing `~/Documens` backup path.
  - `~/Development`.
- Push this repo to GitHub and confirm it is reachable:
  - `https://github.com/wangyingang/dotfiles`
- Export or record secrets outside this public repo:
  - `~/.ssh`
  - GitHub/gh auth, Hugging Face, npm, OpenAI/Claude/Codex credentials
  - app license keys for PopClip, Screen Studio, Downie 4, VMware Fusion, Microsoft Office, NTFS tools
  - VPN/proxy profiles, including Quantumult X and sing-box VT configuration
- Record Apple ID usage:
  - China account for main App Store apps.
  - US account for Actions and Quantumult X.
- Check app-specific exports:
  - Raycast: export settings/extensions if needed.
  - Bob: export translation/OCR settings if needed.
  - PopClip: export extensions/snippets if needed.
  - Screen Studio and Downie: record license and download account.
  - WeChat: back up chat history manually if needed.
  - Chrome/Bitwarden/Obsidian: confirm sync or vault backup.

## 2. First Boot After Reinstall

- Complete macOS setup with the same user short name: `wangyg`.
- Install Command Line Tools when prompted:

```bash
xcode-select --install
```

- Run bootstrap:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/wangyingang/dotfiles/main/bootstrap.sh)"
```

## 3. Automated Restore

The bootstrap flow restores:

- Homebrew and chezmoi.
- Core CLI tools: git, gh, mise, uv, fzf, zoxide, ripgrep, fd, bat, jq, starship, shellcheck, neovim, go, bun.
- Core GUI tools: Ghostty, Chrome, VS Code, Karabiner-Elements, Raycast, Rectangle, OrbStack, Obsidian, fonts.
- Core configs:
  - `~/.zshenv`
  - `~/.gitconfig`
  - `~/.config/zsh`
  - `~/.config/starship`
  - `~/.config/mise`
  - `~/.config/ghostty`
  - `~/.config/karabiner/karabiner.json`
  - `~/.config/btop/btop.conf`
  - `~/.config/uv/.python-version`
- Conservative macOS defaults:
  - Language order: `en-CN`, `zh-Hans-CN`
  - Locale: `en_CN`
  - First day of week: Monday
  - Appearance: Dark
  - Scroll bars: Always
  - Key repeat: `InitialKeyRepeat=25`, `KeyRepeat=2`
  - Dock: bottom, 64px, autohide, magnification enabled

## 4. Manual Restore

### App Store

Sign in to the right Apple ID first, then optionally run:

```bash
brew bundle --file ~/Development/Working/dotfiles/Brewfile.mas --no-upgrade
```

Apps listed there:

- HP Smart
- PDFgear
- Bob
- Bitwarden
- TestFlight
- Pages
- Numbers
- Keynote
- Xcode
- Actions
- Quantumult X

`sing-box VT` was detected as an App Store/TestFlight app but has Adam ID `0`, so restore it manually from TestFlight/App Store.

### Manual Apps

Install manually and restore licenses/settings as needed:

- rustup
- Claude Code
- Claude Desktop
- Codex app
- RustDesk
- Microsoft Office
- Quark
- VMware Fusion
- WeChat
- Z-Library
- PopClip
- Screen Studio
- Downie 4
- Paragon NTFS or replacement NTFS tool
- Clash Verge, Thunder, Reeder, draw.io, Bartender, and other apps you still want

### Secrets and Accounts

- Restore `~/.ssh` manually with correct permissions:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*
chmod 644 ~/.ssh/*.pub 2>/dev/null || true
```

- Re-login:
  - `gh auth login`
  - `huggingface-cli login` or `hf auth login`
  - `npm login` if needed
  - Bitwarden
  - Claude/Codex/OpenAI apps
  - Microsoft Office

### macOS Settings To Verify Manually

These are intentionally not forced by script:

- Trackpad gestures and three-finger drag.
- Keyboard shortcuts.
- Date & Time timezone and menu bar clock display.
- Language & Region detailed formats, including temperature and date format.
- iCloud Drive, Desktop & Documents sync, Photos, Messages, Notes, Mail.
- Login items and background items.
- Privacy permissions: Accessibility, Screen Recording, Full Disk Access, Input Monitoring.
- Printer setup for HP.

## 5. Acceptance Check

Run:

```bash
chezmoi doctor
brew bundle check --file ~/Development/Working/dotfiles/Brewfile --no-upgrade
git config --global --list --show-origin
zsh -lic 'echo $ZDOTDIR; command -v git gh mise uv starship fzf zoxide'
```

Then open these apps once and confirm permissions:

- Ghostty
- Karabiner-Elements
- Raycast
- Rectangle
- VS Code
- Obsidian
- OrbStack

