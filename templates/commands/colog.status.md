# /colog:status — Project Overview

Show a quick overview of the current project state.

## Usage

```
/colog:status
```

## Steps

1. **Read project info**: `colog/project.md` for team and description
2. **Open tasks**: `colog/tasks.md` — list open tasks grouped by owner
3. **Recent activity**: Last 5-10 entries from `colog/log.md` — use `awk '/^---$/{c++} c>=10{exit} {print}' colog/log.md` (NEVER read the whole file)
4. **Git status** (only if git enabled in project.md → `## Git`): uncommitted changes, unpushed commits
5. **Format as a concise summary**

## Output Format

```
**Project:** [name]
**Team:** @SG, @NR, @AP

**Open Tasks** (N)
@SG: task1, task2
@NR: task3
Unassigned: task4

**Recent Activity**
- [decision] Title (2h ago)
- [change] Title (yesterday)
- [task] Title (2 days ago)

**Git:** 3 uncommitted files, 2 unpushed commits  ← only if git enabled
```

## Important

- Keep it brief — this is a quick glance, not a deep dive
- Use relative times ("2h ago", "yesterday") not absolute timestamps
- If there's nothing noteworthy, say "All clear"
