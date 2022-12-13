#!/bin/bash

DOTFILES_DIR="$HOME/.dotfiles"
BREW_PREFIX="/opt/homebrew"
REPO="https://github.com/kagu418/dotfiles.git"

if ! [[ -d "$(xcode-select -p)" ]]; then
  printf "You must install Command Line Tools before running this shell script.\n"
  read -rp "Do you want to install Command Line Tools now? [y/N] "
  if [[ "${REPLY}" == [yY]* ]]; then
    xcode-select --install
    printf "Installing Command Line Tools...\n"
    exit 1
  else
    printf "Use \`xcode-select --install\`.\n"
    exit 1
  fi
fi

if ( hash brew 2>/dev/null ); then
  printf "Skipping install Homebrew. It is already installed.\n"
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -d "$DOTFILES_DIR" ]]; then
  printf "dotfiles already exists on \`%s\`.\n" "$DOTFILES_DIR" >&2
  exit 1
fi

git clone --recursive "$REPO" "$DOTFILES_DIR"

if [[ -d "$DOTFILES_DIR" ]]; then
  printf "Succeeded to clone repository to \`%s\`.\n" "$DOTFILES_DIR"
else
  printf "Failed to clone repository.\n" >&2
  exit 1
fi

$BREW_PREFIX/bin/brew analytics off
$BREW_PREFIX/bin/brew bundle -v --file="$DOTFILES_DIR/macos/Brewfile"

if ! [[ -x "$BREW_PREFIX/bin/stow" ]]; then
  printf "Failed to install Stow.\n" >&2
  exit 1
fi

for dir in "$DOTFILES_DIR"/*; do
  [[ -d "$dir" ]] || continue
  $BREW_PREFIX/bin/stow -d "$DOTFILES_DIR" -t "$HOME" -R -v "${dir#"$DOTFILES_DIR"/}"
done
