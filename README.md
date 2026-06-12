# Agent Skills

Personal repository for reusable agent skills across Codex, Claude, and other AI coding or workflow agents.

## Repository Layout

```text
skills/
  <skill-name>/
    SKILL.md              # required, platform-neutral instructions
    scripts/              # optional deterministic helpers
    references/           # optional docs loaded only when needed
    assets/               # optional templates, images, sample files
    metadata/             # optional platform-neutral or platform-specific metadata

templates/
  skill/                  # skeleton used by scripts/new-skill.sh

docs/
  conventions.md          # naming and authoring rules

platforms/
  codex/                  # optional Codex install or adapter notes
  claude/                 # optional Claude install or adapter notes
```

The source of truth is always `skills/<skill-name>/SKILL.md`. Platform-specific metadata should be additive and should not replace the core instructions.

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

For other agents, keep the same skill folder layout when possible and place platform-specific files under `metadata/` only when needed.

