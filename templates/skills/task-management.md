# Skill: Task Management

Rules for maintaining the task snapshot at `colog/tasks.md`.

The task list is a live snapshot of open work. Tasks are created and completed
via `task()` commits in git. The tasks.md file is the readable view.

## Task Format

Every task references the commit that created it via short ID.
Completed tasks also reference the completing commit.

```markdown
- [ ] Task description (@Owner, created: 2026-03-19, abc1234)
- [x] Completed task (@Owner, created: 2026-03-18, def5678, completed: 2026-03-19, 90ab12)
```

Minimal format:

```markdown
- [ ] Fix login bug (@SG, created: 2026-03-19, abc1234)
- [ ] Research caching options (@NR, created: 2026-03-19, def5678, blocked by: DB decision)
```

## Current User

Read `colog/me.md` for the current user's shortcut. When the user creates
a task without specifying an owner, default to the shortcut from me.md.
If me.md doesn't exist, ask explicitly or leave unassigned.

## Creating a Task

1. Create a commit: `git commit --allow-empty -m "task(subject): description @user"`
2. Get the short commit ID: `git rev-parse --short HEAD`
3. Add the task to `colog/tasks.md` with the commit reference
4. Commit the tasks.md update: `change(tasks): add task - description @user`

## Completing a Task

1. Do the work and commit with the task type: `task(subject): completed - description (closes abc1234) @user`
2. Get the completing commit ID
3. Update tasks.md: change `- [ ]` to `- [x]`, add `completed:` date and commit ID
4. Commit tasks.md update

## Rules

- Every task has a `created` date (YYYY-MM-DD) and commit short ID
- Completed tasks have a `completed` date and completing commit ID
- Keep task descriptions actionable — start with a verb
- Always assign an owner when possible (default: current user from me.md)
- Mark blocked tasks with `blocked by:` and the dependency
- Update "Last updated" whenever the file changes
- The morning briefing removes completed tasks (they live on in git history)
- Group tasks under headings that fit the project
