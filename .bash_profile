# ~/.bash_profile — login shells only (Ghostty, ssh, console login).
# Ghostty spawns a login shell, so all environment setup must live here.

# English in the terminal only: macOS keeps the Polish region for GUI formats.
# bash reads its message catalogs at startup, before this file, so export the
# locale and re-exec the interactive login shell once to pick it up.
if [[ ${LANG-} != en_US.UTF-8 ]]; then
  export LANG=en_US.UTF-8
  if [[ $- == *i* ]]; then
    exec "$BASH" -l
  fi
fi

# Homebrew: puts bash 5, git, direnv, etc. on PATH.
eval "$(/opt/homebrew/bin/brew shellenv)"

# Rust
[ -s "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Interactive settings (also inherited by nested shells)
case $- in *i*) [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc" ;; esac
