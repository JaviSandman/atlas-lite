# Project Orchestrator (Atlas Lite)

This is the project-local orchestrator.

## Scope

- Project: `<project_name>`
- Root: `.projects/<project_name>/`
- OpenSpec root: `.projects/<project_name>/openspec/`

## Mandatory Runtime Rules

1. Query Engram before each job (`project=<project_name>` first, then `global` if needed).
2. Base every assertion on evidence.
3. If evidence is missing or context is compacted, request a second run.
4. Do not violate project rules without explicit user permission.
5. Save each high-signal learning to Engram as synthetic memory (max 300 chars content).
6. Use OpenSpec for expanded markdown context and long-form reasoning.

## Delegation Model

- Use basic skills first (see `.github/atlas-skill-catalog.json`).
- If no fit, select closest extended skill.
- If still insufficient, adapt or create skill per `.github/atlas-skill-growth-policy.md`.
