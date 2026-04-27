# directories.zsh
# Safe local port of oh-my-zsh lib/directories.zsh.

# 允许直接输入目录名自动 cd
setopt auto_cd

# 启用后，每次执行 cd 时，zsh 不只是“切换目录”，还会把目录加入 directory stack（目录栈）
setopt auto_pushd

# 目录栈中如果已经有某个目录，再次进入时，尽量避免重复保留同样的项
setopt pushd_ignore_dups

# 这个选项会调整目录栈编号引用时 +n 和 -n 的语义，使 cd -1、cd -2 这类写法更顺手。
setopt pushdminus

# 这里的 -g 是 global alias（全局别名），和普通 alias 不同：
#   - 普通 alias 一般只在命令位置展开
#   - 全局 alias 可以在命令行的任意位置展开
#
# 例如:
#     cd ...    # 会展开为 cd ../..
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias -- -='cd -'
alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

alias md='mkdir -p'
alias rd='rmdir'

d() {
  if [[ -n $1 ]]; then
    dirs "$@"
  else
    dirs -v | head -n 10
  fi
}
(( ${+functions[compdef]} )) && compdef _dirs d
