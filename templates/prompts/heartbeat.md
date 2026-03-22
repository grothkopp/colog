# Prompt: Heartbeat

> Paths and schedule: see CLAUDE.md → Configuration
> Default schedule: Every 30 minutes, 08:00-18:00, weekdays

## Purpose

Scheduled trigger for `/colog:sync`. Keeps the project in sync automatically.

## Steps

1. **Check working hours** — Read `colog/project.md` for schedule configuration.
   If outside working hours, do nothing and exit silently.
2. **Run `/colog:sync`** — This handles everything: pull, event detection,
   file changes, task sync, push, and notifications.

That's it. All logic lives in `/colog:sync`.
