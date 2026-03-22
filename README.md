# colog

**Let your AI agent handle collaboration.**

Decisions get made in chat. Tasks come up in conversation. Code changes happen all day. But updating Jira, writing meeting notes, keeping everyone in sync — that's the overhead nobody wants.

colog lets your AI coding agent take care of it. As you work together, the agent tracks decisions, tasks, changes, and ideas — automatically, as semantic git commits. No context switching. No separate tools. Everything stays in your project.

```
decision(db): use PostgreSQL for user data @SG
task(api): implement rate limiting @NR
change(auth): add JWT token refresh endpoint @SG
idea(ui): consider dark mode toggle @AP
```

Works with Claude Code, Codex, Cursor, Gemini CLI, and [10+ more agents](#supported-agents).

## Install

```bash
git clone https://github.com/grothkopp/colog.git
export PATH="$PATH:$(pwd)/colog/bin"
```

## Setup

```bash
cd my-project
colog init .                    # default: Claude Code
colog --agent codex init .      # or specify your agent
```

Then run the setup wizard inside your agent:

```
/colog:setup
```

This configures your project name, team, and creates the initial files. You can also use `colog setup` from the CLI.

## Usage

The agent logs proactively as you work — decisions, tasks, ideas all become commits without you asking. You can also use commands directly:

```
/colog:sync                                 # Sync everything (pull, commit, push)
/colog:status                               # Open tasks + last 24h
/colog:status open                          # Uncommitted changes
/colog:log We decided to use TypeScript      # Log something manually
/colog:save                                 # Commit current file changes
/colog:ask Who worked on auth last week?     # Query project history
```

**`/colog:sync`** is the main workhorse — it pulls, detects events from conversations, commits file changes, syncs tasks bidirectionally, and pushes. All other write commands (`/colog:log`, `/colog:save`) are called internally by sync.

**`/colog:status`** is read-only — open tasks, recent activity, clustered by topic. `status open` shows uncommitted work, `status last week` gives a sprint review.

## Scheduling

Set up two scheduled tasks in your agent platform and everything runs on autopilot:

| Task | Schedule | What it does |
|------|----------|-------------|
| Heartbeat | Every 30 min | Runs `/colog:sync --buffer 5m` during working hours |
| Morning briefing | Daily 8:00 | Runs `/colog:sync` + `/colog:status`, sends summary to the team |

The `--buffer 5m` parameter ensures the heartbeat doesn't conflict with the agent's own real-time logging. Prompt templates are in `.colog/prompts/`.

## How It Works

Every project event becomes a semantic git commit:

```
type(subject): short description @user
```

| Type | Use for |
|------|---------|
| `change` | File created, modified, deleted, refactored |
| `decision` | Direction chosen, convention agreed |
| `task` | Task created, completed, reassigned |
| `idea` | Proposal, suggestion, something to explore |
| `note` | Context, observation, meeting summary |
| `milestone` | Phase completed, goal reached, release |

Commits use `--author="First Last <email>"` so git attributes them to the right person, even when the agent runs the command. Events without file changes (decisions, ideas) use `git commit --allow-empty`.

### Tasks

Tasks live in `colog/tasks.md` as a snapshot with commit references:

```markdown
- [ ] Implement rate limiting (@NR, abc1234)
- [ ] Fix login bug (@SG, def5678, due: 2026-03-25)
- [x] Add JWT refresh (@SG, ghi9012)
```

Tasks sync bidirectionally between `tasks.md` and git — completions, new tasks, and untracked commits are all handled automatically by `/colog:sync`. Dates are always due dates; created/completed timestamps live in git history.

## Customization

All configuration lives in your agent's prompt file — `CLAUDE.md` for Claude Code, `AGENTS.md` for Codex/Copilot/Amp/others, `GEMINI.md` for Gemini CLI. colog detects your agent and uses the right file. The colog section is wrapped in `<!-- colog:start -->` / `<!-- colog:end -->` markers. `/colog:setup` walks you through it.

**File paths** — By default, colog stores files in `colog/`. You can change this to any directory during setup.

**User identity** — How the agent determines who you are. Options: `me.md` file (default, local, gitignored), `git config user.name`, environment variable, or a platform-specific API.

**Conversation source** — How the agent accesses recent conversations for automatic event detection. Options: chat database, log file, API, or none (manual logging only).

All commands reference this central configuration — nothing is hardcoded.

## Project Structure

```
my-project/
├── colog/                        # Your data
│   ├── tasks.md                     Task snapshot (with commit refs)
│   ├── project.md                   Project description + team
│   ├── me.md                        Your identity (local, gitignored)
│   └── memory.md                    Optional project memory
├── .claude/commands/colog.*.md   # Agent commands (Claude Code example)
├── .colog/                       # Infrastructure
│   ├── skills/                      Agent rules (always active)
│   ├── prompts/                     Scheduled behaviors (heartbeat, morning)
│   └── config.yaml                  Internal config
└── CLAUDE.md                     # Agent prompt file (AGENTS.md, GEMINI.md, etc.)
```

## Supported Agents

| Agent | Prompt File | Commands Directory |
|-------|-------------|---------------------|
| Claude Code | `CLAUDE.md` | `.claude/commands/` |
| Codex | `AGENTS.md` | `.codex/prompts/` |
| Cursor | `AGENTS.md` | `.cursor/commands/` |
| Gemini CLI | `GEMINI.md` | `.gemini/commands/` |
| Windsurf | `AGENTS.md` | `.windsurf/workflows/` |
| GitHub Copilot | `AGENTS.md` | `.github/agents/` |
| Kilo Code | `AGENTS.md` | `.kilocode/workflows/` |
| Roo | `AGENTS.md` | `.roo/commands/` |
| OpenCode | `AGENTS.md` | `.opencode/command/` |
| Kiro CLI | `AGENTS.md` | `.kiro/prompts/` |
| Amp | `AGENTS.md` | `.agents/commands/` |
| OpenClaw | `AGENTS.md` | `.colog/commands/` |

For Claude Code, `colog init` automatically configures `.claude/settings.json` with git permissions.

## CLI Reference

```bash
colog init [path]       # Initialize a new project
colog setup             # CLI setup wizard (prefer /colog:setup in your agent)
colog update            # Pull latest templates, remove obsolete files
colog sync              # Show diffs between your files and templates
colog version           # Show version
```

**Options:** `--agent <type>` (default: claude), `--lang en|de`

## License

MIT
