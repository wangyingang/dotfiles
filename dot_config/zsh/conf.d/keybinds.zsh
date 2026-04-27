# keybinds.zsh
# 目标：
# 1) 放个人自定义按键绑定
# 2) 不和全局 keymap / 插件 / hook 相互踩踏
# 3) 让普通 bindkey 与 ZLE hook 分层

# ------------------------------------------------------------------------------
# 0. 前置：加载 terminfo
# ------------------------------------------------------------------------------

zmodload zsh/terminfo 2>/dev/null || return 0

# ------------------------------------------------------------------------------
# 1. emacs / vi 风格切换
# ------------------------------------------------------------------------------

# ZLE 的 keymap 里区分了 emacs / viins / vicmd 三套映射
# bindkey -e / bindkey -v 两种风格二选一

# 使用 emacs 风格按键
#
# 命令行编辑常见行为更接近 Emacs/readline
# 例如 Ctrl-A 到行首、Ctrl-E 到行尾、Ctrl-B/Ctrl-F 左右移动。
bindkey -e

# 使用 Vi 风格按键
#
# 命令行编辑常见行为更接近 Vi
# 默认起点是 viins，也就是插入模式；
# 按 Esc 可切到 vicmd，再用 h j k l、w、b、0、$ 这类 Vi 命令式移动和编辑。
# bindkey -v


# ------------------------------------------------------------------------------
# 2. 自定义按键绑定
# ------------------------------------------------------------------------------

# 例如：
# bindkey '^A' beginning-of-line
# bindkey '^E' end-of-line
# bindkey '^[f' forward-word
# bindkey '^[b' backward-word

# 如何查看绑定键的转义码？
#
# 在 macOS 的 zsh 下，一般有两种方法。
# 1. 运行命令 `cat -v`，然后按键查看对应的转义序列。
# 2. 运行命令 `zsh`，然后按组合键 `Ctrl+V`，再然后按键查看对应的转义序列。
#
# 一般来说，更推荐第二种方法。这是因为对于一些特殊的组合键，
# 第一种方法有可能会因为你使用的 Terminal 应用程序和环境不同，出现的转义序列也不一样。
# 这种特殊组合键的情况下，第二种方法更准确一些。
# 比如 Control+Shift 再加一个字母，例如下面例子中的 Control+Shift+U。
#
# 不过在使用第二种方法的时候，也有一些小细节需要注意。
# 特殊键或者特殊的组合键位，你要多按几次。第一次有可能和后续出现的不太一样，
# 最好选后面这个重复按多次以后一样的序列找出来。这个应该都是准确的转义码（转义序列）。

# 在 Bash 中 CTRL+U 会删除从光标到行首的字符，("^U" backward-kill-line)
# 而在 Zsh 中 CTRL+U 则会删除整行，无论光标在哪 ("^U" kill-whole-line)
# 为了模拟 Bash 行为，可做如下绑定
bindkey -M emacs "^U" backward-kill-line

# 在我的机器 `bindkey -v`(emacs keymap) 模式下，经测定：
# `CTRL+SHIFT+U` 组合键输出的转义序列为 `7;6u`
# 所以可以将 `CTRL+SHIFT+U` 设置为删除整行：
bindkey -M emacs "7;6u" kill-whole-line

# ------------------------------------------------------------------------------
# 补全菜单 (menuselect keymap) 模式下的自定义键绑定
# ------------------------------------------------------------------------------
zmodload zsh/complist

# 标签导航：使用 Shift+Tab 键反向浏览项目
# kcbt = back-tab = 通常就是 Shift-Tab
if [[ -n "${terminfo[kcbt]}" ]]; then
  bindkey -M menuselect "${terminfo[kcbt]}" reverse-menu-complete # Shift-Tab moves backward.
fi
# 或者范围更大一些
# if [[ -n "${terminfo[kcbt]}" ]]; then
#   bindkey -M emacs "${terminfo[kcbt]}" reverse-menu-complete
#   bindkey -M viins "${terminfo[kcbt]}" reverse-menu-complete
#   bindkey -M vicmd "${terminfo[kcbt]}" reverse-menu-complete
# fi

# 在补全菜单（menuselect keymap）中，把 Ctrl-O 绑定到 accept-and-infer-next-history。
# 这是菜单选择态下的特殊键位绑定，不是普通命令行态的绑定。
#
# 如果在菜单中高亮显示了一个目录，然后按 ^o，
# 它将“接受”该目录并立即打开一个用于显示其内部文件和子目录的新完成菜单。
# 这允许您在不离开菜单选择的情况下深入文件树（例如，cd /u/l/b 变为 cd /usr/local/bin）
bindkey -M menuselect '^o' accept-and-infer-next-history

# Use Esc to exit the menu
bindkey -M menuselect '^[' send-break

# ------------------------------------------------------------------------------
# 4. 自定义 ZLE widget（如有）
# ------------------------------------------------------------------------------

# 例子：插入当前日期
# insert-current-date() {
#   LBUFFER+=$(date +%F)
# }
# zle -N insert-current-date

# 举例绑定：Ctrl-x d
# bindkey_all '^Xd' insert-current-date

# ------------------------------------------------------------------------------
# 5. 可选：ZLE hook
# ------------------------------------------------------------------------------
# export ZSH_KEYBINDS_USE_TERMINFO_HOOKS=0   # 关
# export ZSH_KEYBINDS_USE_TERMINFO_HOOKS=1   # 开
# 默认关闭。
#
# 只有当你确认某些终端下特殊键行为异常，并且启用 smkx/rmkx 后恢复正常，
# 再打开这个开关。
# ------------------------------------------------------------------------------

: "${ZSH_KEYBINDS_USE_TERMINFO_HOOKS:=0}"

if (( ZSH_KEYBINDS_USE_TERMINFO_HOOKS )); then

  # smkx/rmkx 属于“终端模式兼容层”
  # ZLE 开始时(smkx)，告诉终端切到某个键盘传输模式
  # ZLE 结束时(rmkx)，再切回来
  #
  # 下面代码用于确保特殊按键在命令行编辑时发送更一致、更可识别的序列，
  # 便于 shell 正确识别方向键、Home/End、功能键、某些终端的小键盘键
  # 增强 ZLE 与终端按键行为的兼容性
  # 确保 ZLE 编辑期间，终端处于合适的按键传输模式
  if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then

    # 用自定义函数名，避免直接把逻辑硬塞进 zle-line-init / finish
    _my_keybinds_line_init() {
      echoti smkx
    }

    _my_keybinds_line_finish() {
      echoti rmkx
    }

    # 如果你还没有别处定义 zle-line-init / zle-line-finish，
    # 就直接注册
    if (( ! ${+widgets[zle-line-init]} )); then
      zle -N zle-line-init _my_keybinds_line_init
    fi

    if (( ! ${+widgets[zle-line-finish]} )); then
      zle -N zle-line-finish _my_keybinds_line_finish
    fi
  fi

  # 增加更多
fi
