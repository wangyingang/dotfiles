# zoxide.zsh

(( $+commands[zoxide] )) || return 0

# When set to 1, z will print the matched directory before navigating to it.
# export _ZO_ECHO=1

# Specifies the directory in which the database is stored.
# By default on macOS, this is set to `$HOME/Library/Application Support`
export _ZO_DATA_DIR="${_ZO_DATA_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/zoxide}"


# Excludes the specified directories from the database.
# By default, this is set to `$HOME`
#
# This is provided as a list of globs, separated by OS-specific characters:
# Separator of Windows: `;`
# Separator of Linux / macOS / BSD: `:`

# 需要在 zoxide 中排除(忽略)的 path
typeset -a common_excludes=(
  /tmp
  /var
  .git
  node_modules
  target
  dist
  build
)
typeset walker_skip=""

if (( ${#common_excludes} )); then
  export _ZO_EXCLUDE_DIRS="${(j|:|)common_excludes}"
  walker_skip="${(j|,|)common_excludes}"
fi

# Custom options to pass to fzf during interactive selection (zi mode).
export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS
  ${walker_skip:+--walker-skip $walker_skip}
  --preview 'command -v tree >/dev/null && tree -C -L 1 -- {2..} || (cd -- {2..} && command ls -la)'
  --select-1
  --exit-0
  "

# Configures the aging algorithm, which limits the maximum number of entries in the database.
# By default, this is set to 10000.
# export _ZO_MAXAGE=5000

# When set to 1, z will resolve symlinks before adding directories to the database.
# export _ZO_RESOLVE_SYMLINKS=1


eval "$(zoxide init zsh)"

unset common_excludes

# zoxide and fzf integration

# Search and open it with vscode
zcode() {
  local dir
  dir="$(zoxide query --interactive -- "$@")" || return 1
  code "$dir"
}
