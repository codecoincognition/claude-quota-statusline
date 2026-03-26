<h1 align="center">claude-quota-statusline</h1>

<p align="center">
  <strong>See your Claude Code quota usage — right in the status bar.</strong>
</p>

<p align="center">
  <a href="https://github.com/codecoincognition/claude-quota-statusline/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License"></a>
  <a href="#install"><img src="https://img.shields.io/badge/platform-macOS-lightgrey.svg" alt="macOS"></a>
  <a href="https://github.com/codecoincognition/claude-quota-statusline/stargazers"><img src="https://img.shields.io/github/stars/codecoincognition/claude-quota-statusline?style=social" alt="Stars"></a>
</p>

<p align="center">
  <a href="#install">Install</a> &middot;
  <a href="#how-it-works">How It Works</a> &middot;
  <a href="#uninstall">Uninstall</a>
</p>

<br>

<p align="center">
  <code>⟡ 5h: 23% │ 7d: 41%</code>
</p>

<br>

---

<br>

## What You Get

<table>
  <tr>
    <td><strong>01</strong></td>
    <td><strong>5-Hour Window</strong></td>
    <td>Rolling 5-hour rate limit usage — your immediate budget</td>
  </tr>
  <tr>
    <td><strong>02</strong></td>
    <td><strong>7-Day Window</strong></td>
    <td>Weekly quota consumption — your long-term budget</td>
  </tr>
  <tr>
    <td><strong>03</strong></td>
    <td><strong>Color Coding</strong></td>
    <td>🟢 Green (&lt;80%) &middot; 🟡 Yellow (80-94%) &middot; 🔴 Red (95%+)</td>
  </tr>
  <tr>
    <td><strong>04</strong></td>
    <td><strong>Zero Config</strong></td>
    <td>One command install — auto-patches your settings</td>
  </tr>
</table>

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

> **Requirements:** macOS &middot; [Claude Code](https://docs.anthropic.com/en/docs/claude-code) &middot; `jq` (auto-installed via Homebrew if missing)

<br>

---

<br>

## How It Works

Claude Code's `statusLine` feature pipes JSON to a configured command after each assistant response:

```json
{
  "rate_limits": {
    "five_hour":  { "used_percentage": 23.5, "resets_at": 1738425600 },
    "seven_day":  { "used_percentage": 41.2, "resets_at": 1738857600 }
  }
}
```

The script reads stdin, extracts both percentages via `jq`, and outputs a color-coded line using ANSI escape codes. Before the first API response in a session, the status bar shows `⟡ quota: waiting…`.

<br>

<details>
<summary><strong>Works with</strong></summary>

<br>

<table>
  <tr>
    <td align="center"><strong>Claude Pro</strong><br><sub>Subscription</sub></td>
    <td align="center"><strong>Claude Max</strong><br><sub>Subscription</sub></td>
    <td align="center"><strong>macOS Terminal</strong><br><sub>Platform</sub></td>
    <td align="center"><strong>iTerm2</strong><br><sub>Platform</sub></td>
  </tr>
</table>

> **Note:** API key users won't see quota data — the `rate_limits` field is only present for Claude.ai subscribers.

</details>

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
