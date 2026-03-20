# colog

**Make collaboration part of your repo, not another tool.**

colog adds structured collaboration to any project through your AI coding agent. Instead of switching between Slack, Jira, Notion, and your IDE, the agent tracks everything in a single unified log — decisions, tasks, changes, ideas — all in plain Markdown inside your git repository.

Every team member keeps using their preferred tool. The AI agent handles the overhead.

## The Idea

Most collaboration overhead isn't the actual work — it's the meta-work: updating task boards, writing meeting notes, documenting decisions, keeping everyone informed.

colog replaces all of that with one concept: a **unified log**.

Every project event — a decision made, a task created, an idea proposed, a file changed — becomes a log entry. The agent reads and writes this log automatically. Tasks and project memory are snapshots derived from the log.

```
colog/log.md         ← the source of truth (all events, newest first)
colog/tasks.md       ← snapshot: what's open, who owns it
colog/project.md     ← project description, team, config
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
- `colog/` with log, tasks, and project files (user-facing data)
- Commands in your agent's directory (e.g., `.claude/commands/colog.*.md`)
- `.colog/` with skills, prompts, templates, and config (infrastructure)
- `CLAUDE.md` as the main agent prompt

### 3. Set up your project

Run the setup command inside your AI agent:

```
/colog:setup
```

The agent will ask about your project name, team members, technologies, and communication platform. It also creates a local `colog/me.md` to identify you (gitignored — not shared). For existing projects, it can import history from git log and project files.

Or use the CLI fallback: `colog setup`

### 4. Set up scheduled tasks

Configure these in your agent platform:

- **Heartbeat** (every 30 min): Agent monitors conversations, updates log + tasks
- **Morning briefing** (daily 8:00): Summary of open tasks and recent activity

Prompt files are in `.colog/prompts/`.

### 5. Work

```
/colog:log We decided to use TypeScript    # Log something manually
/colog:save                                 # Save current work + commit
/colog:status                               # Quick project overview
```

The agent also logs automatically via the heartbeat prompt.

## Commands, Skills, Prompts

colog separates functionality into three categories:

### Commands (user-invokable)

Installed in the agent's commands directory. You trigger these explicitly.

| Command | What it does |
|---------|-------------|
| `/colog:setup` | One-time project setup. Asks questions, populates project.md, optionally imports from git log |
| `/colog:log` | Manually add a log entry. Infers type from what you say |
| `/colog:save` | Detect changes, create log entries, commit (if git enabled) |
| `/colog:status` | Show open tasks, recent activity, git status (if git enabled) |

### Skills (agent rules)

Stored in `.colog/skills/`. These are rules the agent always follows — not directly invoked.

| Skill | What it governs |
|-------|----------------|
| log-format | Log entry types, format, structure |
| git | Commit message format and conventions |
| task-management | How the task list stays in sync with the log |
| memory | When and how to maintain the optional memory file |
| colog-sync | How to sync with the colog template repo |

### Prompts (scheduled)

Stored in `.colog/prompts/`. These run automatically on a schedule.

| Prompt | Schedule | What it does |
|--------|----------|-------------|
| heartbeat | Every 30 min | Reads conversations, updates log + tasks + memory |
| morning | Daily 8:00 | Sends daily summary to the team |

## Project Structure

```
my-project/
├── colog/                        # User-facing (all mutable data)
│   ├── log.md                       #   Unified log (source of truth)
│   ├── tasks.md                     #   Task snapshot
│   ├── project.md                   #   Project description + team
│   ├── me.md                        #   Current user identity (local, gitignored)
│   └── memory.md                    #   Optional memory snapshot
├── .claude/commands/                # Commands (Claude Code example)
│   ├── colog.setup.md
│   ├── colog.log.md
│   ├── colog.save.md
│   └── colog.status.md
├── .colog/                       # Infrastructure (don't edit directly)
│   ├── skills/                      #   Agent rules
│   ├── prompts/                     #   Scheduled behaviors
│   ├── templates/                   #   Originals for sync
│   └── config.yaml                  #   Configuration
├── CLAUDE.md                        # Main agent prompt
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

## CLI Commands

```bash
colog init [path]       # Initialize a new project
colog setup             # CLI setup wizard (prefer /colog:setup)
colog update            # Pull latest templates
colog sync              # Show diffs between project and templates
colog version           # Show version
```

**Options:** `--agent <type>` (default: claude), `--lang en|de`

## Git is Optional

colog works with or without git. During setup, you're asked whether to use git. If disabled (`Enabled: no` in `colog/project.md`), all git operations (commits, status, log) are skipped. The unified log still works — it just doesn't auto-commit.

## License

MIT
