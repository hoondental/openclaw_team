#!/usr/bin/env bash
set -euo pipefail

# Install OpenClaw CLI in a nvm-managed Node environment
# Default target version is pinned for reproducibility.

OPENCLAW_VERSION="2026.2.26"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --version) OPENCLAW_VERSION="${2:-}"; shift 2;;
    -h|--help)
      sed -n '1,160p' "$0"
      exit 0
      ;;
    *)
      echo "Unknown arg: $1" >&2
      exit 2
      ;;
  esac
done

if ! command -v npm >/dev/null 2>&1; then
  echo "ERROR: npm not found. Run scripts/prereq_ubuntu.sh first." >&2
  exit 1
fi

echo "[*] Installing openclaw@${OPENCLAW_VERSION} ..."
if ! npm install -g "openclaw@${OPENCLAW_VERSION}"; then
  echo "[!] Pinned version failed. Falling back to latest openclaw ..."
  npm install -g openclaw
fi

PREFIX="$(npm config get prefix 2>/dev/null || true)"
if [[ -n "$PREFIX" && -d "$PREFIX/bin" ]]; then
  LINE="export PATH=\"$PREFIX/bin:\$PATH\""
  touch "$HOME/.bashrc"
  if ! grep -Fq "$LINE" "$HOME/.bashrc"; then
    echo "$LINE" >> "$HOME/.bashrc"
    echo "[*] Added PATH line to ~/.bashrc"
  fi
  export PATH="$PREFIX/bin:$PATH"
fi

hash -r || true

if ! command -v openclaw >/dev/null 2>&1; then
  echo "ERROR: openclaw installed but not found on PATH. run: source ~/.bashrc" >&2
  exit 1
fi

echo "✅ openclaw installed: $(openclaw --version | head -n1)"
