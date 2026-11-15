#!/bin/zsh
###############################################################################
# ZSH aliases
###############################################################################

# this repo, wherever it was cloned (~/.zsh links to its zsh/lib)
DOTFIG="${${(%):-%x}:A:h:h:h}"

# config
alias aliases="vim $DOTFIG/zsh/lib/aliases.zsh; source $HOME/.zsh/aliases.zsh"
alias gitconfig="vim $DOTFIG/git/.gitconfig"
alias tmuxconf="vim $DOTFIG/tmux/.tmux.conf; tmux source-file $HOME/.tmux.conf"
alias vimrc="vim $DOTFIG/vim/.vimrc"
alias zshrc="vim $DOTFIG/zsh/.zshrc; source $HOME/.zshrc"
alias emacsconf="vim $DOTFIG/emacs/.emacs"

# navigation and listing (carried over from oh-my-zsh)
alias -- -="cd -"
alias ls="ls -G"
alias l="ls -lah"
alias la="ls -lAh"
alias ll="ls -lh"

# git
alias ga="git add"
alias gaa="git add --all"
alias gb="git branch -v"
alias gc="git checkout"
alias gcb="git checkout -b"
alias gcm="git commit -m"
alias gdiff="git diff"
alias gr="git remote -v"
alias gs="git status"
