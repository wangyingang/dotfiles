# fzf.zsh

(( $+commands[fzf] )) || return 0

# 需要在 fzf 中排除(忽略)的 path
typeset -a common_excludes=(
  .git
  node_modules
  target
  dist
  build
)
typeset fd_excludes=""
typeset walker_skip=""

if (( ${#common_excludes} )); then
  fd_excludes="${(j: :)${(@)common_excludes/#/-E }}"
  walker_skip="${(j:,:)common_excludes}"
fi

# 让 fzf 的 shell 集成用 fd 做候选源
if (( $+commands[fd] )); then
  # 1. Use fd for fzf file completion (Ctrl+T)
  : "${FZF_CTRL_T_COMMAND:=fd -t f --strip-cwd-prefix -H -L${fd_excludes:+ $fd_excludes}}"

  # 2. Use fd for cd-ing into directories (Alt+C)
  : "${FZF_ALT_C_COMMAND:=fd -t d --strip-cwd-prefix -H -L${fd_excludes:+ $fd_excludes}}"
fi

# 只放通用 UI 选项

# Open in tmux popup if on tmux, otherwise use --height mode
# : "${FZF_DEFAULT_OPTS:=--height 40% --tmux bottom,40% --layout reverse --border top}"

export FZF_DEFAULT_OPTS="
  ${walker_skip:+--walker-skip $walker_skip}
  --height 40% --tmux bottom,40% --layout reverse --border top"

# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  ${walker_skip:+--walker-skip $walker_skip}
  --preview 'command -v bat >/dev/null && bat --color=always --style=numbers --line-range=:500 --paging=never -- {} || head -n 500 < {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# Print tree structure in the preview window
export FZF_ALT_C_OPTS="
  ${walker_skip:+--walker-skip $walker_skip}
  --preview 'command -v tree >/dev/null && tree -C -L 2 -- {} || (cd -- {} && command ls -la)'"

# Setting up shell integration
source <(fzf --zsh)

unset common_excludes fd_excludes walker_skip
