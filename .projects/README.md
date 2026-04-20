# .projects Workspace Model

Atlas Lite works by project under `.projects/`.

## Rules

1. Each project has isolated scope.
2. Each project includes local orchestrator and local rules.
3. Atlas remains in project scope until user asks to return global.
4. Engram is global service (segregated by `project` field).
5. OpenSpec is project-specific and stored inside each project folder.

## Structure

- `.projects/_template/` standard starter structure
- `.projects/<project_name>/` project instances created from template
