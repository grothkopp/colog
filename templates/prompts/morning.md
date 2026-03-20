# Prompt: Morning Briefing

> Schedule: Daily at configured time, weekdays (configured during /colog:setup)
> Default: 08:00, weekdays
> Skills: log-format, task-management, git

## Purpose

Start the day with a clear picture of what's happening and what needs attention.

## Steps

1. **Clean up tasks** — Remove completed tasks (`- [x]`) from `colog/tasks.md`. They are already preserved in the log.
2. **Read project context** — `colog/project.md` for team and goals
3. **Read current user** — `colog/me.md` for the current user's shortcut (highlight their tasks first)
4. **Collect open tasks** — `colog/tasks.md`, group by owner (current user first)
5. **Read recent log entries** — Last 24-48h from `colog/log.md` using awk: `awk '/^### (YYYY-MM-DD|YYYY-MM-DD)/,/^---$/' colog/log.md` (substitute actual dates, NEVER read the whole file)
6. **Check git activity** (only if git enabled in `colog/project.md` → `## Git`) — `git log --oneline --since="24 hours ago"`
7. **Commit** cleanup changes if any tasks were removed (only if git enabled)
8. **Send summary** to the team:

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
