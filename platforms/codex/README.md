# Codex Adapter Notes

Codex discovers skills from `~/.codex/skills`.

Install one skill:

```bash
ln -s "$(git rev-parse --show-toplevel)/skills/my-skill" ~/.codex/skills/my-skill
```

Codex-compatible skills use `SKILL.md` frontmatter with `name` and `description`. Optional UI metadata can live in `metadata/codex/openai.yaml` or be copied to `agents/openai.yaml` if a Codex distribution requires that path.

