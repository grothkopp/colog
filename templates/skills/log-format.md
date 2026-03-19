# Skill: Log Format

Rules for writing entries in the unified log at `collalog/log.md`.

## Entry Types

| Type | Use for |
|------|---------|
| change | File created, modified, deleted |
| decision | Direction chosen, convention agreed, scope changed |
| task | Task created, completed, reassigned, blocked |
| idea | Proposal, suggestion, something to explore |
| note | Context, observation, meeting summary |
| milestone | Phase completed, goal reached, release |

## Entry Format

```markdown
### YYYY-MM-DD HH:MM — @Shortcut [type]

**Short Title**

Description of what happened, was decided, or changed.

- *Affected files:* `path/to/file` (optional)
- *Related:* TASK-NNN or previous entry (optional)

---
```

## Current User

Read `collalog/me.md` to determine the `@Shortcut` for log entries. If the file
doesn't exist (shared agent or not yet set up), use `@Agent` as the shortcut.

## Rules

- Newest entries at the top
- If git is enabled (check `collalog/project.md` → `## Git`): every log entry gets a git commit (use entry type as commit type). If git is disabled: skip commits.
- The @Shortcut in the header comes from `collalog/me.md`
- Be specific and factual — the log is the project's memory
- Keep entries concise: 2-5 lines of description
- Include enough context for someone reading in 3 months
- When a decision is revisited, add a new entry referencing the original
- Tasks in the log are also reflected in `collalog/tasks.md`
