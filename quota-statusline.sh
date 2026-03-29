#!/bin/bash
# Claude Code status line — shows quota usage with visual progress bar
# Reads JSON from stdin (piped by Claude Code's statusLine feature)

read -r input

five_h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty' 2>/dev/null)
seven_d=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty' 2>/dev/null)

if [[ -z "$five_h" && -z "$seven_d" ]]; then
  echo "⟡ quota: waiting…"
  exit 0
fi

render_bar() {
  local pct="${1%.*}"
  pct=${pct:-0}

  # Clamp to 0-100
  (( pct < 0 )) && pct=0
  (( pct > 100 )) && pct=100

  # Compute filled blocks (round: +5 then /10)
  local filled=$(( (pct + 5) / 10 ))
  local empty=$(( 10 - filled ))

  # Color by threshold
  local color
  if (( pct >= 95 )); then color='\e[31m'    # red
  elif (( pct >= 80 )); then color='\e[33m'   # yellow
  else color='\e[32m'                          # green
  fi

  # Build bar
  local bar=""
  for (( i=0; i<filled; i++ )); do bar+="█"; done
  for (( i=0; i<empty; i++ )); do bar+="░"; done

  printf "${color}${bar} ${pct}%%\e[0m"
}

output="⟡ "
if [[ -n "$five_h" ]]; then
  output+="5h: $(render_bar "$five_h")"
fi
if [[ -n "$five_h" && -n "$seven_d" ]]; then
  output+=" │ "
fi
if [[ -n "$seven_d" ]]; then
  output+="7d: $(render_bar "$seven_d")"
fi

printf '%b\n' "$output"
