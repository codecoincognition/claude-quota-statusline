<h1 align="center">claude-quota-statusline</h1>

<p align="center">
  <strong>Visual progress bars for your Claude Code quota — right in the status bar.</strong>
</p>

<p align="center">
  <a href="https://github.com/codecoincognition/claude-quota-statusline/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License"></a>
  <img src="https://img.shields.io/badge/platform-macOS-lightgrey.svg" alt="macOS">
  <a href="https://github.com/codecoincognition/claude-quota-statusline/stargazers"><img src="https://img.shields.io/github/stars/codecoincognition/claude-quota-statusline?style=social" alt="Stars"></a>
</p>

<p align="center">
  <a href="#install">Install</a> &middot;
  <a href="#how-it-works">How It Works</a> &middot;
  <a href="#display-modes">Display Modes</a> &middot;
  <a href="#uninstall">Uninstall</a>
</p>

<br>

<p align="center">
  <img src="screenshot.png" alt="claude-quota-statusline in action" width="500">
</p>

<p align="center">
  Visual progress bars showing your quota usage — rolling 5-hour and 7-day windows, updated after every response.<br>
  <code>⟡ 5h: ██████░░░░ 60% │ 7d: ██░░░░░░░░ 20%</code><br><br>
  🟢 Green (&lt;80%) &middot; 🟡 Yellow (80-94%) &middot; 🔴 Red (95%+)
</p>

<br>

---

<br>

## Install

<table>
<tr>
<td><strong>One-liner (recommended)</strong></td>
<td><strong>Manual</strong></td>
</tr>
<tr>
<td>

```bash
curl -fsSL https://raw.githubusercontent.com/codecoincognition/claude-quota-statusline/main/install.sh | bash
```

</td>
<td>

```bash
git clone https://github.com/codecoincognition/claude-quota-statusline.git
cd claude-quota-statusline
cp quota-statusline.sh ~/.claude/
chmod +x ~/.claude/quota-statusline.sh
```

Then add to `~/.claude/settings.json`:

```json
"statusLine": {
  "type": "command",
  "command": "bash ~/.claude/quota-statusline.sh"
}
```

</td>
</tr>
</table>

Then **restart Claude Code**.

<br>

> **Requirements:** macOS &middot; [Claude Code](https://docs.anthropic.com/en/docs/claude-code) (Pro or Max subscription) &middot; `jq` (auto-installed via Homebrew if missing)

<br>

---

<br>

## How It Works

Claude Code's `statusLine` feature pipes JSON to a configured command after each assistant response. The JSON includes `rate_limits.five_hour.used_percentage` and `rate_limits.seven_day.used_percentage`.

The script renders a **10-block progress bar** for each window using filled (`█`) and empty (`░`) characters, with ANSI color coding:

| Usage | Color | Example |
|-------|-------|---------|
| < 80% | 🟢 Green | `████░░░░░░ 40%` |
| 80-94% | 🟡 Yellow | `████████░░ 82%` |
| 95%+ | 🔴 Red | `██████████ 98%` |

Before the first API response in a session, the status bar shows `⟡ quota: waiting…`.

> **Note:** API key users won't see quota data — the `rate_limits` field is only present for Claude.ai subscribers.

<br>

---

<br>

## Display Modes

The script supports two display modes via the `--mode` flag:

| Mode | Flag | Output |
|------|------|--------|
| **Bar** (default) | `--mode bar` | `⟡ 5h: ███████░░░ 67% │ 7d: ██░░░░░░░░ 20%` |
| **Text** | `--mode text` | `⟡ 5h: 67% │ 7d: 20%` |

To switch modes, update the `command` in `~/.claude/settings.json`:

```json
"statusLine": {
  "type": "command",
  "command": "bash ~/.claude/quota-statusline.sh --mode text"
}
```

Then restart Claude Code.

<br>

---

<br>

## Uninstall

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/codecoincognition/claude-quota-statusline/main/uninstall.sh)
```

<details>
<summary><strong>Manual uninstall</strong></summary>

<br>

```bash
rm ~/.claude/quota-statusline.sh
```

Remove the `statusLine` key from `~/.claude/settings.json`, then restart Claude Code.

</details>

<br>

---

<br>

<p align="center">
  <sub>Built by <a href="https://github.com/codecoincognition">Code Coin Cognition LLC</a></sub>
</p>
