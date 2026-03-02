#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEAMS_DIR="$ROOT_DIR/config/teams"
MEM_DIR="$ROOT_DIR/memory/control/teams"

TEAM_ID=""
FORCE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --id) TEAM_ID="${2:-}"; shift 2;;
    --force) FORCE=1; shift;;
    -h|--help)
      sed -n '1,120p' "$0"
      exit 0
      ;;
    *) echo "Unknown arg: $1" >&2; exit 2;;
  esac
done

[[ -n "$TEAM_ID" ]] || { echo "--id is required" >&2; exit 1; }
TEAM_FILE="$TEAMS_DIR/$TEAM_ID.json"
[[ -f "$TEAM_FILE" ]] || { echo "Team not found: $TEAM_ID" >&2; exit 1; }

if [[ $FORCE -ne 1 ]]; then
  echo "Refusing to remove without --force" >&2
  exit 1
fi

rm -f "$TEAM_FILE"
rm -rf "$MEM_DIR/$TEAM_ID"

echo "✅ Team removed: $TEAM_ID"
