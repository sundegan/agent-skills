---
name: tauri-codegen
description: Generate, modify, and refactor code in existing Tauri applications while preserving the repository's established Rust, frontend, configuration, architecture, and testing conventions. Use when implementing Tauri features, commands, events, state, plugins, windows, menus, tray behavior, permissions, capabilities, frontend integrations, native APIs, or related bug fixes and refactors.
---

# Tauri Codegen

## Goal

Implement complete Tauri application changes that fit the existing codebase. Keep code concise, readable, maintainable, and narrowly scoped. Prefer established local patterns over generic Tauri examples, avoid speculative abstractions, remove code made obsolete by the change, and add tests according to behavior and risk.

## Workflow

1. Establish the task boundary:
   - Read the user request and identify the expected behavior, affected platforms, and acceptance criteria.
   - Inspect `git status --short` before editing. Preserve unrelated user changes.
   - Locate the Tauri root, frontend root, workspace manifests, package scripts, test setup, and CI checks.
2. Discover the local implementation style:
   - Determine the Tauri major version from `Cargo.toml`, lockfiles, configuration, and existing APIs. Do not assume a version.
   - Read the closest related Rust modules, frontend components or services, Tauri configuration, capabilities, permissions, and tests.
   - Trace the full path for similar behavior: UI action, frontend wrapper, serialization boundary, Tauri command or event, domain logic, state, and native side effect.
   - Record the local conventions for module placement, naming, errors, serialization, state ownership, async work, logging, dependency injection, and tests.
3. Plan the smallest coherent change:
   - Reuse existing helpers and boundaries when they fit.
   - Add an abstraction only when it removes meaningful duplication, isolates a real boundary, or matches a pattern already used by the repository.
   - Avoid generic repositories, service layers, traits, wrappers, builders, or utility modules for a single simple call.
   - Keep Tauri commands thin when the codebase already separates transport from domain logic. Otherwise, follow the repository's existing level of separation.
4. Implement end to end:
   - Make the Rust backend, frontend integration, configuration, permissions, capabilities, and platform-specific changes required for the feature to work.
   - Preserve existing public interfaces and behavior unless the task explicitly changes them.
   - Follow existing error and result types. Return actionable errors across the invoke boundary without exposing sensitive internals.
   - Keep payload types explicit and serialization-compatible on both sides.
   - Use the repository's established wrappers for `invoke`, events, windows, plugins, and native APIs instead of creating parallel access paths.
5. Clean up while editing:
   - Remove imports, variables, functions, branches, files, feature flags, configuration, permissions, comments, and tests made obsolete by the task.
   - Remove task-adjacent dead code only when its obsolescence is clear and removal does not change an unrelated public contract.
   - Update all call sites after changing a command, payload, event, state shape, or exported API.
   - Do not leave compatibility wrappers, duplicated implementations, or TODO comments unless a real compatibility requirement remains.
6. Decide and implement test coverage:
   - Inspect nearby tests and CI before choosing the test type.
   - Update existing tests whenever the change intentionally alters covered behavior, payloads, errors, snapshots, permissions, or configuration.
   - For new features, add unit tests for deterministic Rust domain logic, validation, parsing, state transitions, error mapping, and frontend logic that can run without a desktop runtime.
   - Add integration tests when behavior crosses internal modules but can still run without driving the application UI.
   - Add end-to-end UI tests when the essential behavior depends on the real Tauri bridge or native application lifecycle, including commands, events, windows, menus, tray actions, dialogs, filesystem access, deep links, or plugin integration.
   - Follow the repository's existing UI test framework and fixtures. Do not introduce a new E2E stack when an equivalent one already exists.
   - If native automation is unavailable, extract and unit-test deterministic logic, perform the strongest available build or smoke check, and report the untested native path explicitly.
   - Avoid tests that only mirror implementation details or assert trivial framework wiring.
7. Verify the final result:
   - Run the smallest relevant tests first, then the repository's applicable formatter, linter, type checker, Rust checks, and build commands.
   - Prefer discovered project commands such as `cargo fmt --check`, `cargo clippy`, `cargo test`, frontend test scripts, type checks, and Tauri build or dev smoke checks.
   - Re-read the final diff for accidental generated files, broad permission changes, duplicated code, stale references, and unrelated formatting churn.
   - Confirm that new files are used, removed files are no longer referenced, and the implementation covers the user-visible workflow end to end.

## Design Rules

- Let nearby production code define style; do not impose a new architecture during a feature change.
- Prefer direct code with clear names and short control flow over indirection.
- Keep shared types synchronized across Rust and frontend boundaries using the repository's existing generation or declaration strategy.
- Avoid blocking the async runtime with filesystem, process, network, or CPU-heavy work; use the local async or blocking-work pattern.
- Treat Tauri state and event listeners as lifecycle-sensitive resources. Prevent duplicate registration, stale listeners, leaked subscriptions, and accidental global mutable state.
- Keep platform-specific behavior isolated behind existing conditional-compilation or adapter patterns.
- Add dependencies only when the standard library, Tauri APIs, or existing dependencies do not provide a clear solution.
- Do not update unrelated dependencies or regenerate broad lockfile changes without need.

## Completion Criteria

- The feature or fix works across every affected layer.
- The implementation matches nearby code style and architecture.
- No task-created dead code, stale configuration, or unused permission remains.
- Existing behavior outside the task remains unchanged.
- Relevant tests are updated, and new feature logic has the strongest practical automated coverage.
- Formatting, checks, tests, and builds pass, or any unavailable verification is reported precisely.

## Final Response

Respond in the user's language. Summarize the implemented behavior, important design choices, cleanup performed, tests added or updated, and verification commands and results. State any platform path or native UI behavior that could not be exercised.
