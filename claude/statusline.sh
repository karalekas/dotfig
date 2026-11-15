#!/bin/zsh
################################################################################
# Claude Code status line: "model | Context: N%", in Gruvbox colors
#
# Also mirrors the model and context used into the cmux workspace sidebar,
# like codex/cmux-usage.sh does for Codex.
################################################################################

input=$(cat)
model=$(jq -r '.model.display_name // empty' <<< "$input")
model_id=$(jq -r '.model.id // empty' <<< "$input")
used=$(jq -r '.context_window.used_percentage // empty' <<< "$input")

if [[ -n "${CMUX_WORKSPACE_ID:-}" ]] && command -v cmux >/dev/null; then
  # Anthropic models get the ✳ that Claude Code puts in its terminal title.
  # Pill icons can only be SF Symbols, so it goes at the start of the text
  pill=$model icon=(--icon cpu)
  [[ "$model_id" == *(anthropic|claude)* ]] && { pill="✳  $model"; icon=(); }
  # in the background, so a slow socket doesn't hold up the status line
  {
    [[ -n "$model" ]] && cmux set-status claude_model "$pill" $icon --color "#689d6a"
    [[ -n "$used" ]] && cmux set-progress $(( used / 100.0 )) --label "context ${used%.*}%"
  } >/dev/null 2>&1 &!
fi

# Gruvbox aqua for the model, gray for the label, yellow for the number
line=$'\e[36m'"$model"$'\e[0m'
[[ -n "$used" ]] && line+=$' \e[90m|\e[0m Context: \e[33m'"${used%.*}%"$'\e[0m'
print -rn -- "$line"
