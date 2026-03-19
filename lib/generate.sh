#!/usr/bin/env bash
# generate.sh — Template generation functions for clawlaborate

yaml_val() {
  local file="$1" key="$2"
  grep "^  $key:" "$file" 2>/dev/null | head -1 | sed 's/.*: "//' | tr -d '"' || echo ""
}

yaml_top_val() {
  local file="$1" key="$2"
  grep "^$key:" "$file" 2>/dev/null | head -1 | sed 's/.*: "//' | tr -d '"' || echo ""
}

get_team() {
  local file="$1"
  grep -A2 '- name:' "$file" 2>/dev/null | paste -d'|' - - - | \
    sed 's/.*name: "//;s/".*shortcut: "/ | /;s/".*role: "/ | /;s/".*//' || true
}

# ─── CLAUDE.md Generator ────────────────────────────────────────────────────

generate_claude_md() {
  local config="$1" output="$2"

  local name=$(yaml_val "$config" "name")
  local desc=$(yaml_val "$config" "description")
  local lang=$(yaml_val "$config" "language")
  local tech=$(yaml_val "$config" "technologies")
  local comm=$(yaml_val "$config" "communication")
  local commands_dir=$(yaml_top_val "$config" "commands_dir")

  cat > "$output" << CLAUDE_INNER
# ${name}

${desc}

## Team

| Name | Shortcut | Role |
|------|----------|------|
CLAUDE_INNER

  while IFS='|' read -r tname tshort trole; do
    [[ -z "$tname" ]] && continue
    tname=$(echo "$tname" | xargs)
    tshort=$(echo "$tshort" | xargs)
    trole=$(echo "$trole" | xargs)
    echo "| ${tname} | ${tshort} | ${trole} |" >> "$output"
  done < <(get_team "$config")

  cat >> "$output" << CLAUDE_INNER

## Unified Log

The central project log lives at \`collalog/log.md\`. Every meaningful event
(changes, decisions, tasks, ideas, notes, milestones) gets a log entry here.
Newest entries first.

## Skills

Skills are installed in \`${commands_dir:-".claude/commands"}/\`:

| Skill | Description |
|-------|-------------|
| log | Unified log format and entry types |
| git | Version control conventions and commit format |
| task-management | Task list as snapshot of the log |
| memory | Optional project memory snapshot |
| clawlaborate-sync | Sync skills with clawlaborate templates |

## Prompts

Scheduled agent behaviors in \`.clawlaborate/prompts/\`:

| Prompt | Schedule | Description |
|--------|----------|-------------|
| heartbeat | Every 30 min | Update log, tasks, memory from conversations |
| morning | Daily 8:00 | Daily summary: tasks, log activity, blockers |

## Workspace Structure

\`\`\`
collalog/
  log.md               Unified project log (the source of truth)
  tasks.md             Task snapshot (derived from log)
  project.md           Project description, team, config
  memory.md            Optional project memory snapshot
${commands_dir:-".claude/commands"}/
  collalog.*.md        Skills (agent reads these)
.clawlaborate/
  config.yaml          Configuration
  prompts/             Scheduled agent behaviors
  templates/           Original templates (for sync)
CLAUDE.md              This file
\`\`\`

## Communication
CLAUDE_INNER

  if [[ -n "$comm" ]]; then
    echo "" >> "$output"
    echo "Primary channel: ${comm}" >> "$output"
  fi

  cat >> "$output" << 'CLAUDE_INNER'

The agent communicates with the team through the configured messaging platform.
All significant interactions should be logged in collalog/log.md.

## Formatting

- Use proper Unicode characters where applicable
- No emojis
- Keep messages concise and actionable
CLAUDE_INNER

  if [[ "$lang" == "de" ]]; then
    echo "- Use proper German Umlauts: ÄÖÜäöüß" >> "$output"
  fi

  if [[ -n "$tech" ]]; then
    echo "" >> "$output"
    echo "## Technologies" >> "$output"
    echo "" >> "$output"
    echo "${tech}" >> "$output"
  fi
}

# ─── Collalog File Generators ────────────────────────────────────────────────

generate_project_md() {
  local config="$1" output="$2"
  local name=$(yaml_val "$config" "name")
  local desc=$(yaml_val "$config" "description")
  local tech=$(yaml_val "$config" "technologies")
  local comm=$(yaml_val "$config" "communication")

  cat > "$output" << PROJECT_INNER
# Project: ${name}

## Description

${desc}

## Team

| Name | Shortcut | Role |
|------|----------|------|
PROJECT_INNER

  while IFS='|' read -r tname tshort trole; do
    [[ -z "$tname" ]] && continue
    tname=$(echo "$tname" | xargs)
    tshort=$(echo "$tshort" | xargs)
    trole=$(echo "$trole" | xargs)
    echo "| ${tname} | ${tshort} | ${trole} |" >> "$output"
  done < <(get_team "$config")

  echo "" >> "$output"
  echo "## Technologies" >> "$output"
  echo "" >> "$output"
  echo "${tech:-TBD}" >> "$output"
  echo "" >> "$output"
  echo "## Communication" >> "$output"
  echo "" >> "$output"
  echo "${comm:-TBD}" >> "$output"
}

generate_tasks() {
  local config="$1" output="$2"
  local name=$(yaml_val "$config" "name")

  cat > "$output" << TASKS_INNER
# Tasks — ${name}

> Last updated: $(date +%Y-%m-%d)

## Setup
- [ ] Review and customize CLAUDE.md
- [ ] Review agent skills
- [ ] Set up heartbeat task (every 30 min)
- [ ] Set up morning briefing task (daily 8:00)
- [ ] Initial git commit

## Content

## Research

## Tech
TASKS_INNER
}
