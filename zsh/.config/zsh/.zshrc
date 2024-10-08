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

(type go >/dev/null 2>&1) && export PATH="$(go env GOPATH)/bin:$PATH"
(type fnm >/dev/null 2>&1) && export PATH="$HOME/.fnm:$PATH" && eval "$(fnm env --use-on-cd)"
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
gcloud="/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk"
[[ -f "$gcloud/path.zsh.inc" ]] && . "$gcloud/path.zsh.inc"
[[ -f "$gcloud/completion.zsh.inc" ]] && . "$gcloud/completion.zsh.inc"
unset gcloud

(type sheldon >/dev/null 2>&1) && eval "$(sheldon source)"
(type starship >/dev/null 2>&1) && eval "$(starship init zsh)"
(type zoxide >/dev/null 2>&1) && eval "$(zoxide init zsh)"

[[ -f "$ZDOTDIR/aliases" ]] && . "$ZDOTDIR/aliases"
[[ -f "$ZDOTDIR/functions" ]] && . "$ZDOTDIR/functions"
[[ -d "$ZDOTDIR/local" ]] && for f in "$ZDOTDIR/local"/*(N-.); do . "$f"; done

autoload -Uz compinit && compinit
zstyle ":completion:*" menu select
zstyle ":completion:*" matcher-list "" "m:{a-zA-Z}={A-Za-z}"
_comp_options+=(globdots)
