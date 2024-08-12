eval "$(/opt/homebrew/bin/brew shellenv)"

if hash nvim 2>/dev/null; then
  export EDITOR="nvim"
  export MANPAGER='nvim +Man!'
else
  export EDITOR="vim"
fi
