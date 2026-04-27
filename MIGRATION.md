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
  - Codex App: see the external-disk restore note at `/Volumes/Movies-1T/mac-migration/codex/RESTORE-CODEX.md`.
  - SSH keys: see the external-disk restore note at `/Volumes/Movies-1T/mac-migration/ssh-backup/SSH-BACKUP-RESTORE.md`.

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
- Core CLI tools: git, gh, mas, antidote, bat, fd, fzf, jq, mise, ripgrep, starship, tree, uv, curl, wget, zoxide, unar, go, bun, ffmpeg, yt-dlp.
- Core GUI tools: Ghostty, Git Credential Manager, Chrome, VS Code, Karabiner-Elements, Raycast, Rectangle, OrbStack, Obsidian, IINA, LocalSend, Stats, WeChat, QLMarkdown, Telegram, Keka, fonts.
- Core configs:
  - `~/.zshenv`
  - `~/.gitconfig`
  - `~/.agents/AGENTS.md`
  - `~/.claude/CLAUDE.md`
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

Currently enabled App Store entries:

- HP Smart
- PDFgear
- Bob
- Bitwarden
- TestFlight

Entries kept as commented reminders in `Brewfile.mas`:

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
find ~/.ssh -type d -exec chmod 700 {} \;
find ~/.ssh -type f -name '*.pub' -exec chmod 644 {} \;
find ~/.ssh -type f ! -name '*.pub' -exec chmod 600 {} \;
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
zsh -lic 'echo $ZDOTDIR; command -v git gh mise uv starship fzf zoxide curl unar'
```

Then open these apps once and confirm permissions:

- Ghostty
- Karabiner-Elements
- Raycast
- Rectangle
- VS Code
- Obsidian
- OrbStack
