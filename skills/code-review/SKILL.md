---
name: code-review
description: Review the current task's code-file changes for bugs, regressions, serious performance problems, inconsistent style, readability, maintainability, controlled impact on existing behavior, and dead or unused code while ignoring non-code changes such as documentation-only updates, node_modules, and Go vendor directories. Use when the user asks Agent to review, audit, inspect, or clean up the current code changes before finishing, committing, or opening a PR.
---

# Code Review

## Goal

Review the code-file changes related to the current task, identify meaningful issues, and clean up dead or unused code when it is safe to do so. Focus on problems that could affect correctness, existing behavior, performance, consistency, readability, or long-term maintenance. Ignore changes that do not affect code behavior, such as documentation-only edits, dependency directories, vendored code, generated artifacts, and formatting output unless they directly affect the current code change. Ensure the change's impact is understood, intentional, and controlled. Avoid spending user attention on low-impact speculation.

## Workflow

1. Determine the review scope:
   - Use the current conversation, user request, and files Agent changed as the primary boundary.
   - Run `git status --short` and inspect staged, unstaged, and untracked task-related files.
   - Focus review on source code, tests, build scripts, runtime configuration, schema or migration files, and other files that can change runtime, build, deployment, or developer workflow behavior.
   - Exclude documentation-only changes, examples that do not execute, formatting-only generated output, dependency caches, vendored dependency trees, and external code directories such as `node_modules/`, `vendor/`, `third_party/`, `.venv/`, `dist/`, `build/`, and generated lockstep artifacts unless the user explicitly asks to review them or they directly affect the code change.
   - If unrelated user changes exist, leave them untouched and exclude them from review unless they affect the current task.
2. Understand the intended behavior:
   - Re-read the user's request and any implementation notes.
   - Inspect nearby existing code to learn local patterns, naming, error handling, tests, and architecture.
   - Prefer repository conventions over generic style preferences.
3. Review the diff and relevant surrounding code:
   - Use `git diff`, `git diff --cached`, and targeted file reads.
   - Filter the diff to review code-relevant files first; mention skipped non-code paths only when useful for transparency.
   - Trace call sites, imports, exports, tests, configuration, and public interfaces touched by the task.
   - For frontend or UI changes, check state, rendering conditions, layout assumptions, accessibility basics, and interaction flow.
4. Assess impact on existing functionality:
   - Identify existing workflows, APIs, commands, data flows, schemas, persisted data, configs, and integrations touched by the change.
   - Check whether behavior changes are intentional, documented by the user's request, and limited to the expected scope.
   - Look for compatibility issues, changed defaults, altered error handling, changed ordering, changed timing, or changed side effects.
   - Verify tests or call sites cover the important existing behavior that could regress.
   - If the impact is broader than the task requires, narrow the implementation or report the risk clearly.
5. Prioritize findings:
   - Correctness bugs, regressions, data loss, security exposure, broken API contracts, and failing edge cases.
   - Serious performance problems such as new repeated expensive work, accidental N+1 behavior, unbounded loops, avoidable re-renders in hot paths, or large synchronous work on critical paths.
   - Uncontrolled or unnecessary impact on existing functionality.
   - Code style inconsistency that makes the change harder to maintain or contradicts clear local conventions.
   - Readability and maintainability problems such as unclear control flow, duplicated logic, leaky abstractions, or overly broad changes.
   - Dead or unused code, including unused imports, variables, functions, components, files, branches, feature flags, stale comments, and unreachable logic.
6. Ignore low-value issues:
   - Ignore changes that are unrelated to code behavior, including docs-only updates and dependency/vendor directories, unless they introduce a release, build, packaging, or runtime risk.
   - Do not raise speculative null-pointer or undefined-value concerns when the surrounding code or data flow makes them unrealistic.
   - Do not nitpick formatting that the repository's formatter will handle.
   - Do not ask for abstractions, renames, or micro-optimizations unless they materially improve maintainability or correctness.
   - Do not report issues unrelated to the current task unless they are severe and directly block the change.
7. Clean up safe dead code:
   - Remove unused imports, variables, functions, branches, stale comments, and unused files introduced by the current task.
   - Remove pre-existing dead code only when it is clearly made obsolete by the current task or is directly adjacent and safe to clean.
   - If removal could change public API, migrations, generated files, or external behavior, report it instead of deleting it unless the user explicitly asks.
8. Apply fixes for clear issues within scope:
   - Fix bugs and serious maintainability problems discovered in the current task's code.
   - Reduce unintended impact on existing behavior when the implementation is broader than necessary.
   - Keep edits narrow and aligned with existing patterns.
   - Do not rewrite unrelated code while reviewing.
9. Verify:
   - Identify relevant test commands from package scripts, Makefiles, CI configs, project docs, or nearby test conventions.
   - If the repository has unit tests relevant to the changed area, run them after review and cleanup.
   - If the repository has performance tests or benchmarks relevant to the changed area, run them when the change could affect performance or hot paths.
   - Run the smallest relevant tests, type checks, linters, builds, or targeted commands available for the changed area.
   - If no automated check exists, perform a focused manual verification by re-reading the final diff.
   - Re-run `git diff` after cleanup to ensure the final patch contains only intentional changes.

## Review Heuristics

- Prefer evidence from the diff and surrounding code over assumptions.
- Treat dead code as a first-class review issue because it reduces readability and future maintainability.
- A finding should explain a concrete failure mode, maintenance cost, or consistency problem.
- Review impact as a design constraint: existing behavior should change only where the task requires it.
- If a concern is possible but unlikely and the codebase already accepts that risk, omit it.
- When in doubt between reporting a minor issue and keeping the review focused, keep the review focused.

## Final Response

Respond in the user's language. Lead with findings ordered by severity.

If issues were found and fixed, include:

- The fixes applied.
- The files changed.
- The verification performed.
- The existing-functionality impact assessment, especially any intentionally changed behavior.
- Any remaining risks or checks that could not be run.

If no meaningful issues remain, say that clearly and mention the verification performed. Do not claim the review is complete without fresh verification evidence.
