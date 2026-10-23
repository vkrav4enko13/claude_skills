# S8. Ponytail ideas

> The executor takes the first rung that solves the slice, the simplify brief checks readability, the review asks for evidence.

- **Status:** bypassed
- **Covers:** R13
- **Depends on:** S7
- **Files:**
  - change: `swork/references/executor.md` (task block, the reuse rule), `swork/references/simplify.md`, `swork/references/review.md`
- **Interfaces:**
  - takes: `tests/skills-check.sh` (S3)
- **Reuse:** the ideas card `docs/work/ponytail-lean/ideas.md` only (never the ponytail source); the LGS wording, `~/Documents/7rings/lgs-front-designer/lgs-wiki/skills/game/lgs-work/references/executor.md` rule 8, `simplify.md` `## Readability` and "A safeguard beyond the task", `review.md` "The evidence bar"
- **What to do:**
  - Executor: before writing code list every place the change must reach (callers, overrides, config, exports), then the first rung that fully solves it — not needed → already in the project, used as the neighbours use it → the standard library or the platform → one readable line → the minimum working code; a bug fixed once in the shared function after finding all its callers; validation, error handling and what the plan asked for are never cut.
  - Simplify: a section `## Readability` (the neighbours' idiom, names, flat code; formatting is not a finding) and a "safeguard beyond the task" item.
  - Review: an evidence bar — a concrete case where the finding fires, the place reread, "unused" only after a whole-tree search, the smallest fix, no "might".
  - Write the phrases of line 15 word for word.
- **Checks:** line 15
