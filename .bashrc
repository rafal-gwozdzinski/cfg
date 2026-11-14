# ~/.bashrc — interactive shell config, sourced from ~/.bash_profile.
# Portable core, tracked in ~/.cfg (see ~/.config/cfg/README.md).
# Machine-specific settings belong in ~/.bashrc.local (untracked).

# System-wide defaults (PS1, checkwinsize, $TERM_PROGRAM hooks)
[ -f /etc/bashrc ] && . /etc/bashrc

# ---------------------------------------------------------------------------
# History
# ---------------------------------------------------------------------------
HISTFILE=$HOME/.bash_history
HISTSIZE=50000
HISTFILESIZE=50000
HISTCONTROL=ignoreboth:erasedups
shopt -s histappend cmdhist lithist checkwinsize

# ---------------------------------------------------------------------------
# PATH (deduplicated, first occurrence wins)
# ---------------------------------------------------------------------------
export GOPATH="$HOME/go"

dedupe_path() {
  local p seen=":" out=()
  local -a parts
  IFS=: read -ra parts <<< "$PATH"
  for p in "${parts[@]}"; do
    [[ -z $p || $seen == *":$p:"* ]] && continue
    seen+="$p:"
    out+=("$p")
  done
  local IFS=:
  PATH="${out[*]}"
}

PATH="$HOME/.local/bin:$HOME/bin:$HOME/.opencode/bin:$GOPATH/bin:$HOME/.dotnet/tools:/usr/local/go/bin:$PATH"
dedupe_path
export PATH

export DOTNET_CLI_UI_LANGUAGE=en

# ---------------------------------------------------------------------------
# Editor
# ---------------------------------------------------------------------------
# Use Neovim as the default editor: EDITOR for generic tools, VISUAL for
# full-screen editors, SUDO_EDITOR for `sudo -e` / `sudoedit`.
if command -v nvim >/dev/null 2>&1; then
  export EDITOR=nvim
  export VISUAL=nvim
  export SUDO_EDITOR=nvim
fi

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

command -v direnv >/dev/null 2>&1 && eval "$(direnv hook bash)"

# nvm/ghcup prepend to PATH again; keep it deduplicated
dedupe_path
export PATH

# ---------------------------------------------------------------------------
# flatten: move all files from subdirectories into the target directory
# ---------------------------------------------------------------------------
flatten() {
  local target_dir="${1:-.}" file name base ext counter dest_path

  if [[ ! -d $target_dir ]]; then
    printf 'Error: Target directory %q does not exist.\n' "$target_dir" >&2
    return 1
  fi

  # Resolve absolute path so destination paths are unambiguous
  target_dir=$(cd "$target_dir" && pwd) || return 1

  while IFS= read -r -d '' file; do
    name=${file##*/}
    dest_path=$target_dir/$name

    # Handle naming collisions without overwriting
    if [[ -e $dest_path ]]; then
      base=$name
      ext=
      if [[ $name == *.* && ${name##*.} != '' ]]; then
        ext=.${name##*.}
        base=${name%.*}
      fi

      counter=1
      dest_path=$target_dir/${base}_${counter}${ext}
      while [[ -e $dest_path ]]; do
        (( counter++ ))
        dest_path=$target_dir/${base}_${counter}${ext}
      done
    fi

    mv -n -- "$file" "$dest_path"
  done < <(find "$target_dir" -mindepth 2 -type f -print0)

  # Delete empty subdirectories
  find "$target_dir" -mindepth 1 -type d -empty -delete

  printf 'Flattening complete.\n'
}

# ---------------------------------------------------------------------------
# Prompt — palette colors only, so it stays readable in light and dark themes
# ---------------------------------------------------------------------------
PS1='\[\e[1;34m\]\u\[\e[0m\]@\[\e[1;36m\]\h\[\e[0m\] \[\e[32m\]\W\[\e[0m\] \[\e[33m\]\$\[\e[0m\] '

# ---------------------------------------------------------------------------
# Completion (bash-completion@2 also lazy-loads
# ~/.local/share/bash-completion/completions/<cmd> on first Tab)
# ---------------------------------------------------------------------------
[[ -r /opt/homebrew/etc/profile.d/bash_completion.sh ]] && . /opt/homebrew/etc/profile.d/bash_completion.sh

# ---------------------------------------------------------------------------
# Terminal
# ---------------------------------------------------------------------------
# Disable XON/XOFF software flow control so Ctrl-S no longer freezes the
# terminal and Ctrl-S / Ctrl-Q stay available to readline. This runs in every
# interactive shell, including each bash pane started by tmux.
if [[ $- == *i* ]] && [[ -t 0 ]]; then
  stty -ixon 2>/dev/null
fi

# ---------------------------------------------------------------------------
# Machine-specific overrides (never tracked)
# ---------------------------------------------------------------------------
[ -f "$HOME/.bashrc.local" ] && . "$HOME/.bashrc.local"
