# Skill: Git — The Project Log

Git is the single source of truth for the project log. Every meaningful event —
changes, decisions, tasks, ideas, notes, milestones — is a git commit.
There is no separate log file.

## Commit Format

```
type(subject): short description @user

Optional longer description.
```

### Types

| Type | Use for |
|------|---------|
| change | File created, modified, deleted, refactored |
| decision | Direction chosen, convention agreed, scope changed |
| task | Task created, completed, reassigned, blocked |
| idea | Proposal, suggestion, something to explore |
| note | Context, observation, meeting summary, question |
| milestone | Phase completed, goal reached, release |

### Subject

The area or topic in parentheses. Keep it short: `auth`, `api`, `docs`, `colog`, `ui`.
Leave empty for general entries: `note(): ...`

### User Identity

The `@user` at the end identifies who initiated the action.
Read from `colog/me.md` — NEVER rely on `git config user.name` (the git user
may always be the agent, not the human).

If `colog/me.md` doesn't exist, use `@Agent`.

### Git Author

Set the commit author to the actual user from `colog/me.md` using `--author`:

```bash
git commit --author="First Last <email>" -m "type(subject): description @Shortcut"
```

This way `git log` and `git shortlog` correctly attribute commits to the person
who initiated them, even when the agent is the one running git.

If the user has no email in `me.md`, use `shortcut@colog` as placeholder
(e.g., `SG@colog`).

### Examples

```
decision(db): use PostgreSQL for user data @SG
task(api): implement rate limiting @NR
change(auth): add JWT token refresh endpoint @SG
idea(ui): consider dark mode toggle @AP
note(): what's the best caching strategy for this? @SG
milestone(v1): launch beta to first 10 users @SG
task(auth): completed - JWT refresh working (closes abc1234) @SG
```

## Empty Commits

When logging something with no file changes (a question, decision, idea, or note),
use an empty commit:

```bash
git commit --allow-empty --author="Stefan Grothkopp <sg@example.com>" \
  -m "note(): what's the best approach for caching? @SG"
```

This keeps the log complete without requiring dummy file changes.

## Reading the Log

The git log IS the project log. Use these commands to read it:

### Recent entries

```bash
git log --oneline -20
```

### Last 24 hours

```bash
git log --since="24 hours ago" --format="%h %s (%ar)"
```

### Entries by type

```bash
git log --oneline --grep="^decision"
git log --oneline --grep="^task"
```

### Entries by user

```bash
git log --oneline --grep="@SG"
```

### Full entry with body

```bash
git log -1 --format="%h %s%n%n%b" <commit-hash>
```

### Entries with file changes

```bash
git log --oneline --stat -5
```

## Common Actions

### Add to last commit

When you forgot to include a file or want to add more context:

```bash
git add <file>
git commit --amend --no-edit
```

### Change last commit message

```bash
git commit --amend -m "type(subject): corrected description @user"
```

### Log and commit in one step

For changes with files:
```bash
git add <files>
git commit --author="Stefan Grothkopp <sg@example.com>" \
  -m "change(auth): add password reset flow @SG"
```

For questions or notes without files:
```bash
git commit --allow-empty --author="Stefan Grothkopp <sg@example.com>" \
  -m "note(architecture): should we split the monolith? @SG"
```

## Rules

- Commit after every logical unit of change
- Write meaningful commit messages — they ARE the project log
- Always use `--author` with the user's name and email from `colog/me.md`
- Never auto-push; commits stay local until explicitly pushed
- One commit per logical event (don't batch unrelated things)
- Include the @user shortcut from me.md in every commit message
- Use empty commits freely for non-file events
- The commit message first line is the log entry; use the body for details
- When logging out of sequence (e.g., a quick question mid-task),
  commit just that — don't bundle it with unrelated file changes
