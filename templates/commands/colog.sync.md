# /colog:sync — Sync Repository and Tasks

Pull latest changes, sync tasks between `colog/tasks.md` and git, and commit
any pending events.

## Usage

```
/colog:sync                     # Full sync: pull, tasks, events
/colog:sync tasks               # Only sync tasks.md ↔ git
/colog:sync pull                # Only pull from remote
```

## Steps

1. **Read identity** — `colog/me.md` for @Shortcut, name, email.
   Use `--author="First Last <email>"` on all commits.

2. **Pull from remote** (unless `tasks` only):
   - Check if a remote exists: `git remote -v`
   - If yes: `git pull --rebase` to get latest changes
   - Handle conflicts if any (prefer theirs for tasks.md, ours for code)

3. **Sync tasks** — Two-way sync between `colog/tasks.md` and git:

   **a) Detect manually completed tasks (tasks.md → git)**
   - Find tasks checked off (`- [x]`) that have no matching completion commit
   - Check: `git log --oneline --grep="closes COMMIT_ID"` — if no result, needs sync
   - Create completion commit: `task(subject): completed - description (closes COMMIT_ID) @user`

   **b) Detect manually added tasks (tasks.md → git)**
   - Find `- [ ]` lines without a 7-char hex commit reference
   - Deduplicate: search `git log --oneline --grep="task("` for matching description
   - If genuinely new: `git commit --allow-empty --author="..." -m "task(subject): description @user"`
   - Update the task line in tasks.md with the new commit's short ID

   **c) Detect untracked commits (git → tasks.md)**
   - Find `task()` commits not reflected in tasks.md
   - For new tasks: add `- [ ]` entry with commit reference
   - For completions (`closes XXXX`): mark the referenced task as `- [x]`

   **d) Commit sync changes**
   - If tasks.md was modified: `change(tasks): sync task status @user`

4. **Check for uncommitted work** (unless `tasks` only):
   - `git status` — if there are staged or modified files, notify the user
   - Do NOT auto-commit code changes (that's what `/colog:save` is for)

5. **Push to remote** (if remote exists and there are unpushed commits):
   - `git push` to share changes

## Important

- This command is safe to run frequently — it's idempotent
- Task sync is the core function; pull/push are convenience wrappers
- Never auto-commit code changes — only task metadata and empty commits
- The heartbeat calls this command automatically on schedule
- Can also be invoked manually at any time
