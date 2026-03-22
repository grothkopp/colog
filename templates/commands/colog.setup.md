# /colog:setup — Project Setup

Setup for a new or existing project. Run this after `colog init`.
Can be run again on existing projects to update configuration.

## What This Does

1. Checks for a git repository (required — offers to init or clone if missing)
2. Asks for project details (name, description, team, technologies, communication)
3. Identifies the current user and creates `colog/me.md` (local, gitignored)
4. Creates or updates `colog/project.md` with the answers
5. Creates initial task list in `colog/tasks.md` (only if it doesn't exist)
6. Optionally seeds the git log from existing project data
7. Sets up scheduled tasks (morning briefing + heartbeat) if the platform supports it

## Re-running Setup on Existing Projects

If `colog/project.md` already exists, this is a *reconfigure*, not a fresh setup:

1. **Read the existing project.md first** — show the current configuration to the user
2. **Ask what they want to change** — don't ask all questions from scratch. Show current values and let the user update only specific sections.
3. **Merge, don't overwrite** — update only the sections the user wants to change. Keep everything else as-is.
4. **Skip task creation** — `colog/tasks.md` already has user content, never overwrite it.
5. **Skip log seeding** — log already has entries, don't re-import.

Example flow for reconfigure:
```
Current project configuration:
  Name: My Project
  Description: A web app for X
  Team: @SG (CTO), @AL (Dev), @MK (Design)
  Technologies: Python, FastAPI, React
  Communication: Slack
  Schedule: morning 08:00, heartbeat every 30 min

What would you like to change? (or "all" to reconfigure everything)
```

## Steps (Fresh Setup)

1. **Check git repository** (see section below)
2. Greet the user and explain what this command does
3. Ask questions one at a time:
   - Project name
   - Short description (1-2 sentences)
   - Team members (name, shortcut like @SG, role) — keep asking until user says done
   - Key technologies
   - Communication platform (Slack, WhatsApp, Teams, etc.)
4. **Identify current user** (see section below)
5. If existing repo with history: offer to import (see below)
6. Write `colog/project.md`
7. Write `colog/me.md` with the current user's info
8. Write initial `colog/tasks.md` with setup tasks (only if it doesn't exist)
9. **Set up scheduled tasks** (see section below)
10. Commit setup: `git commit --author="First Last <email>" -m "milestone(colog): setup complete @Shortcut"`

## Git Repository Check

Git is required for colog. Before anything else, check if the project is in a git repo.

**If a git repo exists:** continue with setup.

**If no git repo exists:** ask the user:

```
This directory is not a git repository. colog requires git.

1) Initialize a new git repo here
2) Clone an existing remote repo (e.g., from GitHub)

Which would you like?
```

- **Option 1 (init):** Run `git init`. If there are existing files in the directory, ask:
  "There are existing files here. Add them to an initial commit?" If yes, stage all and
  commit: `change(init): add existing project files`
- **Option 2 (clone):** Ask for the remote URL, then `git clone <url> .` (or into the
  target directory). Existing colog files from the remote are preserved.

## For New Projects With Existing History

If the project already has git history, offer to import:

- **Git log**: Run `git log --oneline --since="3 months ago"` and review key changes
- **README/docs**: Extract project description, tech stack, and goals from existing files
- **Package files**: Read `package.json`, `Cargo.toml`, `pyproject.toml`, etc. for technologies
- **Open issues**: If GitHub issues exist, import open ones as tasks in `colog/tasks.md`

Ask the user: "This repo has existing history. Want me to seed tasks from git history and project files?"

## User Identity (me.md)

After collecting team members, ask: "Which team member are you?" and let them pick from the list (or enter new details if they're not yet in the team).

Create `colog/me.md` with their info:

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

The shortcut in me.md MUST match the shortcut in the team table in `colog/project.md`.

### Validation

- If me.md already exists, show the current identity and ask if it's correct
- The shortcut must match exactly one team member in project.md
- If the user provides details that don't match any team member, add them to the team

### Shared agents (e.g., OpenClaw, shared CI)

For agents shared by multiple users (like OpenClaw or CI runners), the agent cannot have a single me.md. In this case:

- Ask: "Is this agent used by a single person or shared by the team?"
- If shared: skip me.md creation. Log entries from this agent should use `@Agent` or the agent's name instead of a personal shortcut.
- Add a note in `colog/project.md` under the team table: `> Shared agent: entries use @AgentName`

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
- Prompt: Read `colog/project.md`, `colog/tasks.md`, and recent git log entries. Send a concise daily summary (see `.colog/prompts/morning.md`).

**Heartbeat:**
- Schedule: interval or cron, at the user's chosen frequency
- Only during working hours (use cron with hour range, e.g., `*/30 8-18 * * 1-5`)
- Prompt: Check for new activity, commit events, update tasks (see `.colog/prompts/heartbeat.md`).

Store the schedule configuration in `colog/project.md` under a "## Schedule" section so the user can review and the agent can reference it.

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
