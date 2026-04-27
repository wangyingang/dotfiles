# $ZDOTDIR/.zprofile
# Login-shell only. Keep this file silent.
# Environment required by every zsh belongs in .zshenv; interactive UX belongs in .zshrc.

# Disable Apple Terminal session restore noise/state files.
export SHELL_SESSIONS_DISABLE=1

# Safe one-time directory creation for human login shells.
# Avoid doing this from .zshenv because .zshenv runs for every zsh -c invocation.
mkdir -p -- \
  "$XDG_CONFIG_HOME" \
  "$XDG_CACHE_HOME" \
  "$XDG_DATA_HOME" \
  "$XDG_STATE_HOME" \
  2>/dev/null
