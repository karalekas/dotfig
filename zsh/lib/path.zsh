#!/bin/zsh
###############################################################################
# PATH setup
#
# Sourced from both .zshenv (so non-interactive shells spawned by agents, IDEs,
# and MCP launchers can find tools) and .zprofile (because macOS's
# /etc/zprofile runs path_helper, which pushes these entries behind the system
# paths in login shells).
###############################################################################

# homebrew (static equivalent of `brew shellenv`, without forking brew)
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX"
[[ -z "${MANPATH-}" ]] || export MANPATH=":${MANPATH#:}"
export INFOPATH="$HOMEBREW_PREFIX/share/info:${INFOPATH:-}"

# earlier entries take precedence; duplicates are dropped
typeset -U path PATH
path=(
  "$HOME/.local/bin"         # claude, uv, and uv-installed tools
  "$HOMEBREW_PREFIX/bin"
  "$HOMEBREW_PREFIX/sbin"
  "/Library/TeX/texbin"      # pdflatex, tlmgr (basictex)
  $path
)
