#!/usr/bin/env bash
set -euo pipefail

MIN_NODE_MAJOR=20
CHECK_OPENCLAW=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --check-openclaw) CHECK_OPENCLAW=1; shift;;
    -h|--help)
      echo "Usage: $0 [--check-openclaw]"
      exit 0
      ;;
    *)
      echo "Unknown arg: $1" >&2
      exit 2
      ;;
  esac
done

fail(){ echo "[FAIL] $*"; exit 1; }
ok(){ echo "[OK] $*"; }

command -v git >/dev/null 2>&1 || fail "git not found"
command -v rsync >/dev/null 2>&1 || fail "rsync not found"
command -v node >/dev/null 2>&1 || fail "node not found"
command -v npm >/dev/null 2>&1 || fail "npm not found"

NODE_VER="$(node -v | sed 's/^v//')"
NODE_MAJOR="${NODE_VER%%.*}"
[[ "$NODE_MAJOR" -ge "$MIN_NODE_MAJOR" ]] || fail "node too old: $NODE_VER (need >= $MIN_NODE_MAJOR)"

ok "git: $(git --version)"
ok "node: v$NODE_VER"
ok "npm: $(npm -v)"

if [[ $CHECK_OPENCLAW -eq 1 ]]; then
  command -v openclaw >/dev/null 2>&1 || fail "openclaw not found"
  ok "openclaw: $(openclaw --version | head -n1)"
fi

echo "✅ environment ok"
