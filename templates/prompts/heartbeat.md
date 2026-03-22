# Prompt: Heartbeat

> Paths and schedule: see colog Configuration section
> Default schedule: Every 30 minutes, 08:00-18:00, weekdays

## Purpose

Scheduled trigger for `/colog:sync`. Keeps the project in sync automatically.

## Steps

1. **Check working hours** — Read `colog/project.md` for schedule configuration.
   If outside working hours, do nothing and exit silently.
2. **Run `/colog:sync --buffer 5m`** — This handles everything: pull, event
   detection, file changes, task sync, push, and notifications.
   The 5-minute buffer avoids conflicts with the agent's own real-time logging.

That's it. All logic lives in `/colog:sync`.
