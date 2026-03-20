# Skill: Git Conventions

Rules for version control in colog projects.

## Git Enabled Check

Before running any git commands, read `colog/project.md` and check the
`## Git` section. If `Enabled: no`, skip ALL git operations silently.
Do not warn or remind the user — just skip.

## Commit Format

```
<type>: <short description>

Author: @<shortcut>
```

The commit type matches the log entry type: change, decision, task, idea, note, milestone, org.

## Rules

- Commit after every logical unit of change
- Write meaningful commit messages — the log entry title works well
- Never auto-push; commits stay local until explicitly pushed
- Run `git pull --rebase` before committing to avoid merge conflicts
- Always include `colog/log.md` in commits that have log updates
- Use the Author field to attribute changes to the right person
