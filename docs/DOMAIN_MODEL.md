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
- Control-plane metadata (this repo):
  - `memory/control/teams/<team-id>/...` (team shared control notes)
  - `memory/control/agents/<agent-id>/...` (agent control notes)

- OpenClaw runtime memory/session (managed by OpenClaw):
  - `.openclaw/agents/<agent-id>/...`
  - session/store paths defined by runtime config and OpenClaw internals

## Notes
- This repo does **not** replace OpenClaw runtime memory layout.
- It adds a team-level control-plane layer above runtime primitives.
- Runtime mapping (sessions/agents/channels) will be implemented incrementally.
