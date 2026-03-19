# Skill: Git Version Control

Track all changes to shared documents with git.

## Commit Format

```
<type>: <short description>

<optional details>

Author: @<shortcut>
```

## Commit Types

Use the log entry type as commit type:

| Type | Use for |
|------|---------|
| change | File created, modified, deleted |
| decision | New decision logged |
| task | Task list changes |
| idea | New idea or proposal logged |
| note | Context, observation, meeting note |
| milestone | Phase or goal completed |
| org | Organizational changes (setup, config, structure) |

## Example

```
decision: use PostgreSQL for primary database

Chose over MongoDB for relational model and better tooling.
See collalog/log.md for full rationale.

Author: @SG
```

## Rules

- Commit after every logical unit of change (not after every line)
- Write meaningful commit messages — the log entry title works well
- Never auto-push; commits stay local until explicitly pushed
- Run `git pull --rebase` before committing to avoid merge conflicts
- Use the Author field to attribute changes to the right person
