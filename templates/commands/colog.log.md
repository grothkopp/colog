# /colog:log — Log an Event

> Paths and identity method: see colog Configuration section

Log a decision, task, idea, note, or change as a git commit.
This is the single source of truth for creating semantic commits —
`/colog:sync` and `/colog:save` delegate here.

Normally, events are detected and logged automatically by `/colog:sync`
(which reads conversations and creates commits). This command can also
be invoked manually when you want to explicitly log something outside
the regular sync cycle.

## Usage

```
/colog:log We decided to use PostgreSQL instead of MongoDB
/colog:log New idea: add real-time notifications via WebSockets
/colog:log Finished the API documentation
/colog:log What's the best approach for caching?
```

## Steps

1. Read `colog/me.md` for the current user's @Shortcut, First name, Last name, and Email
2. Parse the input (user message or event detected by `/colog:sync`)
3. Determine the commit type:
   - `decision` — "we decided", "agreed on", "chose"
   - `task` — "need to", "should", "todo", "add task"
   - `idea` — "idea:", "what if", "consider", "maybe we should"
   - `change` — "finished", "updated", "created", "fixed", "added"
   - `note` — anything else worth recording (questions, observations)
   - `milestone` — "launched", "completed phase", "released"
4. Determine the subject (project area) from context
5. Create the commit (always use `--author="First Last <email>"` from me.md):
   - **With related file changes**: stage files + `git commit --author="..." -m "type(subject): message @user"`
   - **Without file changes**: `git commit --allow-empty --author="..." -m "type(subject): message @user"`
6. If it's a `task` (new): add to `colog/tasks.md` with commit short ID, then commit tasks.md
7. If it's a `task` (completed, with `closes ID`): update tasks.md checkbox to `- [x]`, commit tasks.md
8. If it's a `decision`: include alternatives in the commit body if mentioned

## Commit Format

Defined in the `git` skill. Summary:

```
type(subject): short description @user
```

Optional body for decisions with context, detailed notes, etc.

## Important

- Don't ask unnecessary questions — infer what you can
- Use empty commits freely — a question or idea without file changes is valid
- This command owns all semantic commit creation — other commands call it
