#!/usr/bin/env bash
set -euo pipefail

base_ref="${1:-}"
head_ref="${2:-HEAD}"

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

if [[ -z "$base_ref" ]]; then
  base_ref="$(git describe --tags --abbrev=0 "$head_ref" 2>/dev/null || true)"
fi

echo "# Repository"
echo "root: $repo_root"
echo "branch: $(git branch --show-current 2>/dev/null || true)"
echo "head: $(git rev-parse --short "$head_ref")"
echo "base: ${base_ref:-<not-detected>}"
echo

echo "# Changelog Candidates"
if command -v rg >/dev/null 2>&1; then
  rg --files | rg -i '(^|/)(change[-_ ]?log|release[-_ ]?notes|更新日志).*\.md$|(^|/)CHANGELOG(\..*)?$' || true
else
  find . -type f \( -iname '*changelog*' -o -iname '*release-notes*' -o -iname '*release_notes*' -o -name '*更新日志*' \) | sed 's#^\./##'
fi
echo

echo "# Tags"
git tag --sort=-creatordate | sed -n '1,30p' || true
echo

if [[ -n "$base_ref" ]]; then
  range="$base_ref..$head_ref"

  echo "# Commit Summary"
  git log --date=short --pretty=format:'%h %ad %an %s' "$range" || true
  echo
  echo

  echo "# Diff Stat"
  git diff --stat "$base_ref" "$head_ref" || true
  echo

  echo "# Changed Files"
  git diff --name-status "$base_ref" "$head_ref" || true
  echo

  echo "# Directory Summary"
  git diff --name-only "$base_ref" "$head_ref" \
    | awk -F/ 'NF == 1 { print "."; next } { print $1 "/" $2 }' \
    | sort \
    | uniq -c \
    | sort -nr || true
  echo
else
  echo "# Commit Summary"
  echo "No base ref detected. Provide a base tag, commit, or branch."
  echo
fi

echo "# Working Tree"
git status --short || true

