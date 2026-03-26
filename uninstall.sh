#!/bin/bash
set -e

DEST="$HOME/.claude/quota-statusline.sh"
SETTINGS="$HOME/.claude/settings.json"

echo "Uninstalling claude-quota-statusline..."

# Remove script
if [[ -f "$DEST" ]]; then
  rm "$DEST"
  echo "Removed $DEST"
else
  echo "Script not found at $DEST — skipping."
fi

# Remove statusLine from settings.json
if [[ -f "$SETTINGS" ]] && command -v jq &>/dev/null; then
  if jq -e '.statusLine' "$SETTINGS" &>/dev/null; then
    jq 'del(.statusLine)' "$SETTINGS" > "${SETTINGS}.tmp" \
      && mv "${SETTINGS}.tmp" "$SETTINGS"
    echo "Removed statusLine from $SETTINGS"
  fi
fi

echo ""
echo "Uninstalled. Restart Claude Code to apply."
