# Architecture

## Baseline topology
- 1 VM
- 1 Gateway
- N Agents (Director + Workers)
- M Nodes (optional, phase 2)

## Agent model
- **Director Agent**
  - owns team memory curation
  - receives worker reports
  - decides what becomes durable shared memory
- **Worker Agents**
  - handle channel-facing execution
  - report outcomes to Director
  - keep role-local working context

## Communication paths
- User -> Worker (channel)
- Worker -> Director (internal session message)
- Director -> Worker (instructions/summary)

## Why this split
- avoids context collision across users/channels
- keeps organization-level memory coherent
- enables scaling by role without multiple gateways
