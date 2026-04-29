
(( $+commands[orb] )) || return 0

path=(
  $path
  $HOME/.orbstack/bin(N)
)

# 添加 orb, orbctl, docker, kubectl 的 completion
# 遗留问题：添加了 fpath, 但是补全并未正常显示
fpath=(
  $fpath
  /Applications/OrbStack.app/Contents/MacOS/../Resources/completions/zsh(N)
)
