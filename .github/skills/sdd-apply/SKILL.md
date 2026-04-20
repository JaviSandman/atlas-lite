---
name: sdd-apply
description: Implement tasks from the change, writing actual code following the specs and design.
metadata:
  id: sdd-apply
  author: gentleman-programming
  license: MIT
  trigger: When the orchestrator launches you to implement one or more tasks from a change.
  version: '2.0'
---

## Purpose

You are a sub-agent responsible for IMPLEMENTATION. You receive specific tasks from `tasks.md` and implement them by writing actual code. You follow the specs and design strictly.

## What You Receive

From the orchestrator:
- Change name
- The specific task(s) to implement (e.g., "Phase 1, tasks 1.1-1.3")
- Artifact store mode (`engram | openspec | none`)

### Retrieving Previous Artifacts

Before writing ANY code, load ALL previous artifacts:

- **engram mode**: Use `mem_search` to find the proposal (`proposal/{change-name}`), delta specs (`spec/{change-name}`), design (`design/{change-name}`), and tasks (`tasks/{change-name}`).
- **openspec mode**: Read `openspec/changes/{change-name}/proposal.md`, `openspec/changes/{change-name}/specs/`, `openspec/changes/{change-name}/design.md`, `openspec/changes/{change-name}/tasks.md`, and `openspec/config.yaml`.
- **none mode**: Use whatever context the orchestrator passed in the prompt.

## Execution and Persistence Contract

From the orchestrator:
- `artifact_store.mode`: `engram | openspec | none`
- `detail_level`: `concise | standard | deep`

Default resolution (when orchestrator does not explicitly set a mode):
1. If Engram is available â†’ use `engram`
2. Otherwise â†’ use `none`

`openspec` is NEVER used by default â€” only when the orchestrator explicitly passes `openspec`.

When falling back to `none`, recommend the user enable `engram` or `openspec` for better results.

Rules:
- If mode resolves to `none`, do not update project artifacts (including `tasks.md`); return progress only.
- If mode resolves to `engram`, persist implementation progress in Engram and return references.
- If mode resolves to `openspec`, update `tasks.md` and file artifacts as defined in this skill.

## What to Do

### Step 1: Read Context

Before writing ANY code:
1. Read the specs â€” understand WHAT the code must do
2. Read the design â€” understand HOW to structure the code
3. Read existing code in affected files â€” understand current patterns
4. Check the project's coding conventions from `config.yaml`

### Step 2: Detect Implementation Mode

Before writing code, determine if the project uses TDD:

```
Detect TDD mode from (in priority order):
â”œâ”€â”€ openspec/config.yaml â†’ rules.apply.tdd (true/false â€” highest priority)
â”œâ”€â”€ User's installed skills (e.g., tdd/SKILL.md exists)
â”œâ”€â”€ Existing test patterns in the codebase (test files alongside source)
â””â”€â”€ Default: standard mode (write code first, then verify)

IF TDD mode is detected â†’ use Step 2a (TDD Workflow)
IF standard mode â†’ use Step 2b (Standard Workflow)
```

### Step 2a: Implement Tasks (TDD Workflow â€” RED â†’ GREEN â†’ REFACTOR)

When TDD is active, EVERY task follows this cycle:

```
FOR EACH TASK:
â”œâ”€â”€ 1. UNDERSTAND
â”‚   â”œâ”€â”€ Read the task description
â”‚   â”œâ”€â”€ Read relevant spec scenarios (these are your acceptance criteria)
â”‚   â”œâ”€â”€ Read the design decisions (these constrain your approach)
â”‚   â””â”€â”€ Read existing code and test patterns
â”‚
â”œâ”€â”€ 2. RED â€” Write a failing test FIRST
â”‚   â”œâ”€â”€ Write test(s) that describe the expected behavior from the spec scenarios
â”‚   â”œâ”€â”€ Run tests â€” confirm they FAIL (this proves the test is meaningful)
â”‚   â””â”€â”€ If test passes immediately â†’ the behavior already exists or the test is wrong
â”‚
â”œâ”€â”€ 3. GREEN â€” Write the minimum code to pass
â”‚   â”œâ”€â”€ Implement ONLY what's needed to make the failing test(s) pass
â”‚   â”œâ”€â”€ Run tests â€” confirm they PASS
â”‚   â””â”€â”€ Do NOT add extra functionality beyond what the test requires
â”‚
â”œâ”€â”€ 4. REFACTOR â€” Clean up without changing behavior
â”‚   â”œâ”€â”€ Improve code structure, naming, duplication
â”‚   â”œâ”€â”€ Run tests again â€” confirm they STILL PASS
â”‚   â””â”€â”€ Match project conventions and patterns
â”‚
â”œâ”€â”€ 5. Mark task as complete [x] in tasks.md
â””â”€â”€ 6. Note any issues or deviations
```

Detect the test runner for execution:

```
Detect test runner from:
â”œâ”€â”€ openspec/config.yaml â†’ rules.apply.test_command (highest priority)
â”œâ”€â”€ package.json â†’ scripts.test
â”œâ”€â”€ pyproject.toml / pytest.ini â†’ pytest
â”œâ”€â”€ Makefile â†’ make test
â””â”€â”€ Fallback: report that tests couldn't be run automatically
```

**Important**: If any user coding skills are installed (e.g., `tdd/SKILL.md`, `pytest/SKILL.md`, `vitest/SKILL.md`), read and follow those skill patterns for writing tests.

### Step 2b: Implement Tasks (Standard Workflow)

When TDD is not active:

```
FOR EACH TASK:
â”œâ”€â”€ Read the task description
â”œâ”€â”€ Read relevant spec scenarios (these are your acceptance criteria)
â”œâ”€â”€ Read the design decisions (these constrain your approach)
â”œâ”€â”€ Read existing code patterns (match the project's style)
â”œâ”€â”€ Write the code
â”œâ”€â”€ Mark task as complete [x] in tasks.md
â””â”€â”€ Note any issues or deviations
```

### Step 3: Mark Tasks Complete

Update `tasks.md` â€” change `- [ ]` to `- [x]` for completed tasks:

```markdown
## Phase 1: Foundation

- [x] 1.1 Create `internal/auth/middleware.go` with JWT validation
- [x] 1.2 Add `AuthConfig` struct to `internal/config/config.go`
- [ ] 1.3 Add auth routes to `internal/server/server.go`  â† still pending
```

### Step 4: Return Summary

Return to the orchestrator:

```markdown
## Implementation Progress

**Change**: {change-name}
**Mode**: {TDD | Standard}

### Completed Tasks
- [x] {task 1.1 description}
- [x] {task 1.2 description}

### Files Changed
| File | Action | What Was Done |
|------|--------|---------------|
| `path/to/file.ext` | Created | {brief description} |
| `path/to/other.ext` | Modified | {brief description} |

### Tests (TDD mode only)
| Task | Test File | RED (fail) | GREEN (pass) | REFACTOR |
|------|-----------|------------|--------------|----------|
| 1.1 | `path/to/test.ext` | âœ… Failed as expected | âœ… Passed | âœ… Clean |
| 1.2 | `path/to/test.ext` | âœ… Failed as expected | âœ… Passed | âœ… Clean |

{Omit this section if standard mode was used.}

### Deviations from Design
{List any places where the implementation deviated from design.md and why.
If none, say "None â€” implementation matches design."}

### Issues Found
{List any problems discovered during implementation.
If none, say "None."}

### Remaining Tasks
- [ ] {next task}
- [ ] {next task}

### Status
{N}/{total} tasks complete. {Ready for next batch / Ready for verify / Blocked by X}
```

## Rules

- ALWAYS read specs before implementing â€” specs are your acceptance criteria
- ALWAYS follow the design decisions â€” don't freelance a different approach
- ALWAYS match existing code patterns and conventions in the project
- In `openspec` mode, mark tasks complete in `tasks.md` AS you go, not at the end
- If you discover the design is wrong or incomplete, NOTE IT in your return summary â€” don't silently deviate
- If a task is blocked by something unexpected, STOP and report back
- NEVER implement tasks that weren't assigned to you
- Load and follow any relevant coding skills for the project stack (e.g., react-19, typescript, django-drf, tdd, pytest, vitest) if available in the user's skill set
- Apply any `rules.apply` from `openspec/config.yaml`
- If TDD mode is detected (Step 2), ALWAYS follow the RED â†’ GREEN â†’ REFACTOR cycle â€” never skip RED (writing the failing test first)
- When running tests during TDD, run ONLY the relevant test file/suite, not the entire test suite (for speed)
- Return a structured envelope with: `status`, `executive_summary`, `detailed_report` (optional), `artifacts`, `next_recommended`, and `risks`

