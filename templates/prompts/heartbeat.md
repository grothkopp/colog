# Prompt: Heartbeat

> Schedule: Every 30 minutes during working hours
> Skills: log, task-management, memory, git

## Purpose

Regular check-in to keep the unified log and task list in sync with team activity.

## Steps

1. **Gather context** — Read recent conversations since last heartbeat
2. **Check for updates:**
   - New tasks mentioned? -> Add to `collalog/tasks.md` + log entry [task]
   - Decisions made? -> Log entry [decision]
   - Files changed? -> Log entry [change]
   - New information? -> Log entry [note] and optionally update `collalog/memory.md`
3. **Update the log** — Add entries to `collalog/log.md` (newest first)
4. **Commit** — If files changed, commit to git (skill: git)
5. **Notify** — Only message the team if something requires their attention
   - Do NOT send "nothing to report" messages

## Files

- Log: `collalog/log.md`
- Tasks: `collalog/tasks.md`
- Project: `collalog/project.md`
- Memory: `collalog/memory.md` (optional)

## Important

- This runs automatically — be efficient and quiet
- Only speak up when there is something actionable or noteworthy
- When in doubt, log silently and let the morning briefing surface it
