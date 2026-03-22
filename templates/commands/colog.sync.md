# /colog:sync — Sync Everything

> Paths, identity method, and conversation source: see CLAUDE.md → Configuration

The central orchestrator. Pulls latest changes, detects and logs events from
conversations, saves file changes, syncs tasks, and pushes. This is what the
heartbeat calls on schedule — it handles the full sync cycle.

## Usage

```
/colog:sync                     # Full sync cycle
/colog:sync tasks               # Only sync tasks.md ↔ git
/colog:sync pull                # Only pull from remote
/colog:sync --buffer 5m         # Skip events newer than 5 minutes
```

## Buffer Parameter

When called from a scheduled heartbeat, use `--buffer` to avoid processing
events that the agent might still be handling in real-time. The buffer skips
conversations and events newer than the specified duration.

- **Default (manual)**: no buffer — process everything
- **Recommended for heartbeat**: `--buffer 5m` — skip last 5 minutes
- This prevents the heartbeat from logging events that the agent is about to
  log itself as part of the current conversation

## Steps

1. **Read identity** — `colog/me.md` for @Shortcut, name, email.

2. **Pull from remote** (unless `tasks` only):
   - Check if a remote exists: `git remote -v`
   - If yes: `git pull --rebase` to get latest changes
   - Handle conflicts if any (prefer theirs for tasks.md, ours for code)

3. **Detect and log events** (unless `tasks` or `pull` only):
   - Read recent conversations/activity since last sync
   - For each loggable event, use `/colog:log` to create the commit:
     - New tasks mentioned → `/colog:log` (type: task)
     - Decisions made → `/colog:log` (type: decision)
     - Questions asked → `/colog:log` (type: note)
     - New information → `/colog:log` (type: note), optionally update memory.md
   - One commit per logical event — don't bundle unrelated things

4. **Save file changes** (unless `tasks` or `pull` only):
   - If there are uncommitted file changes, use `/colog:save` to commit them
     with semantic messages

5. **Sync tasks** — Two-way sync between `colog/tasks.md` and git:

   **a) Detect manually completed tasks (tasks.md → git)**
   - Find tasks checked off (`- [x]`) that have no matching completion commit
   - Check: `git log --oneline --grep="closes COMMIT_ID"` — if no result, needs sync
   - Use `/colog:log` to create the completion commit

   **b) Detect manually added tasks (tasks.md → git)**
   - Find `- [ ]` lines without a 7-char hex commit reference
   - Deduplicate: search `git log --oneline --grep="task("` for matching description
   - If genuinely new: use `/colog:log` to create the task commit
   - Update the task line in tasks.md with the new commit's short ID

   **c) Detect untracked commits (git → tasks.md)**
   - Find `task()` commits not reflected in tasks.md
   - For new tasks: add `- [ ]` entry with commit reference
   - For completions (`closes XXXX`): mark the referenced task as `- [x]`

   **d) Commit sync changes**
   - If tasks.md was modified: `change(tasks): sync task status @user`

6. **Push to remote** (if remote exists and there are unpushed commits):
   - `git push` to share changes

7. **Notify** — Only message the team if something requires their attention.
   Do NOT send "nothing to report" messages.

## Important

- This command is safe to run frequently — it's idempotent
- Delegates to `/colog:log` for all commit creation, `/colog:save` for file changes
- The heartbeat is just a scheduled trigger for this command
- Can also be invoked manually at any time
