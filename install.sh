#!/bin/bash

DOTFILES_DIR="$HOME/dotfiles"
BREW_PREFIX="/opt/homebrew"
REPO="https://github.com/kagu418/dotfiles"

if [[ -d "$DOTFILES_DIR" ]]; then
  printf "dotfiles already exists on this system.\n"
  exit 1
fi

if ( hash git 2>/dev/null ); then
  git clone --recursive "$REPO.git" "$DOTFILES_DIR"
else
  printf "You must install Git before running this shell script.\n" >&2
  exit 1
fi

if [[ -d "$DOTFILES_DIR" ]]; then
  printf "Succeeded to download repository to %s\n" "$DOTFILES_DIR"
else
  printf "Failed to download repository or extract tar.\n"
  exit 1
fi

if ( hash brew 2>/dev/null ); then
  printf "Homebrew already installed.\n"
else
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

$BREW_PREFIX/bin/brew analytics off
$BREW_PREFIX/bin/brew bundle -v --file="$DOTFILES_DIR/brew/.config/brew/Brewfile"

for dir in "$DOTFILES_DIR"/*; do
  [[ -d "$dir" ]] || continue
  $BREW_PREFIX/bin/stow -d "$DOTFILES_DIR" -t "$HOME" -R -v "${dir#"$DOTFILES_DIR"/}"
done
