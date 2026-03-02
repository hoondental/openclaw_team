#!/usr/bin/env bash
set -euo pipefail

# sync_membership.sh
# Rebuild team member indexes from agent source-of-truth (teamId).

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEAMS_DIR="$ROOT_DIR/config/teams"
AGENTS_DIR="$ROOT_DIR/config/agents"

[[ -d "$TEAMS_DIR" ]] || { echo "No teams dir: $TEAMS_DIR"; exit 0; }
[[ -d "$AGENTS_DIR" ]] || { echo "No agents dir: $AGENTS_DIR"; exit 0; }

ROOT_DIR="$ROOT_DIR" python3 - <<'PY'
import json, os
from pathlib import Path

root = Path(os.environ["ROOT_DIR"])
teams_dir = root / "config" / "teams"
agents_dir = root / "config" / "agents"

team_members = {}
for team_file in teams_dir.glob("*.json"):
    team_id = team_file.stem
    team_members[team_id] = []

for agent_file in agents_dir.glob("*.json"):
    try:
        j = json.loads(agent_file.read_text(encoding="utf-8"))
    except Exception:
        continue
    aid = j.get("id") or agent_file.stem
    tid = j.get("teamId")
    if tid and tid in team_members:
        team_members[tid].append(aid)

for team_file in teams_dir.glob("*.json"):
    j = json.loads(team_file.read_text(encoding="utf-8"))
    tid = j.get("id") or team_file.stem
    members = sorted(team_members.get(tid, []))
    j["members"] = members
    team_file.write_text(json.dumps(j, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"synced team={tid} members={len(members)}")
PY
