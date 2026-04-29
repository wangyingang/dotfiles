# $ZDOTDIR/.zshrc
# Interactive shell entrypoint.

# Defensive: zsh normally reads .zshrc only for interactive shells.
[[ -o interactive ]] || return 0

# Agent / AI shells must stay quiet and deterministic.
# AI_SHELL is set by the local ai-env wrapper.
# CLAUDECODE is set by Claude Code for its shell/tool environment.
if [[ -n "${AI_SHELL:-}" || -n "${CLAUDECODE:-}" ]]; then
  return 0
fi

# Non-TTY interactive shells such as `zsh -ic ...` used by automation should not
# load prompt, ZLE, completions, plugins, or hooks. Environment is already handled
# by .zshenv.
if [[ ! -t 0 || ! -t 1 || ! -t 2 ]]; then
  return 0
fi

# Profiling. Run `zprofrc` to start a profiled interactive shell.
if [[ "${ZPROFRC:-0}" == 1 ]]; then
  zmodload zsh/zprof 2>/dev/null || true
fi
alias zprofrc='ZPROFRC=1 zsh'

# Powerlevel10k instant prompt. Keep this near the top of the real human/TTY path.
if [[ -r "$ZSH_CACHE_DIR/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "$ZSH_CACHE_DIR/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Expand globbing syntax
setopt extended_glob

# 交互 shell 中允许使用注释
setopt interactive_comments

# Ensure runtime directories exist for human interactive shells.
mkdir -p -- "$ZSH_CACHE_DIR" "$ZSH_STATE_DIR" 2>/dev/null

# fpath for functions and completions. Do this in .zshrc, not .zprofile, because
# it is only relevant to the interactive zsh stack.
typeset -gU fpath
fpath=(
  $ZDOTDIR/functions(-/FN)
  $ZDOTDIR/completions(-/FN)
  $ZDOTDIR/completions/*(-/FN)   # 将 completions 下的一级子目录也加入 fpath, 方便以划分模块
  $fpath
)

# zstyle configuration must be loaded before plugin/completion setup.
[[ -r "$ZDOTDIR/.zstyles" ]] && source "$ZDOTDIR/.zstyles"

# Never start in the root file system.
[[ "$PWD" != "/" ]] || cd

# Plugin manager / interactive stack. Required for the rest of the interactive config.
source $ZDOTDIR/lib/antidote.zsh

# Local human-interactive settings.
[ -r $ZDOTDIR/.zshrc.local ] && . $ZDOTDIR/.zshrc.local

# Finish profiling.
if [[ "${ZPROFRC:-0}" == 1 ]] && (( $+functions[zprof] )); then
  zprof
fi
unset ZPROFRC 2>/dev/null || true

true
