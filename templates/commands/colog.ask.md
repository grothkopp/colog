# /colog:ask — Ask About the Project

> Paths and identity method: see colog Configuration section

Answer questions about the project's history, decisions, changes, and collaboration.

## Usage

The user asks a question about what happened, who did what, or when something changed.

```
/colog:ask When did we decide to use PostgreSQL?
/colog:ask Who last changed the auth module?
/colog:ask What happened last week?
/colog:ask Where does this configuration value come from?
/colog:ask Show me all decisions about the API
```

## Question Types and Strategies

### "When did we decide X?" — Decision lookup

```bash
git log --oneline --grep="^decision" --grep="X" --all-match
git log --grep="^decision" --format="%h %ai %s" | grep -i "keyword"
```

Show the full commit (with body) for context:
```bash
git log -1 --format="%h %ai %an%n%n%s%n%n%b" <commit-hash>
```

### "Who changed X?" — Blame and authorship

For a specific file or section:
```bash
git blame <file>
git blame -L <start>,<end> <file>
```

For a topic area:
```bash
git log --oneline --grep="(subject)" --format="%h %ai %an — %s"
```

### "What happened recently?" — Activity summary

```bash
git log --since="7 days ago" --format="%h %ai %s"
git log --since="24 hours ago" --format="%h %ai %an — %s"
```

Group by type:
```bash
git log --since="7 days ago" --oneline --grep="^decision"
git log --since="7 days ago" --oneline --grep="^change"
git log --since="7 days ago" --oneline --grep="^task"
```

### "What did @user do?" — User activity

```bash
git log --oneline --grep="@SG"
git log --author="Stefan" --oneline
git log --since="7 days ago" --author="Stefan" --format="%h %ai %s"
```

### "Where does this come from?" — Origin tracking

Find when a file was created:
```bash
git log --diff-filter=A -- <file>
```

Find when specific content was added:
```bash
git log -S "search string" --oneline
git log -G "regex pattern" --oneline
```

Show the commit that introduced it:
```bash
git log -S "content" -1 --format="%h %ai %an%n%n%s%n%n%b"
```

### "Show all X" — Filtered history

All decisions:
```bash
git log --oneline --grep="^decision"
```

All entries about a subject:
```bash
git log --oneline --grep="(api)"
```

All milestones:
```bash
git log --oneline --grep="^milestone"
```

## Steps

1. Read the user's question
2. Determine the question type (see above)
3. Run the appropriate git commands
4. Also search project files if relevant:
   - `colog/project.md` for team info, technologies, communication
   - `colog/tasks.md` for current task status
   - `colog/memory.md` for project context
   - Source files via `grep` for content questions
5. Synthesize a clear, concise answer
6. Include commit references (short IDs + dates) so the user can dig deeper
7. If the answer is uncertain or incomplete, say so and suggest how to find more

## Response Format

Keep answers concise and factual. Always include evidence:

```
That decision was made on March 15 (commit abc1234):

  decision(db): use PostgreSQL for user data @SG

  Context from the commit body:
  Considered MongoDB and DynamoDB. PostgreSQL chosen for
  better relational query support and team familiarity.
```

## Important

- Always cite commits (short ID + date) as evidence
- If you can't find the answer in git history, say so clearly
- For "who" questions, check both `--author` and `@user` in messages
  (they may differ if the agent committed on behalf of a user)
- Cross-reference with project files when useful
- Don't guess — if the history doesn't contain it, the answer is "I couldn't find that in the project log"
