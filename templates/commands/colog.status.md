# /colog:status — Project Overview

> Paths and identity method: see CLAUDE.md → Configuration

Show a summary of the project state, optionally scoped to a time range.

## Usage

```
/colog:status                   # Open tasks + last 24h activity
/colog:status open              # Uncommitted changes and unpushed work
/colog:status last week         # Activity from the last 7 days
/colog:status 2026-03-01..now   # Activity since a specific date
```

## Parameters

- No parameter → open tasks + last 24h of activity (default for daily briefing)
- `open` → uncommitted file changes, unstaged work, unpushed commits
- `today` → since midnight
- `last week` / `last 7 days` → last 7 days
- `YYYY-MM-DD..now` → since a specific date
- `YYYY-MM-DD..YYYY-MM-DD` → specific date range

## Steps

1. **Read project info**: `colog/project.md` for team and description
2. **Read current user**: `colog/me.md` for @Shortcut

### Default (no parameter / time range)

3. **Open tasks**: `colog/tasks.md` — list open tasks grouped by owner
   - Highlight overdue tasks (due date in the past)
   - Flag blocked tasks
4. **Activity**: `git log --since="RANGE" --format="%h %s (%ar)"` for commits in range
   - Group by type: decisions, tasks completed, changes, ideas, notes
   - Show count per user
   - **Cluster related commits**: When multiple commits share the same subject
     (e.g., 12× `change(slides): ...`), collapse them into one summary line
     like "slides: 12 changes by @SG" instead of listing each individually.
     Only show individual entries for subjects with ≤3 commits or for
     decisions/milestones (which are always listed individually).
5. **Format as a concise summary**

### `open` parameter

3. **Uncommitted changes**: `git status` — modified, staged, untracked files
4. **Unpushed commits**: `git log @{u}..HEAD --oneline` (if remote exists)
5. **Unstaged file changes**: `git diff --stat`

## Output Format (default)

```
Project: [name]
Team: @SG, @NR, @AP

Open Tasks (N)
@SG: task1, task2
@NR: task3
Unassigned: task4

Activity (last 24h, N commits)
  Decisions: 2  |  Tasks completed: 3  |  Changes: 8
  Most active: @SG (7), @NR (4)

  Topics:
  - slides: 12 changes by @SG
  - colog: 3 changes by @SG
  - decision(db): use PostgreSQL @SG (2h ago)
  - decision(api): switch to REST @NR (5h ago)
  - change(auth): add JWT refresh @NR (yesterday)
```

## Important

- Keep it brief — this is a quick glance, not a deep dive
- Use relative times ("2h ago", "yesterday") not absolute timestamps
- If there's nothing noteworthy, say "All clear"
- With a time range, focus on the activity section; tasks are always current state
- The morning briefing uses `/colog:status` (default = last 24h)
