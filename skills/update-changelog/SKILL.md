---
name: update-changelog
description: Generate and update bilingual changelogs from code changes since the last published version. Use when the user asks to write, update, summarize, or maintain CHANGELOG/release notes by comparing the previous released version with the current repository state, merging related changes while preserving complete coverage and matching existing Chinese and English changelog style.
---

# Update Changelog

## Goal

Update the current repository's Chinese and English changelog files from the last published version to the current state. The changelog should cover the release as completely as practical: summarize related code changes together, but verify that every meaningful code change in the release range is either represented by a changelog entry or explicitly excluded for a clear reason.

Default to modifying changelog files in the target repository. Do not change product code while using this skill unless the user explicitly asks.

## Workflow

1. Determine the target repository root with `git rev-parse --show-toplevel`.
2. Identify changelog files:
   - Prefer files explicitly named by the user.
   - Otherwise search for files such as `CHANGELOG.md`, `CHANGELOG.zh*.md`, `CHANGELOG.en*.md`, `changelog*.md`, `RELEASE_NOTES.md`, `release-notes*.md`, or existing localized changelog names.
   - If both Chinese and English changelogs exist, update both. If one file contains both languages, preserve that layout.
   - If the repository has public website changelog pages or generated/static copies of the changelog, update those too unless the project clearly generates them from source files.
3. Determine the target release identity before drafting:
   - Use concrete version/date values. Take them from the user when provided; otherwise infer them from version files, release scripts/branches, tags, commit/tag metadata, existing changelog headings, release notes, and the change set.
   - Resolve relative dates to absolute dates. If preparing a release now and no better date evidence exists, use the current environment date. If version files still show the last release, infer the next version from change scope and project release pattern.
   - Do not leave version/date blank or use placeholders when a credible inference is possible. Ask only when evidence is insufficient; otherwise apply the inferred version/date consistently across Markdown changelogs, website/static copies, visible labels, dates, and release links.
4. Determine the release range:
   - Use the user-provided base tag, release version, branch, or commit when present.
   - Otherwise treat "last published version" as the latest reachable release tag from `HEAD`, using `git describe --tags --abbrev=0` as the first candidate.
   - Cross-check the latest changelog version heading against Git tags. If the latest changelog heading and latest tag disagree, inspect both and choose the one that clearly represents the last published version. Ask only if the base cannot be determined safely.
   - Use `HEAD` as the default target. Include uncommitted changes only when the user's wording includes current working state, "now", "当前", or when changelog files are being updated in an unreleased working tree.
5. Collect change evidence. Prefer running `scripts/collect_changelog_context.sh` from this skill if available:

   ```bash
   <skill-dir>/scripts/collect_changelog_context.sh [base-ref] [head-ref]
   ```

   Also read relevant diffs directly when the script output is too coarse.
6. Inspect existing changelog style before writing:
   - Version heading format, date format, ordering, bullet style, section names, language tone, and whether entries are grouped by feature/fix/breaking change/module.
   - Whether English and Chinese files are literal translations or independently localized summaries.
7. Build a coverage map before editing:
   - List commits, changed files, modules, public APIs, configs, schemas, migrations, user-visible behavior, and notable fixes in the range.
   - Create explicit coverage groups for major feature work, bug fixes, performance changes, architecture/refactor work, page styling/UI polish, documentation/website updates, build/release changes, and operator/integration changes.
   - Treat the coverage map as mandatory: every changed file, commit cluster, or high-level module change must map to a changelog item or to an explicit exclusion reason.
   - Group similar or tightly related changes into one changelog item.
   - Keep unrelated changes separate even if they touch nearby files.
   - Exclude pure tests, formatting, generated files, vendored dependencies, lockfile-only churn, and internal refactors only when they have no user-visible or operator-visible impact.
   - Do not discard large refactors, page/style rewrites, model-layer changes, worker changes, or website changes as "internal" until their practical impact has been checked against diffs and surrounding commits.
   - For each high-churn directory or large diff cluster, decide and record whether it is covered by a changelog entry or intentionally excluded.
   - Track when a fix or polish commit only stabilizes a new feature introduced earlier in the same release range. Usually fold that work into the new feature or improvement item rather than presenting it as a standalone "Fixed" entry.
8. Draft changelog entries:
   - Match the existing changelog's granularity and style.
   - Prefer outcome-focused summaries over raw implementation details.
   - Write for product users, operators, and integrators. Avoid unexplained UI operations, overly terse feature labels, internal implementation labels, commit-message shorthand, or code-level mechanics unless they are the public feature.
   - Prefer product-visible feature, page, or component names plus a plain description of what users can now do.
   - Internal refactors can be changelog-worthy when they materially improve performance, reliability, maintainability, architecture, or enable a user-visible capability. Describe the practical outcome, not just "refactor".
   - Page styling, website, documentation site, and responsive UI changes are changelog-worthy when they affect user-visible presentation or navigation; keep them separate from release packaging or build infrastructure.
   - Do not imply that a feature existed in the previous release by listing fixes to a newly introduced feature under a broad "Fixed" section. For new features, include same-range stabilization as part of the feature or improvement unless it fixes a regression from the last published release.
   - Mention breaking changes, migrations, compatibility changes, config changes, API contract changes, data model changes, and operational behavior changes explicitly.
   - Do not invent impact that is not supported by code evidence.
9. Update the changelog files:
   - Insert a new top entry for the target version or unreleased section according to existing style.
   - If the repository uses `Unreleased` and no concrete target version is known, update that section instead of creating a fake version. If a concrete target version is known, replace or add the formal version entry according to project style.
   - Keep Chinese and English entries aligned in coverage, ordering, and meaning.
10. Verify quality and completeness:
   - Reconcile every relevant changed file or commit group against the new changelog entries.
   - Check for unrepresented code changes before finishing. Do not rely on memory or commit messages alone; compare the changed-file list and major diff clusters against the final changelog.
   - If a change is omitted, record why it is intentionally excluded, such as tests-only, generated output, formatting-only, vendored/lockfile-only churn, or implementation detail with no release impact.
   - Re-read the updated changelog around the insertion point to ensure formatting and style match history.
   - Check that target version, date, release link labels/URLs, and localized visible text are consistent across all changelog surfaces.
   - Search the edited files for leftover placeholders such as `Unreleased`, `In progress`, `TBD`, `TODO`, `进行中`, or stale version numbers when a concrete release version was provided.
   - Read the "Fixed" section critically: each item should either be a regression/bug from a previous released version or a broadly understandable stability fix. Move same-release polish for newly added features into "Added" or "Improved".
   - Remove or rewrite unclear terms such as unexplained UI operations, overly short labels, internal filenames, or implementation-only jargon when they do not help users understand the release.
   - Run `git diff -- <changelog-files>` and inspect the final patch.

## Change Analysis Rules

- Use code diff evidence as the source of truth; do not rely only on commit messages.
- Merge related changes when they implement the same feature, fix the same behavior, or belong to one release-note-worthy capability.
- Preserve coverage: a merged item must still mention all distinct externally visible outcomes.
- Bias toward coverage first, then concise wording. It is acceptable to merge related details, but it is not acceptable to silently drop meaningful release changes.
- Large or cross-cutting changes require explicit consideration even when commit messages say `refactor`, `style`, `chore`, or `perf`. These labels often hide release-note-worthy architecture, performance, page styling, or workflow changes.
- Treat these as changelog-worthy unless clearly internal-only:
  - new features or user workflows
  - behavior changes
  - bug fixes
  - major architecture or model-layer refactors that improve performance, reliability, maintainability, or enable visible capabilities
  - large UI/page styling, layout, responsive, theme, or website changes visible to users
  - API, CLI, SDK, protocol, schema, event, or config changes
  - migrations, compatibility changes, deprecations, removals
  - dependency upgrades with observable runtime, security, or compatibility impact
  - operational changes such as logging, metrics, alerting, retry, timeout, rollout, or deployment behavior
- Usually omit:
  - tests with no behavior change
  - comments, formatting, lint-only changes
  - generated file churn that only reflects another already summarized source change
  - refactors that do not affect public, user, operator, integration behavior, performance, reliability, maintainability, or release architecture

## Release Note Quality Rules

- Target release metadata is part of the changelog. Do not omit the version or date when they are known.
- Important release changes must not be omitted merely because they are not new features. Performance work, architecture improvements, major refactors, page styling, and website/UI polish often belong under "Improved".
- "Added" should describe new capabilities introduced in this release.
- "Improved" should describe changed behavior, performance, usability, architecture, styling, docs/site improvements, or release process improvements.
- "Fixed" should primarily describe defects present in a previous released version. Avoid listing fixes for a feature that was introduced and stabilized within the same unreleased range unless users of a prior release could hit the bug.
- Avoid overly technical, overly terse, or context-dependent wording. Prefer clear user outcomes over raw interaction details, internal labels, abbreviations, or implementation shorthand. If a term requires product or codebase context to understand, rewrite it in plain language.
- Avoid broad buckets that mix unrelated work. For example, do not combine website responsive styling with release packaging unless the existing changelog style already does so.
- Prefer a smaller number of clear, coherent entries over a long list of commit-shaped bullets.
- Each bullet should answer: what changed, who benefits, and why it matters, without requiring the reader to know the commit history.

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
