# claude-quota-statusline

Show your Claude Code quota usage percentage in the status bar — right inside the terminal.

```
⟡ 5h: 23% │ 7d: 41%
```

Color-coded so you know when to pace yourself:
- **Green** — under 80%, you're good
- **Yellow** — 80-94%, start wrapping up
- **Red** — 95%+, almost out

Works with Claude Pro and Max subscriptions. Updates after each assistant response.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/codecoincognition/claude-quota-statusline/main/install.sh | bash
```

Then restart Claude Code.

**Requirements:** macOS, [Claude Code](https://docs.anthropic.com/en/docs/claude-code), `jq` (auto-installed via Homebrew if missing).

## What it does

1. Copies `quota-statusline.sh` to `~/.claude/`
2. Adds a `statusLine` entry to `~/.claude/settings.json`

Claude Code pipes quota JSON to the script on every assistant response. The script reads the 5-hour and 7-day usage percentages and displays them with ANSI color codes.

Before the first API response in a session, the status bar shows `⟡ quota: waiting…`.

## Uninstall

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/codecoincognition/claude-quota-statusline/main/uninstall.sh)
```

## Manual install

If you prefer not to pipe scripts from the internet:

```bash
# 1. Copy the script
cp quota-statusline.sh ~/.claude/quota-statusline.sh
chmod +x ~/.claude/quota-statusline.sh

# 2. Add to settings.json (merge, don't overwrite)
# Add this key to your existing ~/.claude/settings.json:
#
#   "statusLine": {
#     "type": "command",
#     "command": "bash ~/.claude/quota-statusline.sh"
#   }

# 3. Restart Claude Code
```

## How it works

Claude Code's `statusLine` feature pipes JSON to a configured command after each assistant response. The JSON includes:

```json
{
  "rate_limits": {
    "five_hour": { "used_percentage": 23.5, "resets_at": 1738425600 },
    "seven_day": { "used_percentage": 41.2, "resets_at": 1738857600 }
  }
}
```

The script extracts the percentages and displays them with color thresholds.

## License

MIT
