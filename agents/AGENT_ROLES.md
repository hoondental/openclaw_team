# Agent Roles

## Director
- Purpose: orchestrate workers and maintain shared memory quality
- Inputs: worker reports, user strategic instructions
- Outputs: prioritized tasks, curated memory updates

## Worker template
- Purpose: execute role-specific tasks
- Inputs: channel messages, director directives
- Outputs: user-visible results + director report

## Initial role candidates (dental ops)
- frontdesk-worker
- hiring-worker
- billing-worker
- marketing-worker

## Rule of thumb
- Prefer one primary channel per worker in production
- Cross-channel is possible, but increases context collision risk
