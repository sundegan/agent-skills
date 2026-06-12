#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <path-to-skill-folder>" >&2
  exit 2
fi

skill_path="$1"
validator="${CODEX_SKILL_VALIDATOR:-$HOME/.codex/skills/.system/skill-creator/scripts/quick_validate.py}"

if [[ ! -f "$validator" ]]; then
  echo "Cannot find quick_validate.py at: $validator" >&2
  echo "Set CODEX_SKILL_VALIDATOR to the correct path." >&2
  exit 1
fi

python3 "$validator" "$skill_path"

