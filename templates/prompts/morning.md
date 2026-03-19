# Prompt: Morning Briefing

> Schedule: Daily at configured time, weekdays (configured during /collalog:setup)
> Default: 08:00, weekdays
> Skills: log-format, task-management, git

## Purpose

Start the day with a clear picture of what's happening and what needs attention.

## Steps

1. **Clean up tasks** — Remove completed tasks (`- [x]`) from `collalog/tasks.md`. They are already preserved in the log.
2. **Read project context** — `collalog/project.md` for team and goals
3. **Collect open tasks** — `collalog/tasks.md`, group by owner
4. **Read recent log entries** — Last 24-48h from `collalog/log.md`
5. **Check git activity** — `git log --oneline --since="24 hours ago"`
6. **Commit** cleanup changes if any tasks were removed
7. **Send summary** to the team:

```
Good morning! Here's today's overview:

**Open Tasks**
@Person1: [list their tasks]
@Person2: [list their tasks]
Unassigned: [list if any]

**Recent Activity** (last 24h from the log)
- [decisions, changes, ideas worth highlighting]

**Upcoming**
- [deadlines, milestones, or blockers]
```

## Important

- Keep it concise — 30 seconds to read
- Skip sections with nothing to report
- Flag overdue or blocked tasks explicitly
- If everything is quiet, send a short "all clear" instead
