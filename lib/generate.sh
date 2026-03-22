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
  grep -A2 -- '- name:' "$file" 2>/dev/null | paste -d'|' - - - | \
    sed 's/.*name: "//;s/".*shortcut: "/ | /;s/".*role: "/ | /;s/".*//' || true
}

generate_colog_section() {
  local config="$1" section_file="$2"

  local lang=$(yaml_val "$config" "language")
  local comm=$(yaml_val "$config" "communication")
  local commands_dir=$(yaml_top_val "$config" "commands_dir")

  cat > "$section_file" << COLOG_INNER
<!-- colog:start -->

## Git as Log

The git history IS the project log. Every meaningful event — changes, decisions,
tasks, ideas, notes, milestones — is a git commit with a semantic message:

\`\`\`
type(subject): short description @user
\`\`\`

Types: \`change\`, \`decision\`, \`task\`, \`idea\`, \`note\`, \`milestone\`

Use empty commits (\`git commit --allow-empty\`) for events without file changes:
questions, decisions, ideas, observations.

Read the log with: \`git log --oneline\`, \`git log --since="24 hours ago"\`,
\`git log --grep="^decision"\`, \`git log --grep="@SG"\`.

## Commands

User-invokable commands (e.g., in Claude Code: \`/project:colog.setup\`):

| Command | Description |
|---------|-------------|
| /colog:setup | One-time project setup wizard |
| /colog:log | Log an event (creates a commit) |
| /colog:save | Save current work (stage + semantic commits) |
| /colog:sync | Pull, sync tasks ↔ git, push |
| /colog:status | Project overview (optional: \`yesterday\`, \`last week\`) |
| /colog:ask | Ask about project history, decisions, changes |

## Skills

Agent rules in \`.colog/skills/\` (always active, not directly invoked):

| Skill | Description |
|-------|-------------|
| git | Semantic commit format, reading the log, common actions |
| ask | Searching the project history (git log, blame, pickaxe) |
| task-management | Task list as snapshot with commit references |
| memory | Optional project memory snapshot |
| colog-sync | Sync with colog template repo |

## Prompts

Scheduled agent behaviors in \`.colog/prompts/\`:

| Prompt | Schedule | Description |
|--------|----------|-------------|
| heartbeat | Every 30 min | Runs /colog:sync, commits events from conversations |
| morning | Daily 8:00 | Runs /colog:sync + /colog:status yesterday, sends daily briefing |

## Current User

Read \`colog/me.md\` for the current user's identity (name, shortcut, email).
Use the shortcut in commit messages (\`@Shortcut\`). This file is local and gitignored.
If it doesn't exist, ask the user to run \`/colog:setup\` or use \`@Agent\`.

IMPORTANT: Do not rely on \`git config user.name\` for identity — the git user
may always be the agent. Always use \`--author="First Last <email>"\` from me.md
when creating commits, so git correctly attributes them. The \`@user\` shortcut
in commit messages is the human-readable identifier.

## Workspace Structure

\`\`\`
colog/
  tasks.md             Task snapshot (with commit references)
  project.md           Project description, team, config
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

The agent communicates with the team through the configured messaging platform.
All significant interactions should be committed to git.

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

  # Never overwrite existing tasks — users add their own
  if [[ -f "$output" ]]; then
    return 0
  fi

  cat > "$output" << TASKS_INNER
# Tasks — ${name}

> Last updated: $(date +%Y-%m-%d)

## Setup
- [ ] Review and customize CLAUDE.md
- [ ] Review agent skills
- [ ] Set up heartbeat task
- [ ] Set up morning briefing task

## Content

## Research

## Tech
TASKS_INNER
}
