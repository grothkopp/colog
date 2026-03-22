# /colog:setup — Project Setup

Setup for a new or existing project. Run this after `colog init`.
Can be run again on existing projects to update configuration.

## What This Does

1. Checks for a git repository (required — offers to init or clone if missing)
2. Asks for project details (name, description, team, technologies, communication)
3. Configures paths, identity method, and conversation source
4. Identifies the current user
5. Creates or updates `the agent prompt file` configuration section
6. Creates project files (project.md, tasks.md, me.md)
7. Optionally seeds the git log from existing project data
8. Sets up scheduled tasks (morning briefing + heartbeat) if the platform supports it

## Re-running Setup on Existing Projects

If the the agent prompt file configuration section already exists, this is a *reconfigure*:

1. **Read the existing config first** — show the current configuration to the user
2. **Ask what they want to change** — don't ask all questions from scratch
3. **Merge, don't overwrite** — update only the sections the user wants to change
4. **Skip task creation** — tasks.md already has user content, never overwrite it
5. **Skip log seeding** — log already has entries, don't re-import

## Steps (Fresh Setup)

### 1. Git Repository Check

Git is required. Check if a git repo exists:

- **If yes:** continue
- **If no:** offer init or clone (see Git Repository Check section below)

### 2. Project Details

Ask one at a time:
- Project name
- Short description (1-2 sentences)
- Team members (name, shortcut like @SG, role) — keep asking until done
- Key technologies
- Communication platform (Slack, WhatsApp, Teams, etc.)

### 3. Configuration

#### Paths

Ask: "Where should colog store its files? (default: `colog/`)"

The user can specify a custom directory. All files (tasks.md, project.md, me.md, memory.md)
will be stored there. Update the Paths table in the the agent prompt file Configuration section.

#### Identity Method

Ask: "How should colog identify the current user?"

Options:
1. **me.md file** (default) — a local, gitignored file with name/email/@Shortcut
2. **Git config** — use `git config user.name` and `git config user.email`
3. **Environment variable** — e.g., `$COLOG_USER` or platform-specific
4. **Other** — let the user describe their setup

Store the chosen method in the the agent prompt file Configuration section under "Current User Identity".

#### Conversation Source

Ask: "How can the agent access recent conversations? This is needed for automatic event detection during sync."

Options:
1. **Chat database** — e.g., SQLite, message API (ask for access details)
2. **Log file** — path to a conversation log
3. **Platform API** — e.g., Slack API, Teams API
4. **None** — sync will skip event detection; use `/colog:log` manually

Store the chosen method in the the agent prompt file Configuration section under "Conversation Source".

### 4. Current User

After collecting team members, ask: "Which team member are you?"

Create identity file (default: `colog/me.md`) with their info.

For shared agents: skip identity file, use `@Agent` instead.

### 5. Write Files

- Update the agent prompt file Configuration section with all settings
- Write project.md with project details and schedule
- Write me.md (or equivalent based on identity method)
- Write tasks.md with setup tasks (only if it doesn't exist)

### 6. Scheduled Tasks

If the platform supports scheduling, set up:
- **Heartbeat:** `/colog:sync` on interval (default: every 30 min, working hours only)
- **Morning briefing:** `/colog:sync` + `/colog:status` daily (default: 08:00, weekdays)

Ask for custom times/frequencies. Store in project.md under "## Schedule".

### 7. Commit

`git commit --author="First Last <email>" -m "milestone(colog): setup complete @Shortcut"`

## Git Repository Check

**If no git repo exists:**

```
This directory is not a git repository. colog requires git.

1) Initialize a new git repo here
2) Clone an existing remote repo (e.g., from GitHub)

Which would you like?
```

- **Option 1 (init):** `git init`. Offer to commit existing files.
- **Option 2 (clone):** Ask for URL, clone into directory.

## For Existing Projects With History

Offer to import from git log, README, package files, and GitHub issues.

## Important

- Be conversational, not robotic
- Ask one question at a time
- For team members, suggest shortcuts based on names (e.g., "Stefan Grothkopp" → "@SG")
- If the agent prompt file already has a colog section, update it rather than overwriting
- Make sensible suggestions for defaults but let the user override
- All paths configured here are referenced by every other command — nothing is hardcoded elsewhere
