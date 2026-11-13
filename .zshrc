# ~/.zshrc — portable core, tracked in ~/.cfg (see ~/.config/cfg/README.md).
# Machine-specific settings belong in ~/.zshrc.local (untracked).

# ---------------------------------------------------------------------------
# History
# ---------------------------------------------------------------------------
HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY

# ---------------------------------------------------------------------------
# PATH (typeset -U keeps entries unique when re-sourcing)
# ---------------------------------------------------------------------------
export GOPATH="$HOME/go"
typeset -U path
path=(
  "$HOME/.local/bin"
  "$HOME/bin"
  "$HOME/.opencode/bin"
  "$GOPATH/bin"
  "$HOME/.dotnet/tools"
  $path
)
export PATH

export DOTNET_CLI_UI_LANGUAGE=en

# ---------------------------------------------------------------------------
# Dotfiles
# ---------------------------------------------------------------------------
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
command -v nvim >/dev/null 2>&1 && alias vi='nvim'

# ---------------------------------------------------------------------------
# Toolchains (guarded: no-ops when a tool isn't installed)
# ---------------------------------------------------------------------------
[ -s "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

# ---------------------------------------------------------------------------
# flatten: move all files from subdirectories into the target directory
# ---------------------------------------------------------------------------
flatten() {
  local target_dir="${1:-.}"

  if [[ ! -d "$target_dir" ]]; then
    print -u2 "Error: Target directory '$target_dir' does not exist."
    return 1
  fi

  # Resolve absolute path to ensure proper string manipulation
  target_dir="$(cd "$target_dir" && pwd)"

  local file name ext base counter dest_path

  # Process all files located in subdirectories (depth > 1)
  find "$target_dir" -mindepth 2 -type f | while read -r file; do
    name="${file:t}"
    dest_path="${target_dir}/${name}"

    # Handle naming collisions without overwriting
    if [[ -e "$dest_path" ]]; then
      ext="${name:e}"
      base="${name:r}"
      counter=1

      if [[ -n "$ext" ]]; then
        dest_path="${target_dir}/${base}_${counter}.${ext}"
        while [[ -e "$dest_path" ]]; do
          ((counter++))
          dest_path="${target_dir}/${base}_${counter}.${ext}"
        done
      else
        dest_path="${target_dir}/${name}_${counter}"
        while [[ -e "$dest_path" ]]; do
          ((counter++))
          dest_path="${target_dir}/${name}_${counter}"
        done
      fi
    fi

    mv -n "$file" "$dest_path"
  done

  # Delete empty subdirectories
  find "$target_dir" -mindepth 1 -type d -empty -delete

  print "Flattening complete."
}

# ---------------------------------------------------------------------------
# Prompt — palette colors only, so it stays readable in light and dark themes
# ---------------------------------------------------------------------------
PROMPT='%F{blue}%B%n%b%f@%F{cyan}%B%m%b%f %F{green}%1~%f %F{yellow}%#%f '
PROMPT2='%F{blue}%_%f '

# ---------------------------------------------------------------------------
# Machine-specific overrides (never tracked)
# ---------------------------------------------------------------------------
[ -f "$HOME/.zshrc.local" ] && . "$HOME/.zshrc.local"
true
