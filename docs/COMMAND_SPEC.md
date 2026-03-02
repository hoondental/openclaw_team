# Command Spec (Draft)

## Team lifecycle
- `scripts/create_team.sh --id <team_id> [--name <name>]`
- `scripts/remove_team.sh --id <team_id> --force`

## Agent lifecycle
- `scripts/create_agent.sh --id <agent_id> [--name <name>] [--channel <id>] [--team <team_id>]`
- `scripts/remove_agent.sh --id <agent_id> --force`

## Planned next commands
- `assign_agent.sh --agent <agent_id> --team <team_id>`
- `unassign_agent.sh --agent <agent_id>`
- `list_agencies.sh`
- `show_agency.sh --id <id>`

## Behavior rules (current)
- Scripts manage design-time metadata and local workspace/memory structure.
- Runtime OpenClaw mapping is a later phase.
