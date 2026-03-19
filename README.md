# clawlaborate

**Make collaboration part of your repo, not another tool.**

clawlaborate adds structured collaboration to any project through your AI coding agent. Instead of switching between Slack, Jira, Notion, and your IDE, the agent tracks everything in a single unified log — decisions, tasks, changes, ideas — all in plain Markdown inside your git repository.

Every team member keeps using their preferred tool. The AI agent handles the overhead.

## The Idea

Most collaboration overhead isn't the actual work — it's the meta-work: updating task boards, writing meeting notes, documenting decisions, keeping everyone informed.

clawlaborate replaces all of that with one concept: a **unified log**.

Every project event — a decision made, a task created, an idea proposed, a file changed — becomes a log entry. The agent reads and writes this log automatically. Tasks and project memory are just snapshots derived from the log.

```
collalog/log.md         ← the source of truth (all events, newest first)
collalog/tasks.md       ← snapshot: what's open, who owns it
collalog/project.md     ← project description, team, config
collalog/memory.md      ← optional: condensed project context
```

It works with any AI coding tool: Claude Code, Codex, Cursor, Gemini, Windsurf, Copilot, and 6 more. Skills are installed where your tool expects them.

## Quick Start

### 1. Install

```bash
git clone https://github.com/grothkopp/clawlaborate.git
export PATH="$PATH:$(pwd)/clawlaborate/bin"
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
- `collalog/` with log, tasks, and project files
- Skills in your agent's commands directory (e.g., `.claude/commands/collalog.*.md`)
- `.clawlaborate/` with templates, prompts, and config
- `CLAUDE.md` as the main agent prompt

### 3. Configure your project

```bash
collalog setup
```

The wizard asks for project name, description, team members (name + shortcut + role), technologies, and communication platform. It generates a customized `CLAUDE.md` and populates `collalog/project.md` and `collalog/tasks.md`.

### 4. Set up scheduled tasks

Configure these in your agent platform (Claude Code, OpenClaw, etc.):

- **Heartbeat** (every 30 min): Agent monitors conversations, updates log and tasks. See `.clawlaborate/prompts/heartbeat.md`
- **Morning briefing** (daily 8:00): Agent sends a summary of open tasks and recent activity. See `.clawlaborate/prompts/morning.md`

### 5. Work

```bash
git add -A && git commit -m "org: initialize project with clawlaborate"
```

Start working. The agent will:
- Log decisions, changes, ideas, and tasks to `collalog/log.md`
- Keep `collalog/tasks.md` in sync as a task snapshot
- Commit changes to git automatically
- Send a morning briefing daily

## Log Entry Types

| Type | Use for |
|------|---------|
| change | File created, modified, deleted |
| decision | Direction chosen, convention agreed |
| task | Task created, completed, reassigned |
| idea | Proposal, suggestion, something to explore |
| note | Context, observation, meeting summary |
| milestone | Phase completed, goal reached |

Each entry has: timestamp, author (@shortcut), type, title, description, and optional fields (affected files, related tasks).

## Project Structure

```
my-project/
├── collalog/                        # User-facing (all mutable content)
│   ├── log.md                       #   Unified log (source of truth)
│   ├── tasks.md                     #   Task snapshot
│   ├── project.md                   #   Project description + team
│   └── memory.md                    #   Optional memory snapshot
├── .claude/commands/                # Skills (Claude Code example)
│   ├── collalog.log.md
│   ├── collalog.git.md
│   ├── collalog.task-management.md
│   ├── collalog.memory.md
│   └── collalog.clawlaborate-sync.md
├── .clawlaborate/                   # Fixed elements (don't edit)
│   ├── config.yaml                  #   Configuration
│   ├── prompts/                     #   Scheduled agent behaviors
│   └── templates/                   #   Original templates (for sync)
├── CLAUDE.md                        # Main agent prompt
└── .gitignore
```

**Convention:** `collalog/` is for humans and agents (read + write). `.clawlaborate/` is infrastructure (don't edit directly).

## Supported Agents

| Agent | Commands Directory | File Pattern |
|-------|--------------------|--------------|
| Claude Code | `.claude/commands/` | `collalog.*.md` |
| Codex | `.codex/prompts/` | `collalog.*.md` |
| Cursor | `.cursor/commands/` | `collalog.*.md` |
| Gemini CLI | `.gemini/commands/` | `collalog.*.toml` |
| Windsurf | `.windsurf/workflows/` | `collalog.*.md` |
| GitHub Copilot | `.github/agents/` | `collalog.*.agent.md` |
| Kilo Code | `.kilocode/workflows/` | `collalog.*.md` |
| Roo | `.roo/commands/` | `collalog.*.md` |
| OpenCode | `.opencode/command/` | `collalog.*.md` |
| Kiro CLI | `.kiro/prompts/` | `collalog.*.md` |
| Amp | `.agents/commands/` | `collalog.*.md` |
| OpenClaw | `.clawlaborate/skills/` | `collalog.*.md` |

## Commands

```bash
collalog init [path]       # Initialize a new project
collalog setup             # Interactive project configuration
collalog update            # Pull latest templates (won't overwrite customizations)
collalog sync              # Show differences between project and templates
collalog version           # Show version
```

**Options:**
- `--agent <type>` — AI tool (default: `claude`). See supported agents above.
- `--lang en|de` — Language for generated files (default: `en`)

## Updating

```bash
collalog update    # Pulls new templates, flags modified files
collalog sync      # Shows diffs for review
```

## License

MIT
