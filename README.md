# Personal Skills

Repository for personal Codex skills.

## Layout

```text
skills/
  <skill-name>/
    SKILL.md
    agents/openai.yaml
    scripts/
    references/
    assets/
```

Keep every skill self-contained under `skills/<skill-name>`.

## Create a Skill

Use the bundled helper:

```bash
./scripts/new-skill.sh my-skill
```

Add optional resource directories when needed:

```bash
./scripts/new-skill.sh my-skill scripts,references,assets
```

Validate a skill:

```bash
./scripts/validate-skill.sh skills/my-skill
```

## Install Locally

Codex discovers skills from `~/.codex/skills`. Symlink the skill directories you want active:

```bash
ln -s "$(pwd)/skills/my-skill" ~/.codex/skills/my-skill
```

If a skill changes significantly, run validation before using it in normal work.

