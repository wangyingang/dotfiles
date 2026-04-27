# macos.zsh
# Local port of the oh-my-zsh macos plugin

alias showfiles='defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'

ofd() {
  if (( $# == 0 )); then
    open "$PWD"
  else
    open "$@"
  fi
}

pfd() {
  osascript 2>/dev/null <<'EOF'
    tell application "Finder"
      return POSIX path of (insertion location as alias)
    end tell
EOF
}

pfs() {
  osascript 2>/dev/null <<'EOF'
    set output to ""
    tell application "Finder" to set the_selection to selection
    set item_count to count the_selection
    repeat with item_index from 1 to count the_selection
      if item_index is less than item_count then set the_delimiter to "\n"
      if item_index is item_count then set the_delimiter to ""
      set output to output & ((item item_index of the_selection as alias)'s POSIX path) & the_delimiter
    end repeat
EOF
}

cdf() {
  local finder_dir
  finder_dir="$(pfd)"
  [[ -n "$finder_dir" ]] || return 1
  cd "$finder_dir" || return 1
}

pushdf() {
  local finder_dir
  finder_dir="$(pfd)"
  [[ -n "$finder_dir" ]] || return 1
  pushd "$finder_dir" || return 1
}

pxd() {
  local workspace
  workspace="$(
    osascript 2>/dev/null <<'EOF'
      if application "Xcode" is running then
        tell application "Xcode"
          return path of active workspace document
        end tell
      end if
EOF
  )"
  [[ -n "$workspace" ]] || return 1
  dirname "$workspace"
}

cdx() {
  local xcode_dir
  xcode_dir="$(pxd)"
  [[ -n "$xcode_dir" ]] || return 1
  cd "$xcode_dir" || return 1
}

quick-look() {
  (( $# > 0 )) && qlmanage -p "$@" &>/dev/null &
}

man-preview() {
  [[ $# -eq 0 ]] && { >&2 echo "Usage: $0 command1 [command2 ...]"; return 1; }

  local page
  for page in "${(@f)"$(command man -w "$@")"}"; do
    command mandoc -Tpdf "$page" | open -f -a Preview
  done
}
(( ${+functions[compdef]} )) && compdef _man man-preview

rmdsstore() {
  find "${@:-.}" -type f -name .DS_Store -delete
}
