#!/bin/bash

DOTFILES_DIR="$HOME/.dotfiles"
BREW_PREFIX="/opt/homebrew"
REPOSITORY="https://github.com/kagu418/dotfiles.git"

if [[ -d "$DOTFILES_DIR" ]]; then
  printf "dotfiles already exists on \`%s\`.\n" "$DOTFILES_DIR" >&2
  exit 1
fi

if ! type xcode-select >/dev/null 2>&1; then
  printf "You must install Command Line Tools before running this shell script.\n"
  read -rp "Do you want to install Command Line Tools now? [y/N] "
  if [[ "${REPLY}" == [yY]* ]]; then
    printf "Installing Command Line Tools...\n"
    xcode-select --install
  else
    printf "To install manually, use: \`xcode-select --install\`.\n"
  fi
  printf "After installation is complete, run this again.\n"
  exit 0
fi

if (type brew >/dev/null 2>&1); then
  printf "Skipping install Homebrew. It is already installed.\n"
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

git clone --recursive "$REPOSITORY" "$DOTFILES_DIR"

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

curl --create-dirs --output-dir "$HOME/.config/alacritty/themes" \
  -O -fsSL https://raw.githubusercontent.com/rose-pine/alacritty/HEAD/dist/rose-pine.toml \
  -O -fsSL https://raw.githubusercontent.com/rose-pine/alacritty/HEAD/dist/rose-pine-moon.toml \
  -O -fsSL https://raw.githubusercontent.com/rose-pine/alacritty/HEAD/dist/rose-pine-dawn.toml

/bin/bash "$DOTFILES_DIR/macos/defaults"
