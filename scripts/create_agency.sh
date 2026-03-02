#!/usr/bin/env bash
set -euo pipefail

# create_agency.sh
# Wrapper entrypoint for Agency creation.
# Delegates to create_team.sh / create_agent.sh for now.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPTS_DIR="$ROOT_DIR/scripts"

KIND=""

usage(){
  cat <<'EOF'
Usage:
  create_agency.sh --kind team  --id <team_id>  [--name <name>]
  create_agency.sh --kind agent --id <agent_id> [--name <name>] [--channel <id>] [--team <team_id>]

Notes:
- This is a wrapper. Real implementation is delegated:
  - team  -> scripts/create_team.sh
  - agent -> scripts/create_agent.sh
EOF
}

if [[ $# -eq 0 ]]; then
  usage
  exit 1
fi

ARGS=("$@")
for ((i=1; i<=$#; i++)); do
  if [[ "${!i}" == "--kind" ]]; then
    j=$((i+1))
    KIND="${!j:-}"
    break
  fi
done

case "$KIND" in
  team)
    exec "$SCRIPTS_DIR/create_team.sh" "${ARGS[@]}"
    ;;
  agent)
    exec "$SCRIPTS_DIR/create_agent.sh" "${ARGS[@]}"
    ;;
  "")
    echo "ERROR: --kind is required" >&2
    usage
    exit 2
    ;;
  *)
    echo "ERROR: unsupported kind: $KIND" >&2
    usage
    exit 2
    ;;
esac
