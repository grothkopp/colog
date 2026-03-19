# collalog

**Make collaboration part of your repo, not another tool.**

collalog adds structured collaboration to any project through your AI coding agent. Instead of switching between Slack, Jira, Notion, and your IDE, the agent tracks everything in a single unified log — decisions, tasks, changes, ideas — all in plain Markdown inside your git repository.

Every team member keeps using their preferred tool. The AI agent handles the overhead.

## The Idea

Most collaboration overhead isn't the actual work — it's the meta-work: updating task boards, writing meeting notes, documenting decisions, keeping everyone informed.

collalog replaces all of that with one concept: a **unified log**.

Every project event — a decision made, a task created, an idea proposed, a file changed — becomes a log entry. The agent reads and writes this log automatically. Tasks and project memory are snapshots derived from the log.

```
collalog/log.md         ← the source of truth (all events, newest first)
collalog/tasks.md       ← snapshot: what's open, who owns it
collalog/project.md     ← project description, team, config
collalog/me.md          ← who am I? (local, gitignored)
collalog/memory.md      ← optional: condensed project context
```

## Quick Start

### 1. Install

```bash
git clone https://github.com/grothkopp/collalog.git
export PATH="$PATH:$(pwd)/collalog/bin"
```

### 2. Initialize your project

```bash
cd my-project
collalog init .

# For a different AI tool:
collalog --agent codex init .
collalog --agent cursor init .
```

This creates:
- `collalog/` with log, tasks, and project files (user-facing data)
- Commands in your agent's directory (e.g., `.claude/commands/collalog.*.md`)
- `.collalog/` with skills, prompts, templates, and config (infrastructure)
- `CLAUDE.md` as the main agent prompt

### 3. Set up your project

Run the setup command inside your AI agent:

```
/collalog:setup
```

The agent will ask about your project name, team members, technologies, and communication platform. It also creates a local `collalog/me.md` to identify you (gitignored — not shared). For existing projects, it can import history from git log and project files.

Or use the CLI fallback: `collalog setup`

### 4. Set up scheduled tasks

Configure these in your agent platform:

- **Heartbeat** (every 30 min): Agent monitors conversations, updates log + tasks
- **Morning briefing** (daily 8:00): Summary of open tasks and recent activity

Prompt files are in `.collalog/prompts/`.

### 5. Work

```
/collalog:log We decided to use TypeScript    # Log something manually
/collalog:save                                 # Save current work + commit
/collalog:status                               # Quick project overview
```

The agent also logs automatically via the heartbeat prompt.

## Commands, Skills, Prompts

collalog separates functionality into three categories:

### Commands (user-invokable)

Installed in the agent's commands directory. You trigger these explicitly.

| Command | What it does |
|---------|-------------|
| `/collalog:setup` | One-time project setup. Asks questions, populates project.md, optionally imports from git log |
| `/collalog:log` | Manually add a log entry. Infers type from what you say |
| `/collalog:save` | Detect changes, create log entries, commit (if git enabled) |
| `/collalog:status` | Show open tasks, recent activity, git status (if git enabled) |

### Skills (agent rules)

Stored in `.collalog/skills/`. These are rules the agent always follows — not directly invoked.

| Skill | What it governs |
|-------|----------------|
| log-format | Log entry types, format, structure |
| git | Commit message format and conventions |
| task-management | How the task list stays in sync with the log |
| memory | When and how to maintain the optional memory file |
| collalog-sync | How to sync with the collalog template repo |

### Prompts (scheduled)

Stored in `.collalog/prompts/`. These run automatically on a schedule.

| Prompt | Schedule | What it does |
|--------|----------|-------------|
| heartbeat | Every 30 min | Reads conversations, updates log + tasks + memory |
| morning | Daily 8:00 | Sends daily summary to the team |

## Project Structure

```
my-project/
├── collalog/                        # User-facing (all mutable data)
│   ├── log.md                       #   Unified log (source of truth)
│   ├── tasks.md                     #   Task snapshot
│   ├── project.md                   #   Project description + team
│   ├── me.md                        #   Current user identity (local, gitignored)
│   └── memory.md                    #   Optional memory snapshot
├── .claude/commands/                # Commands (Claude Code example)
│   ├── collalog.setup.md
│   ├── collalog.log.md
│   ├── collalog.save.md
│   └── collalog.status.md
├── .collalog/                       # Infrastructure (don't edit directly)
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
| OpenClaw | `.collalog/commands/` |

## CLI Commands

```bash
collalog init [path]       # Initialize a new project
collalog setup             # CLI setup wizard (prefer /collalog:setup)
collalog update            # Pull latest templates
collalog sync              # Show diffs between project and templates
collalog version           # Show version
```

**Options:** `--agent <type>` (default: claude), `--lang en|de`

## Git is Optional

collalog works with or without git. During setup, you're asked whether to use git. If disabled (`Enabled: no` in `collalog/project.md`), all git operations (commits, status, log) are skipped. The unified log still works — it just doesn't auto-commit.

## License

MIT
