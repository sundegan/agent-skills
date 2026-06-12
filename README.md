# Agent Skills

Personal repository for reusable agent skills across Codex, Claude, and other AI coding or workflow agents.

Put usable skills under `skills/<skill-name>/`. Each skill's source of truth is `SKILL.md`; optional helper resources live beside it.

## Create a Skill

```bash
./scripts/new-skill.sh my-skill
```

Add optional resource directories:

```bash
./scripts/new-skill.sh my-skill scripts,references,assets
```

Validate a skill:

```bash
./scripts/validate-skill.sh skills/my-skill
```

## Install for an Agent

For agents that read a skills directory directly, symlink or copy individual skill folders from `skills/`.

Example for Codex:

```bash
ln -s "$(pwd)/skills/my-skill" ~/.codex/skills/my-skill
```

For other agents, keep the same skill folder layout when possible. Put platform-specific metadata under the skill's `metadata/` directory only when needed.
