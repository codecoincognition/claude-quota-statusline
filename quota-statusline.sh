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

# Detect Claude theme to adjust contrast
THEME=$(jq -r '.theme // "dark"' ~/.claude/settings.json 2>/dev/null)

if [[ "$THEME" == "light" ]]; then
  # High-contrast bold/darker colors for light background
  COLOR_RED='\e[1;31m'
  COLOR_YELLOW='\e[1;33m' # Bold yellow/brown has excellent readability on light BG
  COLOR_GREEN='\e[1;32m'  # Bold green is dark and very readable
  COLOR_RESET='\e[0m'
  COLOR_DIM='\e[2m'       # Dim adapts to terminal background, perfect for empty bar
else
  # Bright colors for dark background
  COLOR_RED='\e[31m'
  COLOR_YELLOW='\e[33m'
  COLOR_GREEN='\e[32m'
  COLOR_RESET='\e[0m'
  COLOR_DIM='\e[2m'
fi

colorize() {
  local pct="${1%.*}"
  pct=${pct:-0}
  if (( pct >= 95 )); then printf "${COLOR_RED}%s%%${COLOR_RESET}" "$pct"
  elif (( pct >= 80 )); then printf "${COLOR_YELLOW}%s%%${COLOR_RESET}" "$pct"
  else printf "${COLOR_GREEN}%s%%${COLOR_RESET}" "$pct"
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
  if (( pct >= 95 )); then color="${COLOR_RED}"
  elif (( pct >= 80 )); then color="${COLOR_YELLOW}"
  else color="${COLOR_GREEN}"
  fi

  local bar="${color}"
  for (( i=0; i<filled; i++ )); do bar+="█"; done
  bar+="${COLOR_RESET}"

  if (( empty > 0 )); then
    bar+="${COLOR_DIM}"
    for (( i=0; i<empty; i++ )); do bar+="░"; done
    bar+="${COLOR_RESET}"
  fi

  printf "${bar} ${color}${pct}%%${COLOR_RESET}"
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
