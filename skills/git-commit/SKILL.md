---
name: git-commit
description: Guide Codex when creating Git commits that follow the Conventional Commits format with concise English messages. Use when the user asks Codex to commit code, make a git commit, submit the current task's changes, stage and commit related files, or generate a commit message for repository changes.
---

# Git Commit

## Goal

Create a clean Git commit for the current task. Include only changes that are related to the user's request and the work Codex performed in the current context, then write the commit message in the Conventional Commits format with concise, direct English. For larger changes, include a short commit body with a bullet summary of the main code changes.

## Workflow

1. Confirm the repository root with `git rev-parse --show-toplevel`.
2. Inspect the current Git state:
   - Run `git status --short`.
   - Check staged changes with `git diff --cached --stat` and `git diff --cached`.
   - Check unstaged changes with `git diff --stat` and inspect relevant diffs.
   - Check untracked files with `git ls-files --others --exclude-standard`.
3. Determine what should be committed:
   - Treat the current conversation, user request, and files Codex edited for that task as the primary commit boundary.
   - If the user named files, paths, or a scope, commit only those changes.
   - If the user simply says "commit", "提交", or similar, commit the changes related to the current task, not every dirty file in the repository.
   - Commit all dirty files only when the user explicitly asks to commit everything/all changes, and still exclude secrets, local config, dependency caches, logs, and unsupported build artifacts.
   - If changes were already staged before this request, verify whether they belong to the current task before including them. Unstage unrelated staged changes if needed, without discarding their content.
   - If the worktree contains unrelated or ambiguous changes, ask before staging them.
4. Stage the intended files with explicit paths whenever possible. Avoid broad staging commands when unrelated changes are present.
5. Re-check `git status --short` and `git diff --cached --stat` before committing.
6. Compose an English commit message that follows Conventional Commits:
   - Use `<type>(<scope>): <description>` when a clear scope exists.
   - Use `<type>: <description>` when no concise scope is obvious.
   - Use `<type>(<scope>)!: <description>` or `<type>!: <description>` for breaking changes.
   - Keep the description under 72 characters when practical.
   - Use imperative, present-tense English.
   - Do not end the description with a period.
7. Add a commit body only when the change is large, multi-part, or not obvious from the subject:
   - Leave a blank line after the subject.
   - Add `Summary:` followed by concise bullets.
   - Each bullet should describe a concrete code change or user-visible behavior.
   - Add footer lines after another blank line when needed, such as `BREAKING CHANGE: ...` or issue references.
8. Run `git commit` with the prepared message.
9. Verify the result with `git status --short` and `git log -1 --pretty=fuller --stat`.

## Conventional Commits Format

Use this structure:

```text
<type>[optional scope][optional !]: <description>

[optional body]

[optional footer(s)]
```

Use `!` after the type or scope when the commit introduces a breaking change. Also include a `BREAKING CHANGE:` footer that explains the migration impact when the staged diff shows an incompatible API, schema, CLI, config, protocol, or behavior change.

## Commit Types

Use the repository's configured Conventional Commits types when they exist. Otherwise prefer this widely used Conventional Commits type set:

- `feat`: user-facing feature or new capability
- `fix`: bug fix
- `docs`: documentation-only change
- `style`: formatting or style-only change with no behavior impact
- `refactor`: code restructuring with no behavior change
- `perf`: performance improvement
- `test`: tests only
- `build`: build system, dependencies, packaging, or lockfile changes
- `ci`: CI configuration or workflow changes
- `chore`: maintenance that does not fit other types
- `revert`: revert a previous commit

Choose the most specific type supported by the diff. Prefer `feat` or `fix` over `chore` when the code changes alter product behavior.

## Message Examples

Small focused change:

```text
fix(auth): preserve redirect after session refresh
```

Large multi-part change:

```text
feat(changelog): add bilingual release generation skill

Summary:
- Add workflow guidance for detecting release ranges and changelog files
- Define coverage rules for grouping user-visible changes
- Document bilingual output requirements for Chinese and English entries
```

## Safety Rules

- Do not amend, squash, reset, rebase, or force-push unless the user explicitly asks.
- Do not commit if no intended changes are staged.
- Do not invent details for the commit body. Base the message on the staged diff.
- If tests or verification were run before committing, mention them in the final response, not in the commit message unless the change itself is test-related.

## Final Response

Respond in the user's language. Include:

- The commit hash.
- The exact commit subject.
- A brief note about what was included.
- Any relevant verification or skipped checks.
