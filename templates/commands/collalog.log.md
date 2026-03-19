# /collalog:log — Add a Log Entry

Manually add an entry to the unified log at `collalog/log.md`.

## Usage

The user tells you what to log. You create a properly formatted entry.

```
/collalog:log We decided to use PostgreSQL instead of MongoDB
/collalog:log New idea: add real-time notifications via WebSockets
/collalog:log Finished the API documentation
```

## Steps

1. Parse what the user said
2. Determine the entry type:
   - [decision] — "we decided", "agreed on", "chose"
   - [task] — "need to", "should", "todo", "add task"
   - [idea] — "idea:", "what if", "consider", "maybe we should"
   - [change] — "finished", "updated", "created", "fixed", "added"
   - [note] — anything else worth recording
   - [milestone] — "launched", "completed phase", "released"
3. Ask for clarification only if truly ambiguous
4. Write the entry to the TOP of `collalog/log.md` (newest first)
5. If it's a [task]: also add to `collalog/tasks.md` with `created: YYYY-MM-DD HH:MM`
6. If it's a [decision]: note alternatives if the user mentioned them
7. Commit with the entry type: `<type>: <title>`

## Entry Format

```markdown
### YYYY-MM-DD HH:MM — @Shortcut [type]

**Title**

Description.

- *Affected files:* `path` (if applicable)
- *Related:* TASK-NNN (if applicable)

---
```

## Important

- Don't ask unnecessary questions — infer what you can
- If the user gives a one-liner, that's fine as the full entry
- Always confirm what was logged with a brief summary
