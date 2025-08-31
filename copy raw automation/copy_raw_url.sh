#!/usr/bin/env bash
# Copy a Raw GitHub URL for the currently opened file to the clipboard.
# Usage: copy_raw_url.sh <absolute_path_to_file>

set -euo pipefail

FILE_PATH="${1:-}"
if [[ -z "${FILE_PATH}" ]]; then
  echo "No file path provided. Run this task from an open file."
  exit 1
fi

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not inside a Git repository."
  exit 1
fi

REPO_ROOT="$(git rev-parse --show-toplevel)"
BRANCH="$(git rev-parse --abbrev-ref HEAD || echo main)"
if [[ "${BRANCH}" == "HEAD" ]]; then BRANCH="main"; fi

REMOTE_URL="$(git config --get remote.origin.url || true)"
if [[ -z "${REMOTE_URL}" ]]; then
  echo "No 'origin' remote configured."
  exit 1
fi

# Parse user/repo from https or ssh remote
read -r GH_USER GH_REPO <<EOF
$(python3 - "$REMOTE_URL" <<'PY'
import sys, re
u = sys.argv[1].strip()
m = re.search(r'github\.com[:/]+([^/]+)/([^/]+?)(?:\.git)?$', u)
if not m:
    print("parse_error parse_error")
    sys.exit(0)
print(m.group(1), m.group(2))
PY
)
EOF

if [[ "${GH_USER}" == "parse_error" ]]; then
  echo "Cannot parse GitHub remote URL: ${REMOTE_URL}"
  exit 2
fi

# Path relative to repo root
REL_PATH="$(python3 - <<'PY'
import os, sys
repo = os.environ.get('REPO_ROOT')
file = os.environ.get('FILE_PATH')
print(os.path.relpath(file, repo))
PY
)"
export REL_PATH

# URL-encode path segments
ENC_PATH="$(python3 - <<'PY'
import os, urllib.parse
p = os.environ.get('REL_PATH')
print("/".join(urllib.parse.quote(seg) for seg in p.split("/")))
PY
)"

RAW_URL="https://raw.githubusercontent.com/${GH_USER}/${GH_REPO}/${BRANCH}/${ENC_PATH}"

# Copy to clipboard (macOS pbcopy; Linux xclip/xsel; WSL clip.exe)
COPIED="no"
if command -v pbcopy >/dev/null 2>&1; then
  printf "%s" "$RAW_URL" | pbcopy && COPIED="yes"
elif command -v xclip >/dev/null 2>&1; then
  printf "%s" "$RAW_URL" | xclip -selection clipboard && COPIED="yes"
elif command -v xsel >/dev/null 2>&1; then
  printf "%s" "$RAW_URL" | xsel --clipboard --input && COPIED="yes"
elif [[ -n "${WSL_DISTRO_NAME:-}" ]] && command -v clip.exe >/dev/null 2>&1; then
  printf "%s" "$RAW_URL" | clip.exe && COPIED="yes"
fi

echo "Raw URL:"
echo "$RAW_URL"
if [[ "$COPIED" == "yes" ]]; then
  echo "(Copied to clipboard)"
else
  echo "(Could not auto-copy to clipboard on this OS. Copy from the line above.)"
fi

# Warn if file isn't pushed yet