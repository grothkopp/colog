# Skill: Task Management

Manage the task snapshot at `collalog/tasks.md`.

Tasks originate from the unified log (`collalog/log.md`, type: task). The task list
is a living snapshot — a quick-reference view of what's open, who owns it, and what's done.

## Task Format

```markdown
- [ ] Task description (@Owner, due date or context)
- [x] Completed task (@Owner, completed YYYY-MM-DD)
```

## Categories

Organize under headings that fit the project. Common categories:

- **Setup** — Initial project configuration
- **Content** — Writing, creating deliverables
- **Research** — Investigation, data gathering
- **Tech** — Tooling, infrastructure, code

## Workflow

1. When a task is mentioned in conversation or the log → add to task list + log entry [task]
2. When a task is completed → check it off in task list + log entry [task]
3. When a task is blocked → note the blocker in the task list + log entry [note]

## Example

```markdown
# Tasks — ProjectName

> Last updated: 2026-03-19

## Content
- [ ] Write project brief (@SG, due 2026-03-25)
- [ ] Review competitor analysis (@NR)
- [x] Create slide deck outline (@SG, completed 2026-03-19)

## Tech
- [ ] Set up CI/CD pipeline (@AP, blocked by: hosting decision)
```

## Rules

- Every task change also gets a log entry (type: task)
- Keep task descriptions actionable — start with a verb
- Always assign an owner when possible
- Mark blocked tasks with `blocked by:` and what they depend on
- Update "Last updated" whenever the file changes
- Remove completed tasks after 2 weeks (they live on in the log)
