#!/bin/bash
# Claude Code status line — shows quota usage % with color coding
# Reads JSON from stdin (piped by Claude Code's statusLine feature)

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
  if (( pct >= 95 )); then printf '\e[31m%s%%\e[0m' "$pct"    # red
  elif (( pct >= 80 )); then printf '\e[33m%s%%\e[0m' "$pct"   # yellow
  else printf '\e[32m%s%%\e[0m' "$pct"                          # green
  fi
}

output="⟡ "
if [[ -n "$five_h" ]]; then
  output+="5h: $(colorize "$five_h")"
fi
if [[ -n "$five_h" && -n "$seven_d" ]]; then
  output+=" │ "
fi
if [[ -n "$seven_d" ]]; then
  output+="7d: $(colorize "$seven_d")"
fi

printf '%b\n' "$output"
