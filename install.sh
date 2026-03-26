#!/bin/bash
set -e

SCRIPT_URL="https://raw.githubusercontent.com/codecoincognition/claude-quota-statusline/main/quota-statusline.sh"
DEST="$HOME/.claude/quota-statusline.sh"
SETTINGS="$HOME/.claude/settings.json"

echo "Installing claude-quota-statusline..."

# Check for jq
if ! command -v jq &>/dev/null; then
  echo "jq not found. Attempting to install via Homebrew..."
  if command -v brew &>/dev/null; then
    brew install jq
  else
    echo "Error: jq is required but not installed, and Homebrew is not available."
    echo "Install jq manually: https://jqlang.github.io/jq/download/"
    exit 1
  fi
fi

# Check Claude Code directory exists
if [[ ! -d "$HOME/.claude" ]]; then
  echo "Error: ~/.claude directory not found. Is Claude Code installed?"
  exit 1
fi

# Download the script
if command -v curl &>/dev/null; then
  curl -fsSL "$SCRIPT_URL" -o "$DEST"
elif command -v wget &>/dev/null; then
  wget -qO "$DEST" "$SCRIPT_URL"
else
  echo "Error: curl or wget required."
  exit 1
fi
chmod +x "$DEST"

# Patch settings.json
STATUSLINE='{"type":"command","command":"bash ~/.claude/quota-statusline.sh"}'

if [[ ! -f "$SETTINGS" ]]; then
  echo "{\"statusLine\":$STATUSLINE}" | jq . > "$SETTINGS"
elif jq -e '.statusLine' "$SETTINGS" &>/dev/null; then
  echo "statusLine already configured in settings.json — skipping."
  echo "To overwrite, remove the statusLine key first and re-run."
else
  jq --argjson sl "$STATUSLINE" '. + {statusLine: $sl}' "$SETTINGS" > "${SETTINGS}.tmp" \
    && mv "${SETTINGS}.tmp" "$SETTINGS"
fi

echo ""
echo "Installed successfully!"
echo ""
echo "  Script:  $DEST"
echo "  Config:  statusLine added to $SETTINGS"
echo ""
echo "Restart Claude Code to see quota usage in the status bar."
echo ""
echo "  Green  = under 80%"
echo "  Yellow = 80-94%"
echo "  Red    = 95%+"
echo ""
echo "To uninstall: bash <(curl -fsSL https://raw.githubusercontent.com/codecoincognition/claude-quota-statusline/main/uninstall.sh)"
