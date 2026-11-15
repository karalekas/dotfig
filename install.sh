#!/bin/zsh
################################################################################
# Usage: ./install.sh [--dry-run]
#
# Symlink dotfiles into $HOME. Anything already in the way is moved to
# ~/.dotfig-backup/<timestamp>/ (symlinks are recorded in links.txt), so
# ./restore.sh can put it back. Then set the few keys in Claude Code's and
# Codex's own settings files that this setup needs. Safe to re-run.
################################################################################

set -euo pipefail

DOTFIG="${0:A:h}"
BACKUP="$HOME/.dotfig-backup/$(date +%Y-%m-%dT%H%M%S)"
DRY_RUN=false
for arg; do
  case $arg in
    --dry-run) DRY_RUN=true ;;
    *) echo "Usage: $0 [--dry-run]"; exit 1 ;;
  esac
done

# repo path -> home path
LINKS=(
  zsh/.zshenv     .zshenv
  zsh/.zprofile   .zprofile
  zsh/.zshrc      .zshrc
  zsh/lib         .zsh
  tmux/.tmux.conf .tmux.conf
  git/.gitconfig  .gitconfig
  vim/.vimrc      .vimrc
  ghostty/config.ghostty .config/ghostty/config.ghostty
  cmux/cmux.json  .config/cmux/cmux.json
  claude/themes/gruvbox-dark.json .claude/themes/gruvbox-dark.json
  emacs/.emacs    .emacs
  emacs/.emacs.d  .emacs.d
)

run () {
  echo "  $*"
  $DRY_RUN || "$@"
}

# create the backup directory the first time something needs it
start_backup () {
  if [[ -z "${BACKED_UP:-}" ]]; then
    run mkdir -p "$BACKUP"
    BACKED_UP=true
  fi
}

# move $1 out of the way, into the same path under the backup directory
back_up () {
  local target=$1 rel=${1#$HOME/}
  start_backup
  if [[ -L "$target" ]]; then
    echo "  record $rel -> $(readlink "$target")"
    $DRY_RUN || echo "$rel -> $(readlink "$target")" >> "$BACKUP/links.txt"
    run rm "$target"
  else
    [[ "$rel" == */* ]] && run mkdir -p "$BACKUP/${rel:h}"
    run mv "$target" "$BACKUP/$rel"
  fi
}

echo "Linking dotfiles from $DOTFIG"
for src dst in $LINKS; do
  src="$DOTFIG/$src"
  dst="$HOME/$dst"
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    continue
  fi
  [[ -e "$dst" || -L "$dst" ]] && back_up "$dst"
  [[ -d "${dst:h}" ]] || run mkdir -p "${dst:h}"
  run ln -s "$src" "$dst"
done

echo "Linking the Sublime Text settings"
# under ~/Library, so an existing file is saved as a top-level file in the
# backup (restore.sh would otherwise move a whole Library folder back)
SUBLIME="$HOME/Library/Application Support/Sublime Text/Packages/User/Preferences.sublime-settings"
if [[ "$(readlink "$SUBLIME" 2>/dev/null)" != "$DOTFIG/sublime/Preferences.sublime-settings" ]]; then
  if [[ -e "$SUBLIME" || -L "$SUBLIME" ]]; then
    start_backup
    echo "  record $SUBLIME in sublime-Preferences.sublime-settings"
    $DRY_RUN || cp -P "$SUBLIME" "$BACKUP/sublime-Preferences.sublime-settings"
    run rm "$SUBLIME"
  fi
  [[ -d "${SUBLIME:h}" ]] || run mkdir -p "${SUBLIME:h}"
  run ln -s "$DOTFIG/sublime/Preferences.sublime-settings" "$SUBLIME"
fi

echo "Setting up tmux state and plugins"
RESURRECT="$HOME/.local/share/tmux/resurrect"
if [[ -L "$HOME/.tmux" ]]; then
  old_resurrect="$(readlink -f "$HOME/.tmux")/resurrect"
  if [[ -d "$old_resurrect" && ! -d "$RESURRECT" ]]; then
    run mkdir -p "${RESURRECT:h}"
    run cp -a "$old_resurrect" "$RESURRECT"
  fi
  back_up "$HOME/.tmux"
fi
# clone tpm and every @plugin in .tmux.conf directly (TPM's own installer uses
# https://git::@github.com URLs, which can hang)
for repo in tmux-plugins/tpm ${(f)"$(sed -n "s/^set -g @plugin '\(.*\)'/\1/p" "$DOTFIG/tmux/.tmux.conf")"}; do
  if [[ ! -d "$HOME/.tmux/plugins/${repo:t}" ]]; then
    run git clone -q "https://github.com/$repo" "$HOME/.tmux/plugins/${repo:t}"
  fi
done

echo "Pointing the Claude Code status line at claude/statusline.sh"
# settings.json is also written by Claude Code itself, so set only
# this key rather than linking the file. The old value is saved for restore.sh
SETTINGS="$HOME/.claude/settings.json"
STATUSLINE="$DOTFIG/claude/statusline.sh"
[[ -f "$SETTINGS" ]] || { run mkdir -p "${SETTINGS:h}"; $DRY_RUN || echo '{}' > "$SETTINGS"; }
if [[ "$(jq -r '.statusLine.command // empty' "$SETTINGS" 2>/dev/null)" != "$STATUSLINE" ]]; then
  start_backup
  echo "  record statusLine in claude-statusline.json"
  echo "  set statusLine.command in $SETTINGS"
  if ! $DRY_RUN; then
    jq '.statusLine // null' "$SETTINGS" > "$BACKUP/claude-statusline.json"
    jq --arg cmd "$STATUSLINE" '.statusLine.type = "command" | .statusLine.command = $cmd' \
      "$SETTINGS" > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"
  fi
fi

echo "Selecting the Gruvbox Dark Claude Code theme"
# the theme file is linked into ~/.claude/themes above; selecting it is the
# theme key in settings.json, set the same way as statusLine
THEME="custom:gruvbox-dark"
if [[ "$(jq -r '.theme // empty' "$SETTINGS" 2>/dev/null)" != "$THEME" ]]; then
  start_backup
  echo "  record theme in claude-theme.json"
  echo "  set theme in $SETTINGS"
  if ! $DRY_RUN; then
    jq '.theme // null' "$SETTINGS" > "$BACKUP/claude-theme.json"
    jq --arg theme "$THEME" '.theme = $theme' "$SETTINGS" > "$SETTINGS.tmp" &&
      mv "$SETTINGS.tmp" "$SETTINGS"
  fi
fi

echo "Setting the Codex title, status line, and theme"
# like settings.json, config.toml is also written by Codex and cmux, so
# set only these [tui] keys, each saved as codex-tui-<key>.txt for restore.sh.
# The title is codex plus the thread title, like Claude Code's (cmux shows it
# as the pane, and without a custom name, workspace title); the status line
# matches the "model | Context" part of Claude Code's; gruvbox-dark matches the
# terminal theme and also colors the status line
CODEX_CONFIG="$HOME/.codex/config.toml"
TUI_LINES=(
  terminal_title 'terminal_title = ["app-name", "activity", "thread-title"]'
  status_line    'status_line = ["model-with-reasoning", "context-used"]'
  theme          'theme = "gruvbox-dark"'
)
if [[ ! -f "$CODEX_CONFIG" ]]; then
  echo "  skip: $CODEX_CONFIG not found (run codex doctor first)"
else
  for key line in $TUI_LINES; do
    current=$(KEY=$key awk '/^\[/ { t = ($0 == "[tui]") } t && $0 ~ ("^" ENVIRON["KEY"] "[ \t]*=")' "$CODEX_CONFIG")
    [[ "$current" == "$line" ]] && continue
    start_backup
    echo "  record [tui].$key in codex-tui-$key.txt"
    echo "  set [tui].$key in $CODEX_CONFIG"
    if ! $DRY_RUN; then
      print -r -- "$current" > "$BACKUP/codex-tui-$key.txt"
      KEY=$key LINE=$line awk -f "$DOTFIG/codex/tui-key.awk" "$CODEX_CONFIG" \
        > "$CODEX_CONFIG.tmp" && mv "$CODEX_CONFIG.tmp" "$CODEX_CONFIG"
    fi
  done
fi

echo "Adding the Codex hook that shows the model and context in cmux"
# hooks.json belongs to cmux (cmux hooks codex install), so append a group to
# each event rather than linking the file. Codex trusts hooks by position, so
# leave existing groups in place; restore.sh removes ours by command path
CODEX_HOOKS="$HOME/.codex/hooks.json"
USAGE_HOOK="$DOTFIG/codex/cmux-usage.sh"
if [[ ! -f "$CODEX_HOOKS" ]]; then
  echo "  skip: $CODEX_HOOKS not found (run cmux hooks codex install first)"
else
  for event in SessionStart PostToolUse Stop SessionEnd; do
    jq -e --arg e "$event" --arg cmd "$USAGE_HOOK" \
      '[.hooks[$e][]?.hooks[]?.command] | index($cmd)' "$CODEX_HOOKS" >/dev/null && continue
    echo "  add $event hook to $CODEX_HOOKS"
    if ! $DRY_RUN; then
      jq --arg e "$event" --arg cmd "$USAGE_HOOK" \
        '.hooks[$e] += [{hooks: [{type: "command", command: $cmd, timeout: 3}]}]' \
        "$CODEX_HOOKS" > "$CODEX_HOOKS.tmp" && mv "$CODEX_HOOKS.tmp" "$CODEX_HOOKS"
    fi
  done
fi

$DRY_RUN && echo "Dry run: nothing changed"
[[ -n "${BACKED_UP:-}" ]] && echo "Backed up replaced files to $BACKUP"
echo "Done. Open a new terminal to pick up the changes."
