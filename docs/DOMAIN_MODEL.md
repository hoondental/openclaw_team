# Domain Model (Draft)

## Core abstraction: `Agency`

`Agency` is a conceptual supertype for:
- `Team`
- `Agent`

Shared traits:
- identity (`id`, `name`)
- status (`active`, `archived`)
- channel binding metadata
- workspace/memory references

### Status semantics
- `active`: currently routable/operational
- `archived`: soft-retired (history/records preserved, excluded from new routing/assignment)

## Team
- Can contain members: `Agent` and (optionally) child `Team`
- Owns shared memory namespace
- Defines operating policy (e.g., director-worker)

## Agent
- Execution unit (no child members)
- Own private memory namespace
- Can reference team shared memory based on policy
- Can support multiple channels, but production recommendation is one primary channel

## Memory structure (planned)
- Team/shared files (operator-managed):
  - `memory/teams/<team-id>/...`
- Agent drawer/files (operator-managed):
  - `memory/agents/<agent-id>/...`

- OpenClaw runtime memory/session (managed automatically):
  - `.openclaw/agents/<agent-id>/...`
  - session/store paths defined by runtime config and OpenClaw internals

## Notes
- `memory/agents/...` is not a replacement for runtime session memory.
- Working analogy:
  - `.openclaw/agents/...` = agent's "head" (runtime memory)
  - `memory/agents/...` = agent's "drawer/files" (reference material)
- Runtime mapping (sessions/agents/channels) will be implemented incrementally.
