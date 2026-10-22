# Ideas of ponytail, clean-room spec

> The reader agent's spec of ponytail ideas in its own words, approved by the user 2026-10-17; the only input of the writer of the skill edits.

## Core rules
1. Close every reply with one or two lines: what was not built, not verified, risks.
2. Understand before minimising: read the task and touched code; list every place the change must reach (callers, tests, fixtures, config, exports) and what could break for users. That list is the scope.
3. Ladder, first rung that fully works: needed at all? (drop unrequested, name in one line; vague request → core version) → already in the codebase (reuse as neighbours do) → standard library / platform (a house component beats a native one) → an installed dependency (never add one to save a few lines) → one readable line → minimum working code.
4. No speculative structure: no unrequested abstraction, wrapper, conversion, option, config, "for later"; keep data in the platform's form; prefer deleting; keep existing layers.
5. Shortest diff only after the scope is known, and only if readable.
6. Comments only for the "why", one line.
7. Bug fixes at the root: search every caller of the touched function, fix the shared function once. Measured: the concrete instruction "search the callers" worked (1/6 → 6/6), a prose "trace the flow" did not.
8. Moved or merged code keeps its validation and error handling.
9. Equal size → the option correct on edge cases.
10. New non-trivial logic (branch, loop, parser, money, security, a new script) gets one small test or a few assertions; trivial edits none. One test, not coverage.
11. Deliberate shortcuts carry a marker comment with the ceiling and the upgrade trigger; a debt command collects them.
12. Never cut: trust-boundary validation, data-loss error handling, security, accessibility, hardware calibration, anything the user asked for. Overrides the ladder.
13. Levels lite / full / ultra (ultra also challenges the request).
14. A requested detailed explanation is given in full.
15. A rule change is accepted only with a benchmark: no skill / current / candidate, same task and model, ≥6 runs per arm, a target task and a task it might break. Wording fixes that do not move numbers are rejected.

## Tokens and speed
- Savings come mostly from writing less code (over-build traps: native feature or existing component instead of a custom build); terse prose alone is minor and once cost more.
- Cost falls less than output tokens: always-on rules are extra input on every call.
- Rules sent once at session start, after compaction and into each subagent; filtered to the active level; a level switch sends one line.
- Codebase map at session start: top-level functions/classes/exports, ~2,000 chars, shared folders first, tests and generated skipped — reuse without search turns. Pattern-based, misses nested definitions.
- Hooks time-limited and fail open.

## Benchmark
- Arms no skill / previous / new, interleaved by task; 39 tasks × 5 runs; fresh temp folder outside git; project instructions and memory off; shell off (harness runs the code).
- Tasks: 12 feature tickets on a pinned template, 18 surgical tasks with hidden checks (safety, bug fixes, renames that must reach every caller, reuse probes), 9 open "build me" requests.
- Metrics: delivered source lines (tests excluded), compressed size, output tokens, cost, time, turns, hidden-check pass rate, completeness judge 0–3, over-engineering judge 0–3 naming the construct, pairwise blind reply judge (reader then grader).
- Median of 5 per task, ratio to baseline, geometric mean with bootstrap CI; sign test.
- Every scorer has a good and a bad reference and a self-test before paid calls; judges trusted only after a ranking self-test.
- Tests: tasks pre-sorted needs-test / not; test value checked by injected bugs (flipped comparison, dropped condition, off-by-one).
- Admitted limits: correctness level across arms; only 18 tasks truly checked; tests written where not needed 45 %; reuse rung unproven; cost savings vendor-dependent; small models cannot follow "search the callers".

## Review and audit
- Report only. Priority: correct, safe, holds under load, tested, fast, lean.
- Review reads diff, callers, callees, tests, README; a signature or behaviour change triggers a search for every caller; states the assumed load.
- Categories: bug, risk, scale, missing test (risky logic only), speed, lean (delete, reuse with path, stdlib, YAGNI, merge near-copies, split by responsibility).
- Evidence gate: a concrete triggering case per finding; re-read to confirm; whole-tree search before "dead"; a marked shortcut is a decision, not a finding; smallest fix, preferably a deletion; no style, no hedges.
- Output: summary + assumed load; three tiers; numbered; each finding: what the code is for, what goes wrong, fix, cost of skipping; verdict, removable lines, what was not checked.

## Out of the core
Band and board (cost/tokens/reuse share panel, local CSV board), status line, config resolution, per-host adapters, i18n of the README, gain and help cards.

## License
MIT; a clean-room re-implementation of ideas carries no notice obligation; credit optional.
