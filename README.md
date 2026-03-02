# openclaw_team

Team-oriented OpenClaw architecture for a single-purpose VM (e.g. dental operations).

## Principles
1. One VM = one domain purpose
2. One Gateway per VM
3. Agent-per-role (and usually per primary channel)
4. Shared memory governed by a Director agent
5. Nodes can be added later

## Repo layout
- `docs/` architecture and operating rules
- `agents/` role templates (director/workers)
- `memory/` shared/team memory files
- `config/` example configs and mapping tables
- `scripts/` helper scripts

## Next steps
1. Create GitHub repo: `hoondental/openclaw_team`
2. Add remote and push
3. Fill role templates and memory policy
