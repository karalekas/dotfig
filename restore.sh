#!/bin/zsh
################################################################################
# Usage: ./restore.sh [--dry-run] [BACKUP_DIR]
#
# Undo ./install.sh: remove the links it made into this repo, then put back
# everything it moved into BACKUP_DIR (default: the latest ~/.dotfig-backup/*).
# Anything restore.sh itself displaces (e.g. the new ~/.tmux) is moved to
# BACKUP_DIR/displaced/ rather than deleted.
################################################################################

set -euo pipefail

DOTFIG="${0:A:h}"
DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && { DRY_RUN=true; shift; }
BACKUP="${1:-$(ls -d "$HOME"/.dotfig-backup/*(N/) | tail -1)}"
[[ -d "$BACKUP" ]] || { echo "No backup directory found"; exit 1; }
BACKUP="${BACKUP:A}"

run () {
  echo "  $*"
  $DRY_RUN || "$@"
}

# move $1 into BACKUP/displaced so nothing is lost
displace () {
  run mkdir -p "$BACKUP/displaced"
  run mv "$1" "$BACKUP/displaced/"
}

echo "Restoring from $BACKUP"

echo "Removing links into $DOTFIG"
SUBLIME="$HOME/Library/Application Support/Sublime Text/Packages/User/Preferences.sublime-settings"
for link in "$HOME"/.*(N@) "$HOME"/{.config,.claude,.codex}/**/*(N@) "$SUBLIME"(N@); do
  [[ "$(readlink "$link")" == $DOTFIG/* ]] && run rm "$link"
done

echo "Restoring moved files"
# files from under ~/.config, ~/.claude, and ~/.codex are backed up at the
# same path, not the whole dir, so move them back one by one (never the dir)
for item in "$BACKUP"/.*(N) "$BACKUP"/*(N) "$BACKUP"/{.config,.claude,.codex}/**/*(N^/); do
  name="${item#$BACKUP/}"
  [[ "$name" == (links.txt|claude-statusline.json|claude-theme.json|codex-tui-*.txt|sublime-Preferences.sublime-settings|displaced|.config|.claude|.codex) ]] && continue
  [[ -e "$HOME/$name" || -L "$HOME/$name" ]] && displace "$HOME/$name"
  [[ "$name" == */* ]] && run mkdir -p "$HOME/${name:h}"
  run mv "$item" "$HOME/$name"
done

echo "Restoring symlinks"
if [[ -f "$BACKUP/links.txt" ]]; then
  while IFS= read -r line; do
    name="${line%% -> *}"
    target="${line#* -> }"
    [[ -e "$HOME/$name" || -L "$HOME/$name" ]] && displace "$HOME/$name"
    [[ "$name" == */* ]] && run mkdir -p "$HOME/${name:h}"
    # targets may be relative to $HOME, so link from there
    run ln -s "$target" "$HOME/$name"
  done < "$BACKUP/links.txt"
fi

echo "Restoring the Sublime Text settings"
if [[ -e "$BACKUP/sublime-Preferences.sublime-settings" || -L "$BACKUP/sublime-Preferences.sublime-settings" ]]; then
  [[ -e "$SUBLIME" || -L "$SUBLIME" ]] && displace "$SUBLIME"
  run mkdir -p "${SUBLIME:h}"
  run mv "$BACKUP/sublime-Preferences.sublime-settings" "$SUBLIME"
fi

echo "Restoring the Claude Code status line"
SETTINGS="$HOME/.claude/settings.json"
if [[ -f "$BACKUP/claude-statusline.json" && -f "$SETTINGS" ]]; then
  echo "  set statusLine in $SETTINGS from claude-statusline.json"
  if ! $DRY_RUN; then
    jq --slurpfile old "$BACKUP/claude-statusline.json" \
      'if $old[0] == null then del(.statusLine) else .statusLine = $old[0] end' \
      "$SETTINGS" > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"
  fi
fi

echo "Restoring the Claude Code theme"
if [[ -f "$BACKUP/claude-theme.json" && -f "$SETTINGS" ]]; then
  echo "  set theme in $SETTINGS from claude-theme.json"
  if ! $DRY_RUN; then
    jq --slurpfile old "$BACKUP/claude-theme.json" \
      'if $old[0] == null then del(.theme) else .theme = $old[0] end' \
      "$SETTINGS" > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"
  fi
fi

echo "Restoring the Codex title, status line, and theme"
CODEX_CONFIG="$HOME/.codex/config.toml"
for saved in "$BACKUP"/codex-tui-*.txt(N); do
  [[ -f "$CODEX_CONFIG" ]] || break
  key=${${saved:t:r}#codex-tui-}
  echo "  set [tui].$key in $CODEX_CONFIG from ${saved:t}"
  if ! $DRY_RUN; then
    # an empty saved line means the key wasn't set, so this removes it
    KEY=$key LINE="$(cat "$saved")" awk -f "$DOTFIG/codex/tui-key.awk" \
      "$CODEX_CONFIG" > "$CODEX_CONFIG.tmp" && mv "$CODEX_CONFIG.tmp" "$CODEX_CONFIG"
  fi
done

echo "Removing the Codex cmux usage hook"
CODEX_HOOKS="$HOME/.codex/hooks.json"
USAGE_HOOK="$DOTFIG/codex/cmux-usage.sh"
if [[ -f "$CODEX_HOOKS" ]] && jq -e --arg cmd "$USAGE_HOOK" \
    '[.hooks[][]?.hooks[]?.command] | index($cmd)' "$CODEX_HOOKS" >/dev/null; then
  echo "  remove $USAGE_HOOK from $CODEX_HOOKS"
  # drop our groups, then any event left with none
  if ! $DRY_RUN; then
    jq --arg cmd "$USAGE_HOOK" '
      .hooks |= (map_values(map(select([.hooks[]?.command] | index($cmd) | not)))
                 | with_entries(select(.value | length > 0)))' \
      "$CODEX_HOOKS" > "$CODEX_HOOKS.tmp" && mv "$CODEX_HOOKS.tmp" "$CODEX_HOOKS"
  fi
fi

$DRY_RUN && echo "Dry run: nothing changed"
echo "Done. Open a new terminal (and restart tmux) to pick up the old config."
