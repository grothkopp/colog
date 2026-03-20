# Skill: Task Management

Rules for maintaining the task snapshot at `colog/tasks.md`.

The task list is a live snapshot derived from log entries of type [task].
It shows what's open, who owns it, and what's blocked.

## Task Format

Every task has a `created` timestamp. Completed tasks also get a `completed` timestamp.
This makes it easy to correlate tasks with log entries without searching the full log.

```markdown
- [ ] Task description (@Owner, created: 2026-03-19 14:00, due: 2026-03-25)
- [x] Completed task (@Owner, created: 2026-03-18 10:00, completed: 2026-03-19 16:30)
```

Minimal format (created is always required):

```markdown
- [ ] Fix login bug (@SG, created: 2026-03-19 09:00)
- [ ] Research caching options (@NR, created: 2026-03-19 14:00, blocked by: DB decision)
- [x] Write project brief (@SG, created: 2026-03-18 10:00, completed: 2026-03-19 11:00)
```

## Current User

Read `colog/me.md` for the current user's shortcut. When the user creates
a task without specifying an owner, default to the shortcut from me.md.
If me.md doesn't exist, ask explicitly or leave unassigned.

## Rules

- Every task has a `created` timestamp (YYYY-MM-DD HH:MM)
- Completed tasks always have a `completed` timestamp
- Every task change gets a log entry (type: task) AND an update to tasks.md
- Keep task descriptions actionable — start with a verb
- Always assign an owner when possible (default: current user from me.md)
- Mark blocked tasks with `blocked by:` and the dependency
- Update "Last updated" whenever the file changes
- The morning briefing removes completed tasks (they live on in the log)
- Group tasks under headings that fit the project
