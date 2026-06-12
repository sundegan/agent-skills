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
template_dir="$repo_root/templates/skill"

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
sed "s/{{SKILL_NAME}}/$skill_name/g; s/{{SKILL_TITLE}}/$skill_title/g" "$template_dir/SKILL.md" > "$skill_dir/SKILL.md"
sed "s/{{SKILL_NAME}}/$skill_name/g" "$template_dir/metadata/skill.yaml" > "$skill_dir/metadata/skill.yaml"

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
