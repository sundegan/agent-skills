#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $0 <skill-name> [scripts,references,assets]" >&2
  exit 2
fi

skill_name="$1"
resources="${2:-}"
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
skill_dir="$repo_root/skills/$skill_name"

if [[ ! "$skill_name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "Skill name must use lowercase letters, digits, and hyphens only: $skill_name" >&2
  exit 1
fi

if [[ -e "$skill_dir" ]]; then
  echo "Skill already exists: $skill_dir" >&2
  exit 1
fi

mkdir -p "$skill_dir/metadata"

skill_title="$(printf '%s' "$skill_name" | awk -F'-' '{ for (i = 1; i <= NF; i++) { $i = toupper(substr($i, 1, 1)) substr($i, 2) } print }')"

cat > "$skill_dir/SKILL.md" <<EOF
---
name: $skill_name
description: TODO: Describe what this skill does and the specific user requests or contexts that should trigger it.
---

# $skill_title

## Workflow

1. TODO: Identify the task context and required inputs.
2. TODO: Use bundled resources only when they are relevant.
3. TODO: Validate the result before responding.

## Resources

- \`scripts/\`: deterministic helpers for repeatable or fragile work.
- \`references/\`: detailed docs, schemas, examples, or policies.
- \`assets/\`: templates, sample files, or media.
- \`metadata/\`: platform-specific metadata.
EOF

cat > "$skill_dir/metadata/skill.yaml" <<EOF
name: "$skill_name"
version: "0.1.0"
status: "draft"
owners: []
platforms: []
EOF

if [[ -n "$resources" ]]; then
  IFS=',' read -ra dirs <<< "$resources"
  for dir in "${dirs[@]}"; do
    case "$dir" in
      scripts|references|assets|metadata)
        mkdir -p "$skill_dir/$dir"
        ;;
      *)
        echo "Unsupported resource directory: $dir" >&2
        exit 1
        ;;
    esac
  done
fi

echo "Created $skill_dir"
