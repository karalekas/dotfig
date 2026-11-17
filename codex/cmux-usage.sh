#!/bin/zsh
################################################################################
# Codex hook (SessionStart, PostToolUse, Stop, SessionEnd)
#
# Mirrors the model and context usage into the cmux workspace sidebar, like
# claude/statusline.sh does for Claude Code, and clears them when the session
# ends. Codex has no status line command, so the context comes from the last
# token_count event in the session's transcript.
################################################################################

input=$(cat)

[[ -n "${CMUX_WORKSPACE_ID:-}" ]] && command -v cmux >/dev/null || exit 0
cmux=(cmux)

if [[ "$(jq -r '.hook_event_name // empty' <<< "$input")" == SessionEnd ]]; then
  { $cmux clear-status codex_model; $cmux clear-progress; } >/dev/null 2>&1 &!
  exit 0
fi

model=$(jq -r '.model // empty' <<< "$input")
transcript=$(jq -r '.transcript_path // empty' <<< "$input")

# Codex's own context math: a fixed baseline (system prompt, tool definitions)
# comes off both the usage and the window, so a fresh session reads 0% used
used= window=
if [[ -f "$transcript" ]]; then
  read -r used window < <(grep '"token_count"' "$transcript" | tail -1 | jq -r '
    .payload.info // empty
    | select(.model_context_window > 12000)
    | (.model_context_window - 12000) as $window
    | ([.last_token_usage.total_tokens - 12000, 0] | max) as $tokens
    | "\([$tokens / $window * 100, 100] | min | round) \(.model_context_window)"')
fi

# the window size, like Claude Code's "Opus 5.5 (1M context)". It's only in
# token_count events, so a new session shows the bare model until its first turn
pill=$model
if [[ -n "$window" ]]; then
  if (( window >= 1000000 )); then size="$(( window / 1000000 ))M"
  else size="$(( window / 1000 ))K"; fi
  pill="$pill ($size context)"
fi

# OpenAI models get the ֍ logo. Pill icons can only be SF Symbols, so it goes
# at the start of the text, where the icon would be
icon=(--icon cpu)
if [[ "$model" == (gpt*|o[0-9]*) ]]; then
  pill="֍  $pill"
  icon=()
fi

# in the background, so a slow socket doesn't hold up Codex
{
  [[ -n "$model" ]] && $cmux set-status codex_model "$pill" $icon --color "#689d6a"
  [[ -n "$used" ]] && $cmux set-progress $(( used / 100.0 )) --label "context ${used}%"
} >/dev/null 2>&1 &!
