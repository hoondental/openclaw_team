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
- `memory/teams/<team-id>/...` (shared)
- `memory/agents/<agent-id>/...` (private)

## Notes
- This is a design layer above OpenClaw runtime primitives.
- Runtime mapping (sessions/agents/channels) will be implemented incrementally.
