#!/bin/bash

DOTFILES_DIR="$HOME/dotfiles"
BREW_PREFIX="/opt/homebrew"
REPO="https://github.com/kagu418/dotfiles"

if [[ -d "$DOTFILES_DIR" ]]; then
  printf "dotfiles already exists on this system.\n" >&2
  exit 1
fi

if ( hash git 2>/dev/null ); then
  git clone --recursive "$REPO.git" "$DOTFILES_DIR"
else
  printf "You must install Git before running this shell script.\n" >&2
  exit 1
fi

if [[ -d "$DOTFILES_DIR" ]]; then
  printf "Succeeded to clone repository to %s\n" "$DOTFILES_DIR"
else
  printf "Failed to clone repository.\n" >&2
  exit 1
fi

if ( hash brew 2>/dev/null ); then
  printf "Homebrew already installed.\n"
else
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if ! [[ -x "$BREW_PREFIX/bin/brew" ]]; then
  printf "Failed to install Homebrew.\n" >&2
  exit 1
fi

$BREW_PREFIX/bin/brew analytics off
$BREW_PREFIX/bin/brew bundle -v --file="$DOTFILES_DIR/brew/.config/brew/Brewfile"

if ! [[ -x "$BREW_PREFIX/bin/stow" ]]; then
  printf "Failed to install Stow.\n" >&2
  exit 1
fi

for dir in "$DOTFILES_DIR"/*; do
  [[ -d "$dir" ]] || continue
  $BREW_PREFIX/bin/stow -d "$DOTFILES_DIR" -t "$HOME" -R -v "${dir#"$DOTFILES_DIR"/}"
done
