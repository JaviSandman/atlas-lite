# Engram Memory Instruction (Atlas v2)

## Purpose
Store high-signal Atlas memory with strict, synthetic, token-efficient entries.

## Required Fields
- `project`: `global` | `<project_name>`
- `type`: `decision|policy|regulation|pattern|bugfix|incident|discovery|learning|runbook|risk|rule`
- `title`: short, searchable (`Verb: Object`)
- `scope`: `project` (default) | `personal`
- `topic_key`: `domain/topic1+topic2(+topic3)`
- `content`: atomic synthetic fact, max 300 chars

## Project Rules
1. Never save with null `project`.
2. Cross-project standards go to `global`.
3. Project work must use `project=<project_name>` matching `.projects/<project_name>/`.
4. Do not invent aliases for project names.
5. Project naming is defined by user decision.

## Topic Key Rules
1. One canonical key per evolving topic.
2. Reuse key for updates (upsert/revision).
3. New key only if domain or main topics change.

## Content Rules
Use minimal structure:

`fact: ...`  
`impact: ...` (optional)  
`topics: [t1, t2, t3]`

Split long notes into multiple atomic memories.
Never exceed 300 chars in `content`.

## Dual Persistence Rule (On Request)
1. Engram retrieval is mandatory before every execution.
2. New high-signal knowledge must be persisted in Engram.
3. OpenSpec stores expanded documentation at project level.
4. OpenSpec location is always project-scoped:
	- `.projects/<project_name>/openspec/`

## Retrieval Pattern (token-efficient)
1. `mem_search`
2. `mem_context`
3. `mem_get_observation`

## Noise Control
- No raw tool logs as memory.
- Save only decisions, conventions, findings, incidents, and rules.
- If retrieval is inconclusive or context was compacted, request a second run.