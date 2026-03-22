# Prompt: Morning Briefing

> Paths, identity, and schedule: see CLAUDE.md → Configuration
> Default schedule: 08:00, weekdays
> Skills: git, task-management

## Purpose

Start the day with a clear picture of what's happening and what needs attention.
This prompt is also a template — users can customize it for their own schedule.

## Steps

1. **Sync first** — Run `/colog:sync` to pull latest changes and sync tasks
2. **Clean up tasks** — Remove completed tasks (`- [x]`) from `colog/tasks.md`.
   They are preserved in git history. Use `/colog:save` to commit the cleanup.
3. **Get status** — Run `/colog:status` to collect the daily overview (default = last 24h)
4. **Format the briefing** — Structure the status output for the team:

```
Good morning! Here's today's overview:

**Your Tasks** (@CurrentUser)
- [ ] task1 (due: today)
- [ ] task2

**Team Tasks**
@Person2: task3, task4
Unassigned: task5

**Yesterday's Activity** (N commits)
- abc1234 decision(db): use PostgreSQL @SG (yesterday)
- def5678 change(api): add rate limiting @NR (18h ago)

**Heads Up**
- [overdue tasks, blocked items, upcoming deadlines]
```

5. **Send summary** to the team

## Important

- Keep it concise — 30 seconds to read
- Skip sections with nothing to report
- Flag overdue or blocked tasks explicitly
- Highlight the current user's tasks first
- If everything is quiet, send a short "all clear" instead
- Delegates to `/colog:sync`, `/colog:status`, and `/colog:save` — never duplicates their logic
