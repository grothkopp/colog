# Skill: Unified Log

The central log at `collalog/log.md` is the single source of truth for all project activity.

Every meaningful event gets a log entry. The log is append-at-top: newest entries first.

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

- *Affected files:* `path/to/file` (optional, for changes)
- *Related:* TASK-NNN or ADR-NNN (optional, for cross-references)

---
```

## Examples

```markdown
### 2026-03-19 15:30 — @SG [decision]

**Use PostgreSQL for primary database**

Chose PostgreSQL over MongoDB. Relational data model fits better,
team has more experience, and tooling support is stronger.
Considered: PostgreSQL, MongoDB, SQLite.

- *Related:* TASK-003

---

### 2026-03-19 14:00 — @NR [task]

**Research competitor pricing models**

Added to backlog. Priority: high. Assigned to @NR, due 2026-03-25.

---

### 2026-03-19 10:00 — @SG [change]

**Updated project README with setup instructions**

Added quick start guide, prerequisites, and development workflow.

- *Affected files:* `README.md`

---

### 2026-03-19 09:15 — @AP [idea]

**Consider WebSocket support for real-time updates**

Could improve UX for collaborative editing. Needs investigation
before committing. Would affect architecture significantly.

---

### 2026-03-19 09:00 — @SG [milestone]

**Project kickoff completed**

Team aligned on vision, roles assigned, initial task list created.
First sprint starts Monday.

---
```

## Rules

- Every log entry gets a git commit (use the entry type as commit type)
- Be specific and factual — the log is the project's memory
- Include enough context that someone reading it in 3 months understands what happened
- The tasks list (`collalog/tasks.md`) is a snapshot derived from the log
- When a decision is revisited, add a new entry referencing the original
- Keep entries concise — aim for 2-5 lines of description
