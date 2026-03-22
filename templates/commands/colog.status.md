# /colog:status — Project Overview

Show a summary of the project state, optionally scoped to a time range.

## Usage

```
/colog:status                   # Current state: open tasks, recent activity (48h)
/colog:status yesterday         # Activity from the last 24 hours
/colog:status last week         # Activity from the last 7 days
/colog:status 2026-03-01..now   # Activity since a specific date
```

## Parameters

The optional time range determines which git history to include:
- No parameter → current state + last 48h activity
- `today` → since midnight
- `yesterday` / `last 24h` → last 24 hours
- `last week` / `last 7 days` → last 7 days
- `YYYY-MM-DD..now` → since a specific date
- `YYYY-MM-DD..YYYY-MM-DD` → specific date range

## Steps

1. **Read project info**: `colog/project.md` for team and description
2. **Read current user**: `colog/me.md` for @Shortcut
3. **Open tasks**: `colog/tasks.md` — list open tasks grouped by owner
   - Highlight overdue tasks (due date in the past)
   - Flag blocked tasks
4. **Activity**: `git log --since="RANGE" --format="%h %s (%ar)"` for commits in range
   - Group by type: decisions, tasks completed, changes, ideas, notes
   - Show count per user
5. **Git status**: uncommitted changes, unpushed commits
6. **Format as a concise summary**

## Output Format

```
Project: [name]
Team: @SG, @NR, @AP

Open Tasks (N)
@SG: task1, task2
@NR: task3
Unassigned: task4

Activity [range description] (N commits)
  Decisions: 2  |  Tasks completed: 3  |  Changes: 8
  Most active: @SG (7), @NR (4)

  Recent:
  - abc1234 decision(db): use PostgreSQL @SG (2h ago)
  - def5678 change(api): add rate limiting @NR (yesterday)

Git: 3 uncommitted files, 2 unpushed commits
```

## Important

- Keep it brief — this is a quick glance, not a deep dive
- Use relative times ("2h ago", "yesterday") not absolute timestamps
- If there's nothing noteworthy, say "All clear"
- With a time range, focus on the activity section; tasks are always current state
- The morning briefing uses `/colog:status yesterday` as its data source
