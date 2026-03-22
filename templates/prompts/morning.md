# Prompt: Morning Briefing

> Schedule: Daily at configured time, weekdays (configured during /colog:setup)
> Default: 08:00, weekdays
> Skills: git, task-management

## Purpose

Start the day with a clear picture of what's happening and what needs attention.

## Steps

1. **Clean up tasks** — Remove completed tasks (`- [x]`) from `colog/tasks.md`.
   They are preserved in git history.
2. **Read project context** — `colog/project.md` for team and goals
3. **Read current user** — `colog/me.md` for the current user's shortcut
   (highlight their tasks first)
4. **Collect open tasks** — `colog/tasks.md`, group by owner (current user first)
5. **Read recent activity** — `git log --since="24 hours ago" --format="%h %s (%ar)"`
6. **Commit** cleanup changes if any tasks were removed:
   `change(tasks): morning cleanup - remove completed tasks @Agent`
7. **Send summary** to the team:

```
Good morning! Here's today's overview:

**Open Tasks**
@Person1: [list their tasks]
@Person2: [list their tasks]
Unassigned: [list if any]

**Recent Activity** (last 24h)
- abc1234 decision(db): use PostgreSQL @SG (yesterday)
- def5678 change(api): add rate limiting @NR (18h ago)

**Upcoming**
- [deadlines, milestones, or blockers]
```

## Important

- Keep it concise — 30 seconds to read
- Skip sections with nothing to report
- Flag overdue or blocked tasks explicitly
- If everything is quiet, send a short "all clear" instead
