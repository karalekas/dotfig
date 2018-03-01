#!/bin/zsh
###############################################################################
# ZSH aliases file
###############################################################################

# config
alias aliases="vim $HOME/.zsh_aliases; source $HOME/.zsh_aliases"
alias gitconfig="vim $HOME/.gitconfig"
alias tmuxconf="vim $HOME/.tmux.conf; tmux source-file $HOME/.tmux.conf"
alias vimrc="vim $HOME/.vimrc"
alias zshrc="vim $HOME/.zshrc; source $HOME/.zshrc"

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
