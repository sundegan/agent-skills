#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <path-to-skill-folder>" >&2
  exit 2
fi

skill_dir="${1%/}"
skill_file="$skill_dir/SKILL.md"
folder_name="$(basename "$skill_dir")"

if [[ ! -f "$skill_file" ]]; then
  echo "Missing SKILL.md: $skill_file" >&2
  exit 1
fi

if [[ ! "$folder_name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "Invalid skill folder name: $folder_name" >&2
  exit 1
fi

frontmatter_end="$(awk 'NR > 1 && $0 == "---" { print NR; exit }' "$skill_file")"
if [[ -z "$frontmatter_end" ]]; then
  echo "SKILL.md must start with YAML frontmatter delimited by ---" >&2
  exit 1
fi

name="$(awk -F': *' 'NR > 1 && /^name:/ { print $2; exit }' "$skill_file" | tr -d '"')"
description="$(awk -F': *' 'NR > 1 && /^description:/ { print $2; exit }' "$skill_file" | tr -d '"')"

if [[ "$name" != "$folder_name" ]]; then
  echo "Frontmatter name must match folder name: expected $folder_name, got ${name:-<empty>}" >&2
  exit 1
fi

if [[ -z "$description" || "$description" == TODO:* ]]; then
  echo "Frontmatter description must be filled in." >&2
  exit 1
fi

echo "OK: $skill_dir"

