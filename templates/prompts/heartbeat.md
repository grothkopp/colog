# Prompt: Heartbeat

> Schedule: Every N minutes during working hours (configured during /colog:setup)
> Default: Every 30 minutes, 08:00-18:00, weekdays
> Skills: git, task-management, memory

## Purpose

Regular check-in to keep the git log and task list in sync with team activity.

## Working Hours

This prompt should only run during the team's configured working hours.
Check `colog/project.md` for the schedule configuration. If outside working
hours, do nothing and exit silently.

## Steps

1. **Read current user** — `colog/me.md` for @Shortcut, name, and email (if missing, use @Agent). Use `--author="First Last <email>"` on all commits.
2. **Gather context** — Read recent conversations since last heartbeat
3. **Check for loggable events** and commit them:
   - New tasks mentioned? → `task(subject): description @user` commit + add to tasks.md
   - Decisions made? → `decision(subject): description @user` commit
   - Files changed? → `change(subject): description @user` commit with files
   - Questions asked? → `note(subject): question @user` empty commit
   - New information? → `note(subject): description @user` commit, optionally update memory.md
4. **Commit smart** — Log when it makes sense:
   - If a question was asked mid-work, commit just the question as an empty commit.
     Don't bundle it with unrelated file changes.
   - If larger changes are complete, stage all relevant files and commit together.
   - One commit per logical event.
5. **Notify** — Only message the team if something requires their attention.
   Do NOT send "nothing to report" messages.

## Files

- Me: `colog/me.md` (current user identity, local)
- Tasks: `colog/tasks.md`
- Project: `colog/project.md` (for team info + schedule)
- Memory: `colog/memory.md` (optional)

## Important

- This runs automatically — be efficient and quiet
- Only speak up when there is something actionable or noteworthy
- When in doubt, commit silently and let the morning briefing surface it
- Respect working hours — no notifications outside configured times
- The git log IS the project log — every commit is a log entry
