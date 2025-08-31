# Notion Screenshots – Workflow Guide

This repository is used to store screenshots (e.g. for trading notes in Notion) and to generate direct **Raw GitHub URLs** that can be embedded in Notion or other tools.

---

## Keyboard Shortcuts
**File:** `keybindings.json` (VS Code user settings)

- Custom shortcuts to run the tasks quickly:
  - `⌘⌥C` → runs **Copy Raw GitHub URL**
  - `⌘⌥E` → runs **Copy Raw GitHub URL (Markdown)**

---

## How to Use

1. Open this repo in VS Code.
2. Open any file (e.g. a screenshot in `VPA/`).
3. Use a shortcut:
   - `⌘⌥C` → copies the Raw link to clipboard (best for Notion Files & Media property).
   - `⌘⌥E` → copies Markdown embed (useful for Markdown docs, GitHub README, etc.).
4. Alternatively:
   - Press `Cmd+Shift+P` → **Run Task** → choose the desired task.

The link will appear in the Output panel and is also copied to clipboard.

---

## Components

### 1. Bash Script
**File:** `copy raw automation/copy_raw_url.sh`

- Generates the correct **Raw GitHub URL** for any file in this repo.
- Copies the result to clipboard.
- Supports two modes:
  - Default → just the raw link, e.g.  
    `https://raw.githubusercontent.com/verynormali/notion-screenshots/main/VPA/example.png`
  - `--markdown` option → wraps it in Markdown syntax, e.g.  
    `![](https://raw.githubusercontent.com/verynormali/notion-screenshots/main/VPA/example.png)`

### 2. VS Code Tasks
**File:** `.vscode/tasks.json`

- Defines tasks that run the bash script.
- Available tasks:
  - **Copy Raw GitHub URL** → returns raw link
  - **Copy Raw GitHub URL (Markdown)** → returns Markdown-formatted link
  - **Echo Hello (test)** → simple test to confirm tasks.json is loaded

### 3. Keyboard Shortcuts
**File:** `keybindings.json` (VS Code user settings)

- Custom shortcuts to run the tasks quickly:
  - `⌘⌥C` → runs **Copy Raw GitHub URL**
  - `⌘⌥E` → runs **Copy Raw GitHub URL (Markdown)**

---

## Notes

- In Notion, prefer using a **Files & media** property and paste the raw link from `⌘⌥C`. Notion will display the image directly.
- The Markdown version is more useful outside Notion (e.g. GitHub, Markdown notes).
- Repo must remain **Public** for the Raw URLs to work in Notion.
- Don’t forget to **push changes** to GitHub after adding new screenshots, otherwise the Raw links will 404.

---

## Glossary

- **Bash script** → small program in shell language, executed by terminal or VS Code task.
- **JSON (`tasks.json`)** → configuration format used by VS Code to define custom tasks.
- **Task in VS Code** → predefined action, visible via `Cmd+Shift+P` → Run Task.
- **Raw GitHub URL** → direct link to the file content on GitHub’s CDN, usable for embeds.

---

This guide summarizes the setup we created for embedding and linking screenshots into Notion.