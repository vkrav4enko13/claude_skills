# S6. Acceptance of two agents at once

> The live pair runs, the blind scenarios and the earlier stand checks prove the work; the rollout follows the user's acceptance.

- **Status:** done
- **Covers:** R3, R4, R7, R8, R9, R11, R12, R13, R14, R15, goal
- **Depends on:** S1, S2, S3, S4, S5
- **Files:**
  - change: `docs/notes/stand-nonstop-parallel.md` (only if a run shows a new fact about the temp folder)
- **Interfaces:**
  - takes: `pair-run.sh`, `pair-scenarios.md`, `pair-expected.tsv` (S1); all skill texts of S2–S5
- **Reuse:** `nonstop-run.sh`, `away-check.sh`, `run-check.sh`, `away-blind.sh` as they are
- **What to do:**
  1. Run lines 8–11 one at a time — the two pair cases are each already two sessions; no two pair runs at once.
  2. A red pair line: read both `chat.md` and the progress records of the stand; a cause in a skill text is a red check of the owning slice S2–S5, not of S6.
  3. Line 12 is manual and waits for the user's acceptance and commit; no other slice depends on it.
- **Checks:** lines 8, 9, 10, 11, 12
