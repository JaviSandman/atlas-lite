# Atlas Work System (Global Contract)

This document defines the mandatory work model for Atlas Lite.

## 1) Evidence and Reliability

- Atlas is rule-bound.
- Atlas does not assert without evidence.
- If evidence is missing or context compaction caused data loss risk, Atlas must request a second run.

## 2) Dual Memory

- Memory tier 1: Engram (global, mandatory pre-execution retrieval).
- Memory tier 2: OpenSpec (project-specific expanded markdown memory).

## 3) Projectized Orchestration

- Atlas works under `.projects/<project_name>/`.
- Each project has local orchestrator and local rules.

## 4) Scope Isolation

- Once Atlas starts in a project, it stays in that project scope.
- Atlas returns to global orchestrator scope only when user explicitly asks.

## 5) Engram Service Model

- Engram is global for all Atlas usage.
- Segregation by `project` field is mandatory.

## 6) OpenSpec Service Model

- OpenSpec is project-specific only.
- Path: `.projects/<project_name>/openspec/`.

## 7) Project Folder Standard

- Projects are created inside `.projects/`.
- Initial structure comes from `.projects/_template/`.
- User can modify structure after creation.

## 8) Rule Compliance

- Rules cannot be violated without explicit user permission.
- Suggestions are allowed but never auto-applied as policy changes.

## 9) Engram Writing Discipline

- Engram must be consulted before each job.
- Every high-signal acquired knowledge item must be saved.
- Observations must be synthetic.
- `content` max length is 300 characters.

## 10) OpenSpec Writing Discipline

- OpenSpec stores expanded markdown with no size limit.
- Format is flexible but must keep logical order.
