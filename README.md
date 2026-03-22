# colog

**Make collaboration part of your repo, not another tool.**

colog adds structured collaboration to any project through your AI coding agent. Instead of switching between Slack, Jira, Notion, and your IDE, the agent tracks everything directly in git — decisions, tasks, changes, ideas — all as semantic commits.

Every team member keeps using their preferred tool. The AI agent handles the overhead.

## The Idea

Most collaboration overhead isn't the actual work — it's the meta-work: updating task boards, writing meeting notes, documenting decisions, keeping everyone informed.

colog replaces all of that with one concept: **git as your project log**.

Every project event — a decision made, a task created, an idea proposed, a file changed — becomes a semantic git commit. There is no separate log file. The git history IS the project log:

```
abc1234 decision(db): use PostgreSQL for user data @SG
def5678 task(api): implement rate limiting @NR
ghi9012 change(auth): add JWT token refresh endpoint @SG
jkl3456 idea(ui): consider dark mode toggle @AP
```

Tasks and project memory are snapshots derived from git history:

```
colog/tasks.md       ← what's open, who owns it (with commit refs)
colog/project.md     ← project description, team, schedule
colog/me.md          ← who am I? (local, gitignored)
colog/memory.md      ← optional: condensed project context
```

## Quick Start

### 1. Install

```bash
git clone https://github.com/grothkopp/colog.git
export PATH="$PATH:$(pwd)/colog/bin"
```

### 2. Initialize your project

```bash
cd my-project
colog init .

# For a different AI tool:
colog --agent codex init .
colog --agent cursor init .
```

This creates:
- `colog/` with tasks, project, and memory files
- Commands in your agent's directory (e.g., `.claude/commands/colog.*.md`)
- `.colog/` with skills, prompts, templates, and config
- `CLAUDE.md` with agent behavior instructions and configuration
- `.claude/settings.json` with git permissions (for Claude Code)

### 3. Set up your project

Run the setup command inside your AI agent:

```
/colog:setup
```

The agent will ask about:
- **Project**: name, team members, technologies
- **Paths**: where to store colog files (default: `colog/`)
- **Identity**: how to determine the current user (me.md, git config, env var)
- **Conversations**: how to access chat history for automatic event detection

Or use the CLI fallback: `colog setup`

### 4. Schedule automation

Configure these in your agent platform:

- **Heartbeat** (every 30 min): Runs `/colog:sync --buffer 5m` to keep everything in sync
- **Morning briefing** (daily 8:00): Runs `/colog:status` and sends a daily summary

Prompt files are in `.colog/prompts/`.

### 5. Work

The agent logs proactively as you work — decisions, tasks, ideas all become commits automatically. You can also trigger commands manually:

```
/colog:log We decided to use TypeScript    # Log a decision
/colog:save                                 # Commit current work
/colog:sync                                 # Full sync cycle
/colog:status                               # Project overview (last 24h)
/colog:status open                          # Uncommitted changes
/colog:status last week                     # Weekly review
/colog:ask Who worked on auth last week?    # Query project history
```

## How It Works

### Two main commands do the heavy lifting

**`/colog:sync`** — the orchestrator
1. Pull from remote
2. Detect events from conversations → commit via `/colog:log`
3. Save file changes → commit via `/colog:save`
4. Two-way task sync (tasks.md ↔ git)
5. Push to remote
6. Notify team of changes

**`/colog:status`** — the reader
- Default (no args): open tasks + last 24h activity
- `open`: uncommitted changes, unpushed commits
- `last week`, date ranges: scoped activity view
- Clusters related commits (e.g., "slides: 12 changes by @SG")

### Schedule sync as a heartbeat → everything is automatic

When `/colog:sync` runs on a schedule, the agent automatically picks up conversations, logs events, syncs tasks, and pushes — without anyone having to think about it. The `--buffer 5m` parameter prevents conflicts with real-time agent logging.

### Agent logs proactively

The CLAUDE.md instructs the agent to log without being asked:
- Decisions made during conversation → `/colog:log`
- Tasks that come up → `/colog:log`
- Code changes completed → `/colog:save`
- Larger work done → `/colog:sync`

## Commit Format

Every log entry is a git commit with a semantic message:

```
type(subject): short description @user
```

| Type | Use for |
|------|---------|
| `change` | File created, modified, deleted, refactored |
| `decision` | Direction chosen, convention agreed, scope changed |
| `task` | Task created, completed, reassigned, blocked |
| `idea` | Proposal, suggestion, something to explore |
| `note` | Context, observation, meeting summary, question |
| `milestone` | Phase completed, goal reached, release |

Commits use `--author="First Last <email>"` so git correctly attributes them to the person who initiated the action, even when the agent runs the command.

Events without file changes (questions, decisions, ideas) use empty commits:

```bash
git commit --allow-empty --author="Stefan Grothkopp <sg@example.com>" \
  -m "decision(db): use PostgreSQL for user data @SG"
```

## Task Management

Tasks live in `colog/tasks.md` as a snapshot with commit references:

```markdown
- [ ] Implement rate limiting (@NR, abc1234)
- [ ] Fix login bug (@SG, def5678, due: 2026-03-25)
- [x] Add JWT refresh (@SG, ghi9012)
```

Tasks sync bidirectionally between `tasks.md` and git:
- **Completions** in tasks.md → `task(subject): completed (closes ID)` commit
- **New tasks** added manually → detected and committed automatically
- **Task commits** without a tasks.md entry → added to tasks.md

Dates in tasks are always due dates. Created/completed timestamps live in git history.

## Commands, Skills, Prompts

### Commands (user-invokable)

| Command | Description |
|---------|-------------|
| `/colog:setup` | One-time project setup wizard |
| `/colog:log` | Log an event (creates a semantic commit) |
| `/colog:save` | Save current work (stage + semantic commits) |
| `/colog:sync` | Pull, sync tasks ↔ git, push (the orchestrator) |
| `/colog:status` | Project overview (default: 24h; `open`, `last week`, date range) |
| `/colog:ask` | Query project history — decisions, changes, who did what |

### Skills (agent rules — always active)

| Skill | What it governs |
|-------|----------------|
| git | Semantic commit format, reading the log, common actions |
| ask | Searching project history (git log, blame, pickaxe) |
| task-management | Task list as snapshot with commit references, two-way sync |
| memory | Optional project memory snapshot |
| colog-sync | Syncing with the colog template repo |

### Prompts (scheduled)

| Prompt | Schedule | Description |
|--------|----------|-------------|
| heartbeat | Every 30 min | Runs `/colog:sync --buffer 5m` during working hours |
| morning | Daily 8:00 | Runs sync + status, sends daily briefing to the team |

## Configuration

All configuration lives in the `CLAUDE.md` file (inside `<!-- colog:start -->` markers):

- **Paths**: where tasks, project, identity, and memory files are stored
- **Identity**: how to determine the current user (me.md, git config, env var, etc.)
- **Conversation source**: how to access chat history for automatic event detection

All commands reference this central configuration — nothing is hardcoded.

## Project Structure

```
my-project/
├── colog/                        # User-facing data
│   ├── tasks.md                     #   Task snapshot (with commit refs)
│   ├── project.md                   #   Project description + team
│   ├── me.md                        #   Current user identity (local, gitignored)
│   └── memory.md                    #   Optional memory snapshot
├── .claude/commands/                # Commands (Claude Code example)
│   ├── colog.setup.md
│   ├── colog.log.md
│   ├── colog.save.md
│   ├── colog.sync.md
│   ├── colog.status.md
│   └── colog.ask.md
├── .claude/settings.json            # Git permissions (auto-configured)
├── .colog/                       # Infrastructure
│   ├── skills/                      #   Agent rules (always active)
│   ├── prompts/                     #   Scheduled behaviors
│   ├── templates/                   #   Originals for update/sync
│   └── config.yaml                  #   Configuration
├── CLAUDE.md                        # Agent prompt + colog config
└── .gitignore
```

## Supported Agents

| Agent | Commands Directory |
|-------|--------------------|
| Claude Code | `.claude/commands/` |
| Codex | `.codex/prompts/` |
| Cursor | `.cursor/commands/` |
| Gemini CLI | `.gemini/commands/` |
| Windsurf | `.windsurf/workflows/` |
| GitHub Copilot | `.github/agents/` |
| Kilo Code | `.kilocode/workflows/` |
| Roo | `.roo/commands/` |
| OpenCode | `.opencode/command/` |
| Kiro CLI | `.kiro/prompts/` |
| Amp | `.agents/commands/` |
| OpenClaw | `.colog/commands/` |

For Claude Code, `colog init` automatically configures `.claude/settings.json` with permissions for all required git commands (merge into existing settings, never overwrite).

## CLI Commands

```bash
colog init [path]       # Initialize a new project
colog setup             # CLI setup wizard (prefer /colog:setup)
colog update            # Pull latest templates (removes obsolete files)
colog sync              # Show diffs between project and templates
colog version           # Show version
```

**Options:** `--agent <type>` (default: claude), `--lang en|de`

## Design Principles

- **Git is the single source of truth.** No separate log file — the git history is the project log.
- **Granular writes, aggregated reads.** Every event gets its own commit. Status commands cluster and summarize.
- **No duplication.** Commands call each other: sync → log + save. Heartbeat → sync. Morning → sync + status.
- **Configurable, not hardcoded.** Paths, identity, and conversation source are set once in CLAUDE.md and referenced everywhere.
- **Non-destructive.** History is never squashed or rewritten. Init and update never overwrite existing files.

## License

MIT
