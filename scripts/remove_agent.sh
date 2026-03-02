#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AGENTS_DIR="$ROOT_DIR/config/agents"
WS_DIR="$ROOT_DIR/workspaces/agents"
MEM_DIR="$ROOT_DIR/memory/control/agents"

AGENT_ID=""
FORCE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --id) AGENT_ID="${2:-}"; shift 2;;
    --force) FORCE=1; shift;;
    -h|--help)
      sed -n '1,140p' "$0"
      exit 0
      ;;
    *) echo "Unknown arg: $1" >&2; exit 2;;
  esac
done

[[ -n "$AGENT_ID" ]] || { echo "--id is required" >&2; exit 1; }

AGENT_FILE="$AGENTS_DIR/$AGENT_ID.json"
[[ -f "$AGENT_FILE" ]] || { echo "Agent not found: $AGENT_ID" >&2; exit 1; }

if [[ $FORCE -ne 1 ]]; then
  echo "Refusing to remove without --force" >&2
  exit 1
fi

rm -f "$AGENT_FILE"
rm -rf "$WS_DIR/$AGENT_ID" "$MEM_DIR/$AGENT_ID"

echo "✅ Agent removed: $AGENT_ID"
