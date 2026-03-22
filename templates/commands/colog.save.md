# /colog:save — Save Current Work

> Paths and identity method: see colog Configuration section

Capture the current state of work: commit file changes with semantic messages, update tasks.

## Usage

```
/colog:save                     # Auto-detect and commit all changes
/colog:save Refactored auth     # Save with a specific description
```

## Steps

1. **Read identity**: `colog/me.md` for @Shortcut, name, and email (for `--author`)
2. **Detect changes**: Run `git status` and `git diff --stat`
3. **Group changes**: Cluster related files into logical commits
4. **Update tasks**: If changes relate to open tasks in `colog/tasks.md`:
   - Use `/colog:log` to create the completion commit (type: task, with `closes ID`)
   - `/colog:log` handles updating tasks.md automatically
5. **Show the user** what will be committed
6. **Commit**: Create semantic commits for each logical group
   (format and rules from the `git` skill, always use `--author` from me.md)
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
- Don't auto-push — only commit locally (pushing is `/colog:sync`'s job)
- If there are no changes, say so
- Delegates to `/colog:log` for task completion commits — never duplicates task logic
- Commit format follows the `git` skill — this command is about staging and grouping
