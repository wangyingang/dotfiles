# $ZDOTDIR/conf.d/ai-env.zsh
#
# AI agent launch helpers.
#
# Purpose:
# - Start Codex CLI / Claude Code CLI with a clean, explicit parent environment.
# - Start Codex App / Claude Desktop from the same parent environment.
# - Avoid duplicating env vars in .zshrc, ~/.codex/config.toml, ~/.claude/settings.json.
#
# This file is intended to be sourced from Zephyr confd in an interactive zsh.
# This file is sourced only after .zshrc has passed interactive / agent / TTY guards.

function ai-env() {
  emulate -L zsh

  local user_name log_name lang lc_ctype
  local -a env_args

  user_name="${USER:-$(id -un 2>/dev/null)}"
  log_name="${LOGNAME:-$user_name}"
  lang="${LANG:-en_US.UTF-8}"
  lc_ctype="${LC_CTYPE:-$lang}"

  env_args=(
    HOME="$HOME"
    USER="$user_name"
    LOGNAME="$log_name"
    SHELL="${SHELL:-/bin/zsh}"
    TMPDIR="${TMPDIR:-/tmp}"
    TERM="${TERM:-xterm-256color}"
    LANG="$lang"
    LC_CTYPE="$lc_ctype"

    # Inherit current parent shell PATH.
    # This keeps CLI and Desktop launch behavior consistent without hard-coding PATH twice.
    PATH="$PATH"

    AI_SHELL=1
    NO_COLOR=1
    CLICOLOR=0
    FORCE_COLOR=0
    PAGER=cat
    GIT_PAGER=cat
    HOMEBREW_NO_AUTO_UPDATE=1
    npm_config_update_notifier=false
  )

  # Preserve SSH agent access only when present.
  # This lets Codex/Claude use git over SSH without keeping a broad environment.
  if [[ -n "${SSH_AUTH_SOCK:-}" ]]; then
    env_args+=(SSH_AUTH_SOCK="$SSH_AUTH_SOCK")
  fi

  # Preserve XDG base dirs when already defined.
  # These are inherited values, not separately maintained constants.
  [[ -n "${XDG_CONFIG_HOME:-}" ]] && env_args+=(XDG_CONFIG_HOME="$XDG_CONFIG_HOME")
  [[ -n "${XDG_CACHE_HOME:-}" ]] && env_args+=(XDG_CACHE_HOME="$XDG_CACHE_HOME")
  [[ -n "${XDG_DATA_HOME:-}" ]] && env_args+=(XDG_DATA_HOME="$XDG_DATA_HOME")
  [[ -n "${XDG_STATE_HOME:-}" ]] && env_args+=(XDG_STATE_HOME="$XDG_STATE_HOME")

  env -i "${env_args[@]}" "$@"
}

function _ai-launch-macos-app() {
  emulate -L zsh

  local label app exe bin
  label="$1"
  shift

  for app in "$@"; do
    [[ -d "$app" ]] || continue

    exe=$(
      /usr/libexec/PlistBuddy -c 'Print :CFBundleExecutable' \
        "$app/Contents/Info.plist" 2>/dev/null
    ) || continue

    bin="$app/Contents/MacOS/$exe"

    if [[ -x "$bin" ]]; then
      # 平时默认丢弃输出，需要调试时启用日志
      # AI_APP_LOG=1 codex-app
      # AI_APP_LOG=1 claude-desktop
      if [[ "${AI_APP_LOG:-0}" == 1 ]]; then
        local log_dir log_name log_file

        log_dir="${XDG_STATE_HOME:-$HOME/.local/state}/ai-env/logs"
        mkdir -p -- "$log_dir" 2>/dev/null

        log_name="${label:l}"
        log_name="${log_name// /-}"
        log_file="$log_dir/${log_name}.log"

        {
          print -r -- ""
          print -r -- "===== $(date '+%Y-%m-%d %H:%M:%S') launching $label ====="
          print -r -- "app=$app"
          print -r -- "bin=$bin"
        } >> "$log_file" 2>/dev/null

        ai-env "$bin" </dev/null >> "$log_file" 2>&1 &!
      else
        ai-env "$bin" </dev/null >/dev/null 2>&1 &!
      fi

      return 0
    fi
  done

  print -u2 "$label app not found or not executable."
  return 1
}

function codex-app() {
  _ai-launch-macos-app \
    "Codex" \
    "/Applications/Codex.app"
}

function claude-desktop() {
  _ai-launch-macos-app \
    "Claude Desktop" \
    "/Applications/Claude.app"
}

alias codex='ai-env codex'
alias claude='ai-env claude'

