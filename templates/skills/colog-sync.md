# Skill: Colog Sync

Rules for syncing skills, commands, and prompts with the colog template repository.

## Upstream (project -> colog repo)

When a command or skill has been improved and the improvement is generic:
1. Run `colog sync` to see diffs
2. Copy improved files to the colog repo's `templates/` directory
3. Commit and push

## Downstream (colog repo -> project)

When colog has new templates:
1. Run `colog update` — installs new files, flags modified ones
2. Run `colog sync` — review diffs
3. Accept or merge manually

## Rules

- Never blindly overwrite — always review diffs
- Project-specific customizations should be clearly marked
- Keep the generic version clean and universally applicable
