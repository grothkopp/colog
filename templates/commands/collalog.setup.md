# /collalog:setup — Project Setup

One-time setup for a new or existing project. Run this once after `collalog init`.

## What This Does

1. Asks for project details (name, description, team, technologies, communication)
2. Identifies the current user and creates `collalog/me.md` (local, gitignored)
3. Populates `collalog/project.md` with the answers
4. Creates initial task list in `collalog/tasks.md`
5. Optionally seeds the log from existing project data
6. Sets up scheduled tasks (morning briefing + heartbeat) if the platform supports it

## For Existing Projects

If the project already has history, offer to import:

- **Git log**: Run `git log --oneline --since="3 months ago"` and summarize key changes as [change] entries
- **README/docs**: Extract project description, tech stack, and goals from existing files
- **Package files**: Read `package.json`, `Cargo.toml`, `pyproject.toml`, etc. for technologies
- **Open issues**: If GitHub issues exist, import open ones as [task] entries

Ask the user: "This repo has existing history. Want me to seed the log from git history and project files?"

## Steps

1. Greet the user and explain what this command does
2. Ask questions one at a time:
   - Project name
   - Short description (1-2 sentences)
   - Team members (name, shortcut like @SG, role) — keep asking until user says done
   - Key technologies
   - Communication platform (Slack, WhatsApp, Teams, etc.)
   - **Use git?** "Should collalog use git for version control? (yes/no, default: yes)" — auto-detect: if not in a git repo, suggest "no"
3. **Identify current user** (see section below)
4. If git enabled and existing repo: offer to import history
5. Write `collalog/project.md`
6. Write `collalog/me.md` with the current user's info
7. Write initial `collalog/tasks.md` with setup tasks
8. If importing: write initial entries to `collalog/log.md`
9. Log the setup itself as a [milestone] entry
10. **Set up scheduled tasks** (see section below)
11. If git enabled: commit with `org: collalog setup complete`

## User Identity (me.md)

After collecting team members, ask: "Which team member are you?" and let them pick from the list (or enter new details if they're not yet in the team).

Create `collalog/me.md` with their info:

```markdown
# Me

> This file identifies the current user. It is local and gitignored.

| Field | Value |
|-------|-------|
| First name | Stefan |
| Last name | Grothkopp |
| Email | stefan@example.com |
| Shortcut | @SG |
```

The shortcut in me.md MUST match the shortcut in the team table in `collalog/project.md`.

### Validation

- If me.md already exists, show the current identity and ask if it's correct
- The shortcut must match exactly one team member in project.md
- If the user provides details that don't match any team member, add them to the team

### Shared agents (e.g., OpenClaw, shared CI)

For agents shared by multiple users (like OpenClaw or CI runners), the agent cannot have a single me.md. In this case:

- Ask: "Is this agent used by a single person or shared by the team?"
- If shared: skip me.md creation. Log entries from this agent should use `@Agent` or the agent's name instead of a personal shortcut.
- Add a note in `collalog/project.md` under the team table: `> Shared agent: entries use @AgentName`

### How me.md is used

- Log entries: the `@Shortcut` in the header comes from me.md
- Tasks: the `@Owner` defaults to me.md's shortcut when the user creates their own tasks
- Morning briefing: highlights the current user's tasks first
- Heartbeat: attributes activity to the current user

## Scheduled Tasks Setup

If the platform supports scheduling (e.g., Claude Code `schedule_task`, OpenClaw cron), set up the heartbeat and morning briefing automatically.

Ask the user:
- "When should the morning briefing run? (default: 8:00)"
- "How often should the heartbeat run? (default: every 30 minutes)"
- "What are your working hours? The heartbeat will only run during these times. (default: 08:00-18:00, weekdays)"

Then create the scheduled tasks:

**Morning briefing:**
- Schedule: cron, at the user's chosen time, weekdays only
- Prompt: Read `collalog/project.md`, `collalog/tasks.md`, and recent entries from `collalog/log.md`. Send a concise daily summary (see `.collalog/prompts/morning.md`).

**Heartbeat:**
- Schedule: interval or cron, at the user's chosen frequency
- Only during working hours (use cron with hour range, e.g., `*/30 8-18 * * 1-5`)
- Prompt: Check for new activity, update log and tasks, commit changes (see `.collalog/prompts/heartbeat.md`).

Store the schedule configuration in `collalog/project.md` under a "## Schedule" section so the user can review and the agent can reference it.

Store the git setting in `collalog/project.md` under a "## Git" section:

```markdown
## Git

- Enabled: yes
```

If git is disabled, set `Enabled: no`. All commands, skills, and prompts check this setting before running any git commands.

Example project.md schedule section:
```markdown
## Schedule

- Morning briefing: 08:00, weekdays
- Heartbeat: every 30 min, 08:00-18:00, weekdays
```

If the platform does not support scheduling, tell the user how to set it up manually (e.g., external cron, CI/CD triggers).

## Important

- Be conversational, not robotic
- Don't dump all questions at once — ask one at a time
- For team members, suggest shortcuts based on names (e.g., "Stefan Grothkopp" → "@SG")
- If the user already has a CLAUDE.md, update it rather than overwriting
- Make sensible suggestions for defaults but let the user override
