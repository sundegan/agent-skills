# Skill Conventions

## Naming

- Use lowercase letters, digits, and hyphens only.
- Keep names short and action-oriented, for example `review-pr`, `query-logs`, or `draft-rfc`.
- Make the folder name match the `name` field in `SKILL.md`.

## Skill Folder Contract

Each skill must include:

```text
SKILL.md
```

Optional directories:

```text
scripts/      executable helpers for repeatable or fragile work
references/   detailed docs, schemas, examples, policies
assets/       templates, media, fixtures, boilerplate
metadata/     platform-specific metadata such as Codex or Claude adapter files
```

## SKILL.md

Use YAML frontmatter with at least:

```yaml
---
name: my-skill
description: What the skill does and when an agent should use it.
---
```

Keep the body concise. Put detailed reference material in `references/` and link to it from `SKILL.md`.

## Portability

- Keep `SKILL.md` platform-neutral.
- Put agent-specific install notes or metadata in `platforms/` or a skill-local `metadata/` folder.
- Prefer scripts for deterministic operations that agents would otherwise rewrite repeatedly.

