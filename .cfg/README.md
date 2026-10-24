# Dotfiles

Personal dotfiles, managed as a **bare Git repository** at `~/.cfg` with `$HOME` as the working tree.

**Source:** [The best way to store your dotfiles: A bare Git repository](https://www.atlassian.com/git/tutorials/dotfiles) — Nicola Paolucci, Atlassian Git Tutorials.

This README is tracked as `.cfg/README.md`, so it lives inside the repo and is restored by `config checkout` on a new machine.

## How it was set up

```sh
git init --bare "$HOME/.cfg"

# alias, also added to ~/.bashrc
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# don't list every file in $HOME as untracked
config config --local status.showUntrackedFiles no
```

## Daily use

```sh
config status
config add .bashrc
config commit -m "Update bashrc"
config push          # once a remote is added: config remote add origin <url>
```

Tracked so far: `.bashrc`, `.config/ghostty/config.ghostty`, `.config/ghostty/custom.css`, `.cfg/README.md`.

## Restore on a new machine

```sh
git clone --bare <repo-url> "$HOME/.cfg"
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config checkout      # fails if files already exist
```

Move any conflicting files out of the way and retry:

```sh
mkdir -p "$HOME/.config-backup"
config checkout 2>&1 | grep -E "\s+\." | awk '{print $1}' \
  | xargs -I{} mv {} "$HOME/.config-backup/{}"
config checkout
config config --local status.showUntrackedFiles no
```
