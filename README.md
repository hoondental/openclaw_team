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
  - `docs/INSTALL.md` (설치 순서/옵션/트러블슈팅)
- `agents/` role templates (director/workers)
- `memory/` shared/team memory files
- `config/` example configs and mapping tables
- `scripts/` helper scripts

## VM bootstrap (recommended)
```bash
./scripts/prereq_ubuntu.sh
./scripts/verify_env.sh
./scripts/install_openclaw.sh
./scripts/verify_env.sh --check-openclaw
```

## Why separate `install_openclaw.sh`?
- Keeps base OS prereqs and app install concerns separate
- Easier to pin/upgrade OpenClaw version independently
- Cleaner troubleshooting (Node/npm vs OpenClaw issues)

## Next steps
1. Fill role templates and memory policy
2. Add gateway creation/run scripts for team standard
3. Add director-worker orchestration conventions
