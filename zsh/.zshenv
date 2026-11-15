#!/bin/zsh
###############################################################################
# ZSH environment file
#
# Sourced by every zsh, including the non-interactive ones that agents, IDEs,
# and MCP launchers spawn. Keep this fast, silent, and limited to environment.
###############################################################################

source "$HOME/.zsh/path.zsh"

# editor
export VISUAL=vim
export EDITOR="$VISUAL"

# don't let pagers block shells without a terminal (agents, scripts)
if [[ ! -t 1 ]]; then
  export PAGER=cat
  export GIT_PAGER=cat
fi

# python: uv manages interpreters and project environments
export UV_PYTHON_PREFERENCE=only-managed

# machine-specific settings (untracked)
[[ -f "$HOME/.zshenv.local" ]] && source "$HOME/.zshenv.local"
