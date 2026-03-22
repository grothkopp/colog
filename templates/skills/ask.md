# Skill: Ask — Searching the Project History

This skill describes how to find information in the project's git-based log.
The git history is the single source of truth for all project events.

## Search Techniques

### By commit message content

```bash
# Keyword in any commit message
git log --oneline --grep="keyword"

# By type prefix
git log --oneline --grep="^decision"
git log --oneline --grep="^task"
git log --oneline --grep="^change"
git log --oneline --grep="^idea"
git log --oneline --grep="^note"
git log --oneline --grep="^milestone"

# By subject (project area)
git log --oneline --grep="(api)"
git log --oneline --grep="(auth)"

# By user
git log --oneline --grep="@SG"

# Combine filters (AND logic)
git log --oneline --grep="^decision" --grep="database" --all-match
```

### By author (who committed)

```bash
git log --author="Stefan" --oneline
git log --author="Stefan" --since="7 days ago" --format="%h %ai %s"
```

Note: `--author` checks the git commit author (set via `--author` flag from me.md).
`--grep="@SG"` checks the message shortcut. Both may be useful — the author is
the person who initiated the action, the @shortcut is the human-readable tag.

### By time

```bash
git log --since="24 hours ago" --format="%h %ai %s"
git log --since="7 days ago" --until="3 days ago" --oneline
git log --after="2026-03-01" --before="2026-03-15" --oneline
```

### By file changes

```bash
# Who changed a file
git log --oneline -- path/to/file
git blame path/to/file
git blame -L 10,20 path/to/file

# When a file was created
git log --diff-filter=A -- path/to/file

# When a file was deleted
git log --diff-filter=D -- path/to/file

# What changed in a file
git log -p -- path/to/file
```

### By content (pickaxe search)

```bash
# Find when a string was added or removed
git log -S "search string" --oneline

# Find when a regex pattern was added or removed
git log -G "regex.*pattern" --oneline

# Show the actual diff
git log -S "search string" -p
```

### Full commit details

```bash
# Show a single commit with full message
git show <hash> --stat
git log -1 --format="%H%n%ai%n%an <%ae>%n%n%s%n%n%b" <hash>
```

## Combining with Project Files

For context beyond git history, also check:

- `colog/project.md` — team members, technologies, communication setup
- `colog/tasks.md` — current open tasks (with commit references)
- `colog/memory.md` — project knowledge snapshot
- Source files — `grep -r "pattern" src/` for finding where something lives today

## Answer Quality

- Always cite commit hashes and dates as evidence
- Distinguish between "not found" and "doesn't exist" — absence of evidence
  is not evidence of absence (the event may predate colog)
- For "who" questions, prefer the `@user` in the message over `--author`,
  since the author may be the agent acting on behalf of someone
- When multiple commits are relevant, summarize the timeline
