#!/usr/bin/env bash
set -euo pipefail

# create_team.sh (skeleton)
# NOTE: team policy model is intentionally left minimal for now.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEAMS_DIR="$ROOT_DIR/config/teams"
MEM_DIR="$ROOT_DIR/memory/control/teams"

TEAM_ID=""
TEAM_NAME=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --id) TEAM_ID="${2:-}"; shift 2;;
    --name) TEAM_NAME="${2:-}"; shift 2;;
    -h|--help)
      sed -n '1,140p' "$0"
      exit 0
      ;;
    *) echo "Unknown arg: $1" >&2; exit 2;;
  esac
done

[[ -n "$TEAM_ID" ]] || { echo "--id is required" >&2; exit 1; }
[[ "$TEAM_ID" =~ ^[a-zA-Z0-9._-]+$ ]] || { echo "invalid --id" >&2; exit 1; }
[[ -n "$TEAM_NAME" ]] || TEAM_NAME="$TEAM_ID"

mkdir -p "$TEAMS_DIR" "$MEM_DIR/$TEAM_ID"
TEAM_FILE="$TEAMS_DIR/$TEAM_ID.json"

if [[ -f "$TEAM_FILE" ]]; then
  echo "Team already exists: $TEAM_ID" >&2
  exit 1
fi

cat > "$TEAM_FILE" <<EOF
{
  "id": "$TEAM_ID",
  "name": "$TEAM_NAME",
  "kind": "team",
  "status": "active",
  "members": [],
  "memory": {
    "sharedControlPath": "memory/control/teams/$TEAM_ID"
  },
  "policy": {
    "mode": "director-worker",
    "notes": "TODO: define team operation policy"
  }
}
EOF

touch "$MEM_DIR/$TEAM_ID/README.md"

echo "✅ Team created: $TEAM_ID"
echo "  file: $TEAM_FILE"
echo "  memory: $MEM_DIR/$TEAM_ID"
