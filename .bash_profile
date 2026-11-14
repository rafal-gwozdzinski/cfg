# ~/.bash_profile — login shells only (Ghostty, ssh, console login).
# Ghostty spawns a login shell, so all environment setup must live here.

# Homebrew: puts bash 5, git, direnv, etc. on PATH (macOS).
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Rust
[ -s "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Interactive settings (also inherited by nested shells)
case $- in *i*) [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc" ;; esac
