# Skill: Memory

> Paths: see CLAUDE.md → Configuration

Rules for the optional memory snapshot.

Memory is a condensed current-state view of the project — a cheat sheet
organized for quick reference.

## When to Create

Create `colog/memory.md` when:
- Context gets hard to find in the git log
- The project has patterns worth documenting
- New team members need a quick onboarding reference

## Rules

- Memory is a snapshot, not a log — keep it current, not historical
- When facts change, update memory directly (don't append)
- Git history is the source of truth; memory is a convenience layer
- Every memory update gets a commit: `change(memory): update [what changed] @user`
