#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $0 <skill-name> [scripts,references,assets]" >&2
  exit 2
fi

skill_name="$1"
resources="${2:-}"
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
creator="${CODEX_SKILL_CREATOR:-$HOME/.codex/skills/.system/skill-creator/scripts/init_skill.py}"

if [[ ! -f "$creator" ]]; then
  echo "Cannot find init_skill.py at: $creator" >&2
  echo "Set CODEX_SKILL_CREATOR to the correct path." >&2
  exit 1
fi

args=("$creator" "$skill_name" --path "$repo_root/skills")

if [[ -n "$resources" ]]; then
  args+=(--resources "$resources")
fi

python3 "${args[@]}"

