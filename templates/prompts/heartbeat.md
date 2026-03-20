# Prompt: Heartbeat

> Schedule: Every N minutes during working hours (configured during /colog:setup)
> Default: Every 30 minutes, 08:00-18:00, weekdays
> Skills: log-format, task-management, memory, git

## Purpose

Regular check-in to keep the unified log and task list in sync with team activity.

## Working Hours

This prompt should only run during the team's configured working hours.
Check `colog/project.md` for the schedule configuration. If outside working
hours, do nothing and exit silently.

## Steps

1. **Read current user** — `colog/me.md` for the @Shortcut to use in log entries (if missing, use @Agent)
2. **Gather context** — Read recent conversations since last heartbeat
3. **Check for updates:**
   - New tasks mentioned? -> Add to `colog/tasks.md` + log entry [task]
   - Decisions made? -> Log entry [decision]
   - Files changed? -> Log entry [change]
   - New information? -> Log entry [note] and optionally update `colog/memory.md`
4. **Update the log** — Prepend entries to `colog/log.md` using the shell method from the log-format skill (temp file + cat, NEVER read and rewrite the whole file). Batch all entries from this heartbeat into one prepend operation.
5. **Commit** — If files changed AND git is enabled (check `colog/project.md` → `## Git`): commit to git (skill: git). If git disabled: skip.
6. **Notify** — Only message the team if something requires their attention
   - Do NOT send "nothing to report" messages

## Files

- Me: `colog/me.md` (current user identity, local)
- Log: `colog/log.md`
- Tasks: `colog/tasks.md`
- Project: `colog/project.md` (for team info + schedule)
- Memory: `colog/memory.md` (optional)

## Important

- This runs automatically — be efficient and quiet
- Only speak up when there is something actionable or noteworthy
- When in doubt, log silently and let the morning briefing surface it
- Respect working hours — no notifications outside configured times
