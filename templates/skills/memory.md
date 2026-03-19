# Skill: Memory

Maintain an optional project memory snapshot at `collalog/memory.md`.

Memory is a condensed, current-state view of the project — derived from the log
but organized for quick reference. Think of it as the "cheat sheet" for the project.

## When to Create

Memory is optional. Create `collalog/memory.md` when:
- The log grows long and context gets hard to find
- The project has established patterns worth documenting
- New team members need a quick onboarding reference

## Structure

```markdown
# Memory

## Project
- Vision: [one line]
- Phase: [current phase]
- Tech stack: [key technologies]

## Team
| Name | Shortcut | Role | Notes |
|------|----------|------|-------|

## Key Decisions
- [date] Decision title — brief rationale
- [date] Decision title — brief rationale

## Conventions
- [conventions the team follows]

## Open Questions
- [things not yet decided]
```

## Rules

- Memory is a snapshot, not a log — keep it current, not historical
- When facts change, update memory directly (don't append)
- The log is the source of truth; memory is a convenience layer
- Every memory update gets a log entry (type: change) and git commit
- Remove outdated information rather than marking it as old
