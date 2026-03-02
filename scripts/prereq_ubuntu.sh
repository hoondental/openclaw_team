#!/usr/bin/env bash
set -euo pipefail

# Base prerequisites for Ubuntu/Debian VM
# - apt packages
# - nvm
# - Node.js 22

NODE_MAJOR="22"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --node) NODE_MAJOR="${2:-22}"; shift 2;;
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

if ! command -v sudo >/dev/null 2>&1; then
  echo "ERROR: sudo is required" >&2
  exit 1
fi

echo "[*] Installing apt packages..."
sudo apt update
sudo apt install -y \
  ca-certificates \
  curl \
  git \
  rsync \
  jq \
  build-essential

export NVM_DIR="$HOME/.nvm"
if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
  echo "[*] Installing nvm..."
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

# shellcheck disable=SC1090
source "$NVM_DIR/nvm.sh"

echo "[*] Installing Node.js ${NODE_MAJOR}..."
nvm install "$NODE_MAJOR"
nvm use "$NODE_MAJOR"
nvm alias default "$NODE_MAJOR"

echo "✅ prereq done"
echo "node: $(node -v)"
echo "npm : $(npm -v)"
echo "git : $(git --version)"
