#!/usr/bin/env bash
# generate.sh — Template generation functions for collalog

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
gets a log entry here. Newest entries first.

## Commands

| Command | Description |
|---------|-------------|
| /collalog:setup | One-time project setup wizard |
| /collalog:log | Manually add a log entry |
| /collalog:save | Save current work (log changes + commit) |
| /collalog:status | Quick project overview |

## Skills

Agent rules in \`.collalog/skills/\` (always active):

| Skill | Description |
|-------|-------------|
| log-format | Log entry types, format, rules |
| git | Commit conventions |
| task-management | Task list as snapshot of the log |
| memory | Optional project memory snapshot |
| collalog-sync | Sync with collalog template repo |

## Prompts

Scheduled behaviors in \`.collalog/prompts/\`:

| Prompt | Schedule | Description |
|--------|----------|-------------|
| heartbeat | Every 30 min | Update log, tasks, memory from conversations |
| morning | Daily 8:00 | Daily summary: tasks, log activity, blockers |

## Workspace Structure

\`\`\`
collalog/
  log.md               Unified project log (source of truth)
  tasks.md             Task snapshot
  project.md           Project description, team
  memory.md            Optional memory snapshot
${commands_dir:-".claude/commands"}/
  collalog.*.md        Commands (user invokes these)
.collalog/
  skills/              Agent rules (always active)
  prompts/             Scheduled behaviors
  templates/           Original templates (for sync)
  config.yaml          Configuration
CLAUDE.md              This file
\`\`\`
CLAUDE_INNER

  echo "" >> "$output"
  echo "## Communication" >> "$output"
  if [[ -n "$comm" ]]; then
    echo "" >> "$output"
    echo "Primary channel: ${comm}" >> "$output"
  fi
  cat >> "$output" << 'CLAUDE_INNER'

All significant interactions should be logged in collalog/log.md.

## Formatting

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
  echo "" >> "$output"
  echo "## Schedule" >> "$output"
  echo "" >> "$output"
  echo "- Morning briefing: 08:00, weekdays" >> "$output"
  echo "- Heartbeat: every 30 min, 08:00-18:00, weekdays" >> "$output"
}

generate_tasks() {
  local config="$1" output="$2"
  local name=$(yaml_val "$config" "name")

  cat > "$output" << TASKS_INNER
# Tasks — ${name}

> Last updated: $(date +%Y-%m-%d)

## Setup
- [ ] Review and customize CLAUDE.md (created: $(date '+%Y-%m-%d %H:%M'))
- [ ] Set up heartbeat task (created: $(date '+%Y-%m-%d %H:%M'))
- [ ] Set up morning briefing task (created: $(date '+%Y-%m-%d %H:%M'))
- [ ] Initial git commit (created: $(date '+%Y-%m-%d %H:%M'))

## Content

## Research

## Tech
TASKS_INNER
}
