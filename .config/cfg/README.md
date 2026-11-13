# Dotfiles

Bare-repository pattern: [The best way to store your dotfiles](https://www.atlassian.com/git/tutorials/dotfiles).

`$HOME` is the working tree, the repository lives in `~/.cfg`, and the
`config` alias wraps git with the right `--git-dir` / `--work-tree`.

## Set up a new machine

```sh
mv ~/.bashrc ~/.bashrc.pre-cfg            # only if it already exists
git clone --bare git@github.com:rafal-gwozdzinski/cfg.git ~/.cfg

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no
config checkout
```

The alias is defined in `~/.zshrc` (tracked), so after checkout open a new
shell. For bash, `.bashrc` defines it too.

## Daily use

```sh
config status
config diff
config add .zshrc .config/nvim/init.lua   # explicit paths only
config commit -m "…"
config push
```

Never run `config add -A`: the work tree is your whole home directory
(`.ssh`, `.aws`, `.gnupg`, …). `config add -u` is safe (tracked files only).

## Machine-local files (never committed)

- `~/.zshrc.local` — sourced at the end of `.zshrc`
- `~/.bashrc.local` — sourced at the end of `.bashrc`
- `~/.zprofile`, `~/.zshenv` — host-level (brew, MacPorts, cargo)

A safety deny-list lives in `~/.cfg/info/exclude` (not tracked).

## Layout

| Path | Notes |
|---|---|
| `.zshrc` | portable zsh core; ends by sourcing `~/.zshrc.local` |
| `.bashrc` | portable bash equivalent (Linux) |
| `.gitconfig` | git identity + `excludesfile = ~/.gitignore` |
| `.gitignore` | global git excludes |
| `.config/nvim` | Neovim 0.12+ (`vim.pack`) |
| `.config/ghostty` | Ghostty; GTK-only lines are commented out for macOS |
