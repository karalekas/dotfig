#!/bin/zsh
###############################################################################
# ZSH interactive configuration
#
# Environment and PATH live in .zshenv so non-interactive shells get them too.
# This file is only for things a human at a prompt needs.
###############################################################################

# tmux: autostart only in iTerm, so terminals that manage their own tabs and
# splits (cmux, IDEs, agent harnesses) get a plain shell
if [[ -z "$TMUX" && "$TERM_PROGRAM" == "iTerm.app" && -o interactive ]]; then
  if tmux has-session 2>/dev/null; then
    exec tmux attach
  else
    exec tmux new-session
  fi
fi

# history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000
setopt extended_history hist_expire_dups_first hist_ignore_dups \
  hist_ignore_space hist_verify share_history

# navigation
setopt auto_cd auto_pushd pushd_ignore_dups pushdminus

# don't beep on completion misses or line-editor errors
setopt no_beep

# completion (rebuild the dump at most once a day)
autoload -Uz compinit bashcompinit
stale_dump=("$HOME"/.zcompdump(N.mh+24))
if (( $#stale_dump )); then
  compinit
else
  compinit -C
fi
unset stale_dump
bashcompinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# key bindings: emacs-style, with prefix history search on up/down
bindkey -e
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

source "$HOME/.zsh/prompt.zsh"
source "$HOME/.zsh/aliases.zsh"

# machine-specific settings (untracked)
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# syntax highlighting (brew install zsh-syntax-highlighting; must load last)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red'  # default adds bold
[[ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] &&
  source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
