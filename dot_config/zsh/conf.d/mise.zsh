# mise.zsh

(( $+commands[mise] )) || return 0

export MISE_NODE_DEFAULT_PACKAGES_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/mise/default-npm-packages"

eval "$(mise activate zsh)"
