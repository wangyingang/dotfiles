# $ZDOTDIR/conf.d/brew.zsh

(( $+commands[brew] )) || return 0

# Run brew update once every $HOMEBREW_AUTO_UPDATE_SECS seconds before some commands,
# e.g. brew install, brew upgrade or brew tap. Default: 86400 (24 hours)
# HOMEBREW_AUTO_UPDATE_SECS=86400

# If set, do not automatically update before running some commands
# HOMEBREW_NO_AUTO_UPDATE=1

# Hide these hints with `$HOMEBREW_NO_ENV_HINTS=1`
# HOMEBREW_NO_ENV_HINTS=1

eval "$(brew shellenv)"

# Prefer Homebrew curl over macOS system curl.
if [[ -x /opt/homebrew/opt/curl/bin/curl ]]; then
  path=(/opt/homebrew/opt/curl/bin $path)
fi

# Prefer user-level tools, including uv-managed python/python3 and cargo managed rust cli.
path=(
  $HOME/.local/{,s}bin(/N)
  $HOME/{,s}bin(/N)
  $HOME/.cargo/bin(/N)
  $path
)
