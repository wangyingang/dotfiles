# $ZDOTDIR/.zshenv
# Read by every zsh invocation. Must remain silent, cheap, and side-effect free.
# Do not source .zprofile/.zshrc here. Do not run brew/mise/nvm/compinit/plugins here.

# XDG base directories
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# zsh config/cache/state locations
export ZDOTDIR="${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}"
export ZSH_CACHE_DIR="${ZSH_CACHE_DIR:-$XDG_CACHE_HOME/zsh}"
export ZSH_STATE_DIR="${ZSH_STATE_DIR:-$XDG_STATE_HOME/zsh}"

# Locale. Do not override a deliberately supplied locale.
export LANG="${LANG:-en_US.UTF-8}"
export LC_CTYPE="${LC_CTYPE:-en_US.UTF-8}"

# General editor/pager defaults. AI wrappers may override PAGER/GIT_PAGER with cat.
export EDITOR="${EDITOR:-vim}"
export VISUAL="${VISUAL:-$EDITOR}"
export PAGER="${PAGER:-less}"
export BROWSER="${BROWSER:-open}"

# Minimal, deterministic PATH for all zsh invocations, including non-interactive shells.
# Non-existent directories are harmless; keeping this static avoids startup I/O.
typeset -gU path PATH
path=(
  $HOME/.local/{,s}bin(/N)
  $HOME/{,s}bin(/N)
  $HOME/.cargo/bin(/N)
  $XDG_DATA_HOME/mise/shims(/N)
  /opt/{homebrew,local}/{,s}bin(/N)
  /usr/local/{,s}bin(/N)
  /usr/{,s}bin(/N)
  /{,s}bin(/N)
  $path
)

export PATH


# 注意：以下不是 .zshenv 中的内容，而是在初次初始化时需要执行的代码
# 以便用新的配置方法接手

# 1. 备份以前的 zfiles

# setopt extended_glob
# zfiles=(
#   ${ZDOTDIR:-~}/.zsh*(.N)
#   ${ZDOTDIR:-~}/.zlog*(.N)
#   ${ZDOTDIR:-~}/.zprofile(.N)
# )
# mkdir -p ~/.zsh-bak
# for zfile in $zfiles; do
#   cp $zfile ~/.zsh-bak
# done
# unset zfile zfiles


# 2. 将 ~/.zshenv 文件更改为使用 ZDOTDIR

# cat << 'EOF' >| ~/.zshenv
# # ~/.zshenv
# # Keep this file minimal. It only hands control to the XDG/ZDOTDIR zsh config.

# export ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"
# [[ -r "$ZDOTDIR/.zshenv" ]] && source "$ZDOTDIR/.zshenv"
# EOF
