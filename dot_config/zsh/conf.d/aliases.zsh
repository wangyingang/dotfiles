# aliases.zsh
# 只放 alias。
# 函数和 alias 不要混放，方便以后区分“简单替换”和“带逻辑命令”。
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'

# 如果你长期使用 rg，可以保留这些便捷别名
# alias rgf='rg --files'
# alias rgn='rg -n'

# 安全一点的 rm / cp / mv 风格可以按喜好决定是否启用
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'

alias pn='pnpm'

# sing-box 启用系统代理模式后配合使用
# alias proxy='export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890'
# alias unproxy='unset all_proxy http_proxy https_proxy'
