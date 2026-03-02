#!/usr/bin/env bash
set -euo pipefail

# create_agent.sh
# Helper-level agent scaffold (team project layer).
# It does NOT replace OpenClaw internal runtime agent creation,
# but creates a consistent team-managed agent profile/workspace/memory layout.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AGENTS_DIR="$ROOT_DIR/config/agents"
WS_DIR="$ROOT_DIR/workspaces/agents"
MEM_DIR="$ROOT_DIR/memory/control/agents"

AGENT_ID=""
AGENT_NAME=""
PRIMARY_CHANNEL=""
TEAM_ID=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --id) AGENT_ID="${2:-}"; shift 2;;
    --name) AGENT_NAME="${2:-}"; shift 2;;
    --channel) PRIMARY_CHANNEL="${2:-}"; shift 2;;
    --team) TEAM_ID="${2:-}"; shift 2;;
    -h|--help)
      sed -n '1,180p' "$0"
      exit 0
      ;;
    *) echo "Unknown arg: $1" >&2; exit 2;;
  esac
done

[[ -n "$AGENT_ID" ]] || { echo "--id is required" >&2; exit 1; }
[[ "$AGENT_ID" =~ ^[a-zA-Z0-9._-]+$ ]] || { echo "invalid --id" >&2; exit 1; }
[[ -n "$AGENT_NAME" ]] || AGENT_NAME="$AGENT_ID"

mkdir -p "$AGENTS_DIR" "$WS_DIR" "$MEM_DIR"
AGENT_FILE="$AGENTS_DIR/$AGENT_ID.json"

if [[ -f "$AGENT_FILE" ]]; then
  echo "Agent already exists: $AGENT_ID" >&2
  exit 1
fi

mkdir -p "$WS_DIR/$AGENT_ID" "$MEM_DIR/$AGENT_ID"

TEAM_BLOCK='null'
if [[ -n "$TEAM_ID" ]]; then
  TEAM_BLOCK="\"$TEAM_ID\""
fi

cat > "$AGENT_FILE" <<EOF
{
  "id": "$AGENT_ID",
  "name": "$AGENT_NAME",
  "kind": "agent",
  "status": "active",
  "teamId": $TEAM_BLOCK,
  "channels": {
    "primary": "${PRIMARY_CHANNEL:-}"
  },
  "workspace": "workspaces/agents/$AGENT_ID",
  "memory": {
    "controlPath": "memory/control/agents/$AGENT_ID",
    "runtimeNote": "OpenClaw runtime memory/session lives under runtime .openclaw/agents/...",
    "teamReferenceMode": "read-shared"
  },
  "openclaw": {
    "note": "Map this agent profile to runtime agent/session policy as implementation evolves"
  }
}
EOF

touch "$MEM_DIR/$AGENT_ID/README.md"

echo "✅ Agent created: $AGENT_ID"
echo "  profile: $AGENT_FILE"
echo "  workspace: $WS_DIR/$AGENT_ID"
echo "  memory: $MEM_DIR/$AGENT_ID"
