# antidote.zsh
# 只负责加载 antidote 和插件清单。

# 设置 antidote home 环境变量
export ANTIDOTE_HOME="$XDG_CACHE_HOME/antidote"

# 通过 Git 安装的路径 (可自定义)
# ANTIDOTE_REPO=~/Development/github.com/antidote
# 通过 Homebrew 安装的路径
ANTIDOTE_REPO=${HOMEBREW_PREFIX:-/opt/homebrew}/opt/antidote/share/antidote

# 设置 antidote home
zstyle ':antidote:home' path $ANTIDOTE_HOME
# 设置 antidote 安装目录
zstyle ':antidote:repo' path $ANTIDOTE_REPO
# 设置 antidote snapshot 目录
zstyle ':antidote:snapshot' dir "$XDG_STATE_HOME/antidote/snapshots"

# zstyle ':antidote:bundle' use-friendly-names 'yes'
# zstyle ':antidote:bundle' path-style escaped
# zstyle ':antidote:bundle' path-style full
# zstyle ':antidote:plugin:*' defer-options '-p'
# zstyle ':antidote:*' zcompile 'yes'

# 如果安装目录不存在(说明未安装), 通过 git 安装
if [[ ! -d $ANTIDOTE_REPO ]]; then
  git clone https://github.com/mattmc3/antidote $ANTIDOTE_REPO
fi

function antidote_reset() {
  rm ${ZSH_CACHE_DIR:-$HOME}/.zsh_plugins.zsh
  rm -rf -- "${ANTIDOTE_HOME:-?}"
}

# 加载插件清单，后续可优化为静态加载
zsh_plugins=${ZDOTDIR:-$HOME}/.zsh_plugins

# 确保 .zsh_plugins.txt 文件存在，以便可以添加插件。
[[ -f ${zsh_plugins}.txt ]] || touch ${zsh_plugins}.txt

source "$ANTIDOTE_REPO/antidote.zsh"

antidote load ${zsh_plugins}.txt "$ZSH_CACHE_DIR/.zsh_plugins.zsh"
