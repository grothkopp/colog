# Skill: Log Format

Rules for writing entries in the unified log at `collalog/log.md`.

## Entry Types

| Type | Use for |
|------|---------|
| change | File created, modified, deleted |
| decision | Direction chosen, convention agreed, scope changed |
| task | Task created, completed, reassigned, blocked |
| idea | Proposal, suggestion, something to explore |
| note | Context, observation, meeting summary |
| milestone | Phase completed, goal reached, release |

## Entry Format

```markdown
### YYYY-MM-DD HH:MM — @Shortcut [type]

**Short Title**

Description of what happened, was decided, or changed.

- *Affected files:* `path/to/file` (optional)
- *Related:* TASK-NNN or previous entry (optional)

---
```

## Current User

Read `collalog/me.md` to determine the `@Shortcut` for log entries. If the file
doesn't exist (shared agent or not yet set up), use `@Agent` as the shortcut.

## Rules

- Newest entries at the top
- If git is enabled (check `collalog/project.md` → `## Git`): every log entry gets a git commit (use entry type as commit type). If git is disabled: skip commits.
- The @Shortcut in the header comes from `collalog/me.md`
- Be specific and factual — the log is the project's memory
- Keep entries concise: 2-5 lines of description
- Include enough context for someone reading in 3 months
- When a decision is revisited, add a new entry referencing the original
- Tasks in the log are also reflected in `collalog/tasks.md`

## Efficient File Operations

log.md grows over time. NEVER read the entire file and rewrite it. Use shell tools:

### Adding entries (prepend)

Write the new entry to a temp file, then prepend it:

```bash
cat > /tmp/collalog_entry.md << 'ENTRY'
### YYYY-MM-DD HH:MM — @Shortcut [type]

**Title**

Description.

---
ENTRY
cat /tmp/collalog_entry.md collalog/log.md > collalog/log.md.tmp && mv collalog/log.md.tmp collalog/log.md
rm /tmp/collalog_entry.md
```

For multiple entries, write them all to the temp file (newest first), then prepend once.

### Reading recent entries

**Last N entries** (for status): Extract entries up to the Nth `---` separator:

```bash
awk '/^---$/{c++} c>=N{exit} {print}' collalog/log.md
```

Replace N with the number of entries needed (e.g. 5, 10).

**Last 24-48 hours** (for morning briefing): Grep entry headers by date:

```bash
grep "^### 2026-03-19\|^### 2026-03-20" collalog/log.md
```

To get full entries for matching dates, use awk:

```bash
awk '/^### (2026-03-19|2026-03-20)/,/^---$/' collalog/log.md
```

**Entry headers only** (for quick overview):

```bash
grep "^### " collalog/log.md | head -10
```

### Searching

```bash
grep -i "keyword" collalog/log.md
grep -B2 -A5 "keyword" collalog/log.md  # with context
```
