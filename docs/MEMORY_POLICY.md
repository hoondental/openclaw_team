# Memory Policy

## Levels
1. Worker local memory (short-term/task context)
2. Team shared memory (curated by Director)

## Write policy
- Workers SHOULD NOT directly write shared memory except emergency notes.
- Workers send report to Director after meaningful actions.
- Director decides:
  - keep
  - summarize
  - discard

## Suggested shared files
- `memory/team-decisions.md`
- `memory/team-todos.md`
- `memory/team-facts.md`

## Conflict policy
- Director is source of truth for shared memory updates.
- When conflicting reports occur, Director records both + resolution status.
