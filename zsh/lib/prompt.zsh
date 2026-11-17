#!/bin/zsh
###############################################################################
# Prompt (port of the old "karalekas" oh-my-zsh theme)
#
#  user@host ➜ dir git:(branch) ✗
###############################################################################

autoload -Uz colors vcs_info && colors
setopt prompt_subst

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr ' %F{yellow}✗'
zstyle ':vcs_info:*' stagedstr ' %F{yellow}✗'
zstyle ':vcs_info:git:*' formats '%F{blue}git:(%F{red}%b%F{blue})%u%c%f '
zstyle ':vcs_info:git:*' actionformats '%F{blue}git:(%F{red}%b|%a%F{blue})%u%c%f '

autoload -Uz add-zsh-hook
add-zsh-hook precmd vcs_info

PROMPT=' %F{magenta}%n%F{yellow}@%F{magenta}%m %(?:%F{green}:%F{red})➜ %f %F{cyan}%c%f ${vcs_info_msg_0_}'
