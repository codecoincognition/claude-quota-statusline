#!/bin/bash
# Claude Code status line — shows quota usage with visual progress bar or text
# Reads JSON from stdin (piped by Claude Code's statusLine feature)
# Usage: bash quota-statusline.sh [--mode bar|text]

MODE="text"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode) MODE="$2"; shift 2 ;;
    *) shift ;;
  esac
done

read -r input

five_h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty' 2>/dev/null)
seven_d=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty' 2>/dev/null)

if [[ -z "$five_h" && -z "$seven_d" ]]; then
  echo "⟡ quota: waiting…"
  exit 0
fi

colorize() {
  local pct="${1%.*}"
  pct=${pct:-0}
  if (( pct >= 95 )); then printf '\e[31m%s%%\e[0m' "$pct"
  elif (( pct >= 80 )); then printf '\e[33m%s%%\e[0m' "$pct"
  else printf '\e[32m%s%%\e[0m' "$pct"
  fi
}

render_bar() {
  local pct="${1%.*}"
  pct=${pct:-0}

  (( pct < 0 )) && pct=0
  (( pct > 100 )) && pct=100

  local filled=$(( (pct + 5) / 10 ))
  local empty=$(( 10 - filled ))

  local color
  if (( pct >= 95 )); then color='\e[31m'
  elif (( pct >= 80 )); then color='\e[33m'
  else color='\e[32m'
  fi

  local bar=""
  for (( i=0; i<filled; i++ )); do bar+="█"; done
  for (( i=0; i<empty; i++ )); do bar+="░"; done

  printf "${color}${bar} ${pct}%%\e[0m"
}

render() {
  if [[ "$MODE" == "text" ]]; then
    colorize "$1"
  else
    render_bar "$1"
  fi
}

output="⟡ "
if [[ -n "$five_h" ]]; then
  output+="5h: $(render "$five_h")"
fi
if [[ -n "$five_h" && -n "$seven_d" ]]; then
  output+=" │ "
fi
if [[ -n "$seven_d" ]]; then
  output+="7d: $(render "$seven_d")"
fi

printf '%b\n' "$output"
