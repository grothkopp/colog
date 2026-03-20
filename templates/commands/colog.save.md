# /colog:save — Save Current Work

Capture the current state of work: log what changed, update tasks, and commit.

## Usage

```
/colog:save                     # Auto-detect and log all changes
/colog:save Refactored auth     # Save with a specific description
```

## Steps

First, check `colog/project.md` → `## Git` to see if git is enabled.

**If git is enabled:**

1. **Detect changes**: Run `git status` and `git diff --stat` to see what changed
2. **Create log entries**: For each logical group of changes, prepend a [change] entry to `colog/log.md` using the shell method from the log-format skill (batch all entries into one temp file, prepend once)
3. **Update tasks**: If changes relate to open tasks in `colog/tasks.md`, mark them complete or update status
4. **Stage and commit**: `git add` relevant files, commit with message matching the log entry type and title
5. **Summary**: Tell the user what was saved

**If git is disabled:**

1. **Ask the user** what they worked on (no auto-detection without git)
2. **Create log entries**: Prepend [change] entries to `colog/log.md` using the shell method from the log-format skill
3. **Update tasks**: If changes relate to open tasks, update `colog/tasks.md`
4. **Summary**: Tell the user what was logged

## Auto-Detection

When no description is provided, look at the changed files and infer:
- New files → "Created [filename]"
- Modified files → "Updated [filename]" with a summary of the diff
- Deleted files → "Removed [filename]"

Group related changes into a single log entry when they belong together (e.g., source + test file).

## Important

- If git enabled: always show the user what will be committed before committing
- Don't auto-push — only commit locally
- If there are no changes (git) or nothing to log, say so
- If git enabled: include `colog/log.md` itself in the commit (it was just updated)
- If git disabled: still create log entries — the log works without git
