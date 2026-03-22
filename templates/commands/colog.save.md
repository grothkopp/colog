# /colog:save — Save Current Work

Capture the current state of work: commit changes with semantic messages, update tasks.

## Usage

```
/colog:save                     # Auto-detect and commit all changes
/colog:save Refactored auth     # Save with a specific description
```

## Steps

1. **Read identity**: `colog/me.md` for @Shortcut, name, and email (for `--author`)
2. **Detect changes**: Run `git status` and `git diff --stat`
3. **Group changes**: Cluster related files into logical commits
4. **Update tasks**: If changes relate to open tasks in `colog/tasks.md`, mark them complete
5. **Show the user** what will be committed
6. **Commit**: Create semantic commits for each logical group (use `--author="First Last <email>"` from me.md)
7. **Summary**: Tell the user what was saved

## Auto-Detection

When no description is provided, look at the changed files and infer:
- New files → `change(area): create [filename] @user`
- Modified files → `change(area): update [filename] @user`
- Deleted files → `change(area): remove [filename] @user`

Group related changes into a single commit when they belong together
(e.g., source + test file → one commit).

## Important

- Always show the user what will be committed before committing
- Don't auto-push — only commit locally
- If there are no changes, say so
- If tasks.md was updated, include it in a commit
