# /colog:log — Log an Event

Log a decision, task, idea, note, or change as a git commit.

## Usage

The user tells you what to log. You create a properly formatted commit.

```
/colog:log We decided to use PostgreSQL instead of MongoDB
/colog:log New idea: add real-time notifications via WebSockets
/colog:log Finished the API documentation
/colog:log What's the best approach for caching?
```

## Steps

1. Read `colog/me.md` for the current user's @Shortcut
2. Parse what the user said
3. Determine the commit type:
   - `decision` — "we decided", "agreed on", "chose"
   - `task` — "need to", "should", "todo", "add task"
   - `idea` — "idea:", "what if", "consider", "maybe we should"
   - `change` — "finished", "updated", "created", "fixed", "added"
   - `note` — anything else worth recording (questions, observations)
   - `milestone` — "launched", "completed phase", "released"
4. Determine the subject (project area) from context
5. Create the commit:
   - **With related file changes**: stage files + commit with semantic message
   - **Without file changes**: `git commit --allow-empty -m "type(subject): message @user"`
6. If it's a `task`: also add to `colog/tasks.md` with commit short ID, then commit tasks.md
7. If it's a `decision`: include alternatives in the commit body if mentioned

## Commit Format

First line:
```
type(subject): short description @user
```

Optional body (for decisions with context, detailed notes, etc.):
```
decision(db): use PostgreSQL for user data @SG

Considered MongoDB and DynamoDB. PostgreSQL chosen for:
- Better relational query support
- Team familiarity
- Lower operational complexity
```

## Important

- Don't ask unnecessary questions — infer what you can
- If the user gives a one-liner, that's fine as the full commit message
- Always confirm what was logged with a brief summary
- Use empty commits freely — a question or idea without file changes is valid
