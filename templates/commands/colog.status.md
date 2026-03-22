# /colog:status — Project Overview

Show a quick overview of the current project state.

## Usage

```
/colog:status
```

## Steps

1. **Read project info**: `colog/project.md` for team and description
2. **Open tasks**: `colog/tasks.md` — list open tasks grouped by owner
3. **Recent activity**: `git log --since="48 hours ago" --format="%h %s (%ar)"` for recent commits
4. **Git status**: uncommitted changes, unpushed commits
5. **Format as a concise summary**

## Output Format

```
**Project:** [name]
**Team:** @SG, @NR, @AP

**Open Tasks** (N)
@SG: task1, task2
@NR: task3
Unassigned: task4

**Recent Activity** (last 48h)
- abc1234 decision(db): use PostgreSQL @SG (2h ago)
- def5678 change(api): add rate limiting @NR (yesterday)

**Git:** 3 uncommitted files, 2 unpushed commits
```

## Important

- Keep it brief — this is a quick glance, not a deep dive
- Use relative times ("2h ago", "yesterday") not absolute timestamps
- If there's nothing noteworthy, say "All clear"
