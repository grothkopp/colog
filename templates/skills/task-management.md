# Skill: Task Management

Rules for maintaining the task snapshot at `colog/tasks.md`.

The task list is a live snapshot of open work. Tasks are created and completed
via `task()` commits in git. The tasks.md file is the readable view.

## Task Format

Every task references the commit that created it via short ID.
Completed tasks also reference the completing commit.

```markdown
- [ ] Task description (@Owner, created: 2026-03-19, abc1234)
- [x] Completed task (@Owner, created: 2026-03-18, def5678, completed: 2026-03-19, 90ab12)
```

Minimal format:

```markdown
- [ ] Fix login bug (@SG, created: 2026-03-19, abc1234)
- [ ] Research caching options (@NR, created: 2026-03-19, def5678, blocked by: DB decision)
```

## Current User

Read `colog/me.md` for the current user's shortcut. When the user creates
a task without specifying an owner, default to the shortcut from me.md.
If me.md doesn't exist, ask explicitly or leave unassigned.

## Creating a Task

1. Create a commit: `git commit --allow-empty -m "task(subject): description @user"`
2. Get the short commit ID: `git rev-parse --short HEAD`
3. Add the task to `colog/tasks.md` with the commit reference
4. Commit the tasks.md update: `change(tasks): add task - description @user`

## Completing a Task

1. Do the work and commit with the task type: `task(subject): completed - description (closes abc1234) @user`
2. Get the completing commit ID
3. Update tasks.md: change `- [ ]` to `- [x]`, add `completed:` date and commit ID
4. Commit tasks.md update

## Two-Way Sync

Git and tasks.md must always be in sync. The heartbeat enforces this:

### tasks.md → Git (manual completions)

When someone checks off a task directly in tasks.md (`- [ ]` → `- [x]`), the
heartbeat detects the mismatch: a completed checkbox without a matching
`task(...): completed` commit. It then:

1. Identifies the original task commit via the stored short ID (e.g., `abc1234`)
2. Creates a completion commit: `task(subject): completed - description (closes abc1234) @user`
3. Updates the task in tasks.md with the completion commit ID and date
4. Commits: `change(tasks): sync completion - description @user`

### tasks.md → Git (manually added tasks)

When someone adds a new task directly in tasks.md without going through the agent,
it will have no commit reference (no short ID at the end). The heartbeat detects this
and creates the corresponding git commit:

1. Find tasks without a commit reference: `- [ ]` lines that have no short ID in parentheses
2. Deduplicate: check git log for a matching `task()` commit (compare description text)
   to avoid creating duplicates when someone just deleted the reference accidentally
3. If genuinely new: create a commit: `task(subject): description @user`
4. Update the task in tasks.md with the new commit's short ID and created date
5. Commit: `change(tasks): sync new task from tasks.md - description @user`

### Git → tasks.md (commits without tasks.md entry)

When a `task()` commit exists but tasks.md doesn't reflect it, the heartbeat:

1. For new tasks: adds `- [ ]` entry with commit reference
2. For completions (commits with `closes XXXX`): marks the referenced task as `- [x]`
3. Commits the tasks.md update

### How to detect sync gaps

Compare tasks.md checkboxes against git log:

```bash
# Find all task completion commits
git log --oneline --grep="^task(" --grep="completed" --all-match

# Checked boxes without a completing commit ID = needs completion sync
grep '- \[x\]' colog/tasks.md | grep -v 'completed:'

# Open tasks without ANY commit reference = manually added, needs creation sync
grep '- \[ \]' colog/tasks.md | grep -vP '\b[0-9a-f]{7}\b'
```

A checked task without a `completed:` date and commit ID = needs a completion commit.
An open task without any 7-char hex ID = manually added, needs a creation commit.

## Rules

- Every task has a `created` date (YYYY-MM-DD) and commit short ID
- Completed tasks have a `completed` date and completing commit ID
- Keep task descriptions actionable — start with a verb
- Always assign an owner when possible (default: current user from me.md)
- Mark blocked tasks with `blocked by:` and the dependency
- Update "Last updated" whenever the file changes
- The morning briefing removes completed tasks (they live on in git history)
- Group tasks under headings that fit the project
