#!/usr/bin/env bash
# generate.sh — Template generation functions for colog

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

generate_colog_section() {
  local config="$1" section_file="$2"

  local lang=$(yaml_val "$config" "language")
  local comm=$(yaml_val "$config" "communication")
  local commands_dir=$(yaml_top_val "$config" "commands_dir")

  cat > "$section_file" << COLOG_INNER
<!-- colog:start -->

## Current User

Read \`colog/me.md\` for the current user's identity (name, shortcut, email).
Use the shortcut for log entries and task ownership. This file is local and gitignored.
If it doesn't exist, ask the user to run \`/colog:setup\` or use \`@Agent\`.

## Git

Check \`colog/project.md\` → \`## Git\` → \`Enabled:\` before running any git command.
If \`Enabled: no\`, skip ALL git operations (commits, status, log, push) silently.

## Unified Log

The central project log lives at \`colog/log.md\`. Every meaningful event
gets a log entry here. Newest entries first.

**Important:** NEVER read the entire log file or rewrite it to add entries.
Use the efficient shell operations described in the log-format skill:
prepend via temp file + cat, read recent entries via awk/grep.

## Commands

| Command | Description |
|---------|-------------|
| /colog:setup | One-time project setup wizard |
| /colog:log | Manually add a log entry |
| /colog:save | Save current work (log changes + commit) |
| /colog:status | Quick project overview |

## Skills

Agent rules in \`.colog/skills/\` (always active):

| Skill | Description |
|-------|-------------|
| log-format | Log entry types, format, rules |
| git | Commit conventions |
| task-management | Task list as snapshot of the log |
| memory | Optional project memory snapshot |
| colog-sync | Sync with colog template repo |

## Prompts

Scheduled behaviors in \`.colog/prompts/\`:

| Prompt | Schedule | Description |
|--------|----------|-------------|
| heartbeat | Every 30 min | Update log, tasks, memory from conversations |
| morning | Daily 8:00 | Daily summary: tasks, log activity, blockers |

## Workspace Structure

\`\`\`
colog/
  log.md               Unified project log (source of truth)
  tasks.md             Task snapshot
  project.md           Project description, team
  me.md                Current user identity (local, gitignored)
  memory.md            Optional memory snapshot
${commands_dir:-".claude/commands"}/
  colog.*.md        Commands (user invokes these)
.colog/
  skills/              Agent rules (always active)
  prompts/             Scheduled behaviors
  templates/           Original templates (for sync)
  config.yaml          Configuration
CLAUDE.md              This file
\`\`\`

## Communication
COLOG_INNER

  if [[ -n "$comm" ]]; then
    echo "" >> "$section_file"
    echo "Primary channel: ${comm}" >> "$section_file"
  fi
  cat >> "$section_file" << 'COLOG_INNER'

All significant interactions should be logged in colog/log.md.

## Formatting

- No emojis
- Keep messages concise and actionable
COLOG_INNER

  if [[ "$lang" == "de" ]]; then
    echo "- Use proper German Umlauts: ÄÖÜäöüß" >> "$section_file"
  fi

  echo "" >> "$section_file"
  echo "<!-- colog:end -->" >> "$section_file"
}

upsert_colog_section() {
  local output="$1" section_file="$2"

  if [[ ! -f "$output" ]]; then
    # No CLAUDE.md exists — use section as is
    cp "$section_file" "$output"
  elif grep -q "<!-- colog:start -->" "$output"; then
    # Replace existing colog section between markers
    local tmp="${output}.tmp"
    awk '
      /^<!-- colog:start -->/ { skip=1; next }
      /^<!-- colog:end -->/ { skip=0; next }
      !skip { print }
    ' "$output" > "$tmp"
    # Find where the section was (append at end if empty file remains)
    # Insert colog section at the position where old content was removed
    # Simple approach: content before markers is preserved above, append section + remaining
    local before="${output}.before"
    local after="${output}.after"
    sed -n '1,/<!-- colog:start -->/p' "$output" | head -n -1 > "$before"
    sed -n '/<!-- colog:end -->/,$p' "$output" | tail -n +2 > "$after"
    cat "$before" "$section_file" "$after" > "$output"
    rm -f "$before" "$after" "$tmp"
  else
    # CLAUDE.md exists but has no colog markers — append
    echo "" >> "$output"
    cat "$section_file" >> "$output"
  fi
}

generate_claude_md() {
  local config="$1" output="$2"

  local name=$(yaml_val "$config" "name")
  local desc=$(yaml_val "$config" "description")
  local tech=$(yaml_val "$config" "technologies")

  # Generate the colog section to a temp file
  local section_file
  section_file=$(mktemp)
  generate_colog_section "$config" "$section_file"

  if [[ ! -f "$output" ]] || ! grep -q "<!-- colog:start -->" "$output"; then
    # No existing CLAUDE.md or no markers — check if it's a colog-created file
    if [[ ! -f "$output" ]]; then
      # Create fresh: project header + colog section
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

      if [[ -n "$tech" ]]; then
        echo "" >> "$output"
        echo "## Technologies" >> "$output"
        echo "" >> "$output"
        echo "${tech}" >> "$output"
      fi

      echo "" >> "$output"
      cat "$section_file" >> "$output"
    else
      # Existing CLAUDE.md without markers — append colog section
      echo "" >> "$output"
      cat "$section_file" >> "$output"
    fi
  else
    # Has markers — replace colog section, preserve everything else
    upsert_colog_section "$output" "$section_file"
  fi

  rm -f "$section_file"
}

generate_project_md() {
  local config="$1" output="$2"
  local name=$(yaml_val "$config" "name")
  local desc=$(yaml_val "$config" "description")
  local tech=$(yaml_val "$config" "technologies")
  local comm=$(yaml_val "$config" "communication")
  local git_enabled=$(yaml_top_val "$config" "git_enabled")
  git_enabled="${git_enabled:-yes}"

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
  echo "## Git" >> "$output"
  echo "" >> "$output"
  echo "- Enabled: ${git_enabled}" >> "$output"
  echo "" >> "$output"
  echo "## Schedule" >> "$output"
  echo "" >> "$output"
  echo "- Morning briefing: 08:00, weekdays" >> "$output"
  echo "- Heartbeat: every 30 min, 08:00-18:00, weekdays" >> "$output"
}

generate_tasks() {
  local config="$1" output="$2"
  local name=$(yaml_val "$config" "name")

  # Never overwrite existing tasks — users add their own
  if [[ -f "$output" ]]; then
    return 0
  fi

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
