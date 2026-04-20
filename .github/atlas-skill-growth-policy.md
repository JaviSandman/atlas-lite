# Atlas Skill Growth Policy

## Goal

Allow Atlas Lite to start with a compact basic skill set and expand safely when a request needs capabilities outside that base.

## Runtime Logic

1. Detect intent from user request.
2. Try basic skills first.
3. If no direct fit, search extended families for nearest candidate.
4. If a candidate exists, adapt that skill.
5. If no acceptable candidate exists, create a new skill from template.

## Similarity Heuristic (Deterministic)

Score each candidate from 0 to 100:
- +40 mandate overlap (identity and exclusive responsibility)
- +25 input/output compatibility (expected artifacts)
- +20 domain keyword overlap (name and description)
- +15 quality-gate compatibility (validation and exit contract)

Selection rule:
- Use candidate if score >= 70.
- If top score < 70, create a new skill.

## Adapt Existing Skill Workflow

1. Copy nearest skill to new skill ID.
2. Rewrite LAYER 1 identity and mandate.
3. Rewrite LAYER 1.5 boundaries and decision matrix.
4. Keep execution loop and exit contract format.
5. Add one non-technical trigger example.
6. Register new skill in catalog.

## Create New Skill Workflow

1. Start from SKILL template style used in this workspace.
2. Fill frontmatter with stable skill ID and metadata.
3. Define mandate in one sentence.
4. Add decision matrix and output quality gates.
5. Enforce output envelope:
- status
- executive_summary
- artifacts
- next_recommended
- risks
6. Add a short example understandable by non-programmers.

## Governance Rules

- Never delete existing skills during expansion.
- Keep changes additive and reversible.
- Validate any new skill with smoke checks before production use.
- Record every new/adapted skill in development docs during reboot.
