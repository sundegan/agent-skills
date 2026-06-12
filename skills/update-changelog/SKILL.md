---
name: update-changelog
description: Generate and update bilingual changelogs from code changes since the last published version. Use when the user asks to write, update, summarize, or maintain CHANGELOG/release notes by comparing the previous released version with the current repository state, merging related changes while preserving complete coverage and matching existing Chinese and English changelog style.
---

# Update Changelog

## Goal

Update the current repository's Chinese and English changelog files from the last published version to the current state. Summarize related code changes together, but verify that every relevant code change in the release range is represented.

Default to modifying changelog files in the target repository. Do not change product code while using this skill unless the user explicitly asks.

## Workflow

1. Determine the target repository root with `git rev-parse --show-toplevel`.
2. Identify changelog files:
   - Prefer files explicitly named by the user.
   - Otherwise search for files such as `CHANGELOG.md`, `CHANGELOG.zh*.md`, `CHANGELOG.en*.md`, `changelog*.md`, `RELEASE_NOTES.md`, `release-notes*.md`, or existing localized changelog names.
   - If both Chinese and English changelogs exist, update both. If one file contains both languages, preserve that layout.
3. Determine the release range:
   - Use the user-provided base tag, release version, branch, or commit when present.
   - Otherwise treat "last published version" as the latest reachable release tag from `HEAD`, using `git describe --tags --abbrev=0` as the first candidate.
   - Cross-check the latest changelog version heading against Git tags. If the latest changelog heading and latest tag disagree, inspect both and choose the one that clearly represents the last published version. Ask only if the base cannot be determined safely.
   - Use `HEAD` as the default target. Include uncommitted changes only when the user's wording includes current working state, "now", "当前", or when changelog files are being updated in an unreleased working tree.
4. Collect change evidence. Prefer running `scripts/collect_changelog_context.sh` from this skill if available:

   ```bash
   <skill-dir>/scripts/collect_changelog_context.sh [base-ref] [head-ref]
   ```

   Also read relevant diffs directly when the script output is too coarse.
5. Inspect existing changelog style before writing:
   - Version heading format, date format, ordering, bullet style, section names, language tone, and whether entries are grouped by feature/fix/breaking change/module.
   - Whether English and Chinese files are literal translations or independently localized summaries.
6. Build a coverage map before editing:
   - List commits, changed files, modules, public APIs, configs, schemas, migrations, user-visible behavior, and notable fixes in the range.
   - Group similar or tightly related changes into one changelog item.
   - Keep unrelated changes separate even if they touch nearby files.
   - Exclude pure tests, formatting, generated files, vendored dependencies, lockfile-only churn, and internal refactors only when they have no user-visible or operator-visible impact.
7. Draft changelog entries:
   - Match the existing changelog's granularity and style.
   - Prefer outcome-focused summaries over raw implementation details.
   - Mention breaking changes, migrations, compatibility changes, config changes, API contract changes, data model changes, and operational behavior changes explicitly.
   - Do not invent impact that is not supported by code evidence.
8. Update the changelog files:
   - Insert a new top entry for the target version or unreleased section according to existing style.
   - If the repository uses `Unreleased`, update that section instead of creating a fake version.
   - Keep Chinese and English entries aligned in coverage, ordering, and meaning.
9. Verify completeness:
   - Reconcile every relevant changed file or commit group against the new changelog entries.
   - Re-read the updated changelog around the insertion point to ensure formatting and style match history.
   - Run `git diff -- <changelog-files>` and inspect the final patch.

## Change Analysis Rules

- Use code diff evidence as the source of truth; do not rely only on commit messages.
- Merge related changes when they implement the same feature, fix the same behavior, or belong to one release-note-worthy capability.
- Preserve coverage: a merged item must still mention all distinct externally visible outcomes.
- Treat these as changelog-worthy unless clearly internal-only:
  - new features or user workflows
  - behavior changes
  - bug fixes
  - API, CLI, SDK, protocol, schema, event, or config changes
  - migrations, compatibility changes, deprecations, removals
  - dependency upgrades with observable runtime, security, or compatibility impact
  - operational changes such as logging, metrics, alerting, retry, timeout, rollout, or deployment behavior
- Usually omit:
  - tests with no behavior change
  - comments, formatting, lint-only changes
  - generated file churn that only reflects another already summarized source change
  - refactors that do not affect public, user, operator, or integration behavior

## Bilingual Output Rules

- For Chinese changelogs, use concise Simplified Chinese unless the existing file uses another Chinese style.
- For English changelogs, use concise release-note English.
- Keep technical identifiers, API names, config keys, file formats, enum values, and product names unchanged.
- Ensure Chinese and English versions cover the same change groups even when phrasing differs.
- Do not machine-translate blindly; adapt to each file's historical style.

## Handling Missing Context

- If no tag exists, infer the base from the latest changelog entry or ask the user for the last released version.
- If no changelog exists, ask whether to create one and which languages to include.
- If the diff is too large to inspect fully in one pass, summarize by module first, then drill into high-impact directories and public surfaces until every changed file is either covered or intentionally excluded.
- If generated files dominate the diff, identify their source files and summarize the source-level change.

## Final Response

Respond in the user's language. Include:

- The release range used.
- The changelog file paths updated.
- A concise summary of the main grouped changes.
- Any files or commits intentionally excluded from changelog coverage.
- Verification performed, especially the final `git diff -- <changelog-files>` inspection.

