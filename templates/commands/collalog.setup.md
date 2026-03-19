# /collalog:setup — Project Setup

One-time setup for a new or existing project. Run this once after `collalog init`.

## What This Does

1. Asks for project details (name, description, team, technologies, communication)
2. Populates `collalog/project.md` with the answers
3. Creates initial task list in `collalog/tasks.md`
4. Optionally seeds the log from existing project data
5. Sets up scheduled tasks (morning briefing + heartbeat) if the platform supports it

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
3. If existing repo: offer to import history
4. Write `collalog/project.md`
5. Write initial `collalog/tasks.md` with setup tasks
6. If importing: write initial entries to `collalog/log.md`
7. Log the setup itself as a [milestone] entry
8. **Set up scheduled tasks** (see section below)
9. Commit with: `org: collalog setup complete`

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
