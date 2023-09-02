setopt auto_list
setopt auto_menu
setopt hist_ignore_dups
setopt hist_ignore_space
setopt nobeep

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE
export HISTFILE="$HOME/.cache/zsh/history"

typeset -U path PATH
path=(
  /opt/homebrew/bin(N-/)
  /opt/homebrew/sbin(N-/)
  /usr/local/bin(N-/)
  $path
)

typeset -U fpath FPATH
fpath=(
  /opt/homebrew/share/zsh/site-functions(N-/)
  $fpath
)

export PATH="/opt/homebrew/opt/mysql@5.7/bin:$PATH"
export PATH="/opt/homebrew/opt/php@7.4/bin:$PATH"
export PATH="/opt/homebrew/opt/php@7.4/sbin:$PATH"
( hash go 2>/dev/null; ) && export PATH="$(go env GOPATH)/bin:$PATH"
export PATH="$HOME/.fnm:$PATH"
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
gcloud="/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk"
[[ -f "$gcloud/path.zsh.inc" ]] && . "$gcloud/path.zsh.inc"
[[ -f "$gcloud/completion.zsh.inc" ]] && . "$gcloud/completion.zsh.inc"
unset gcloud

( hash fnm 2>/dev/null; ) && eval "$(fnm env --use-on-cd)"
( hash sheldon 2>/dev/null; ) && eval "$(sheldon source)"
( hash starship 2>/dev/null; ) && eval "$(starship init zsh)"
( hash zoxide 2>/dev/null; ) && eval "$(zoxide init zsh)"

[[ -f "$ZDOTDIR/aliases" ]] && . "$ZDOTDIR/aliases"
[[ -f "$ZDOTDIR/functions" ]] && . "$ZDOTDIR/functions"
if [[ -d "$ZDOTDIR/local" ]]; then
  for file in "$ZDOTDIR/local"/*; do
    [[ -f "$file" ]] || continue
    . "$file"
  done
fi

autoload -Uz compinit && compinit
zstyle ":completion:*" menu select
zstyle ":completion:*" matcher-list "" "m:{a-zA-Z}={A-Za-z}"
_comp_options+=(globdots)
