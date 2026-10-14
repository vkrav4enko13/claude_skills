# S6. The skills pin `medium`

> A skill started in a session at any level runs its first turn and all its subagents at `medium`; the `ready text` executor is no exception.

- **Status:** done
- **Covers:** R2, R3, R4
- **Depends on:** S4
- **Marks:** ready text
- **Files:**
  - change: `sbrain/SKILL.md`, `splan/SKILL.md`, `swork/SKILL.md`, `saway/SKILL.md` (the frontmatter; in the first three one new paragraph)
  - change: `swork/references/slices.md` (section 3 "Slices", step 3)
  - change: `tests/chain/rules.md` (the `file:line` tails)
- **Interfaces:**
  - takes: `series.sh … --effort` (S2), `trace.sh <series> efforts` (S1)
  - gives: the paragraph "Subagents run at `medium`." in three `SKILL.md` — the gate procedure adds a sentence about one role right after a launch place, S8 writes the level into the launch of a stage subagent
- **Reuse:** nothing to reuse — searched: the four skills for `effort`; the only mention is `swork/references/slices.md:38`
- **What to do:**
  - In the frontmatter of the four `SKILL.md` add the line `effort: medium` after the `argument-hint` line.
  - In `sbrain/SKILL.md`, `splan/SKILL.md` and `swork/SKILL.md`, right after the paragraph that starts with `**Every stop says what is needed from the user.**`, add the paragraph: ``**Subagents run at `medium`.** Launch every subagent of this skill with effort `medium`, using the effort parameter of the subagent launch tool; if there is no such parameter, at the session level.``
  - In `swork/references/slices.md`, step 3, delete the two sentences from "For a slice marked `ready text`, launch the executor with effort `high`" to "all other subagents run at the session level."
  - Run `bash tests/chain/series.sh pin . --runs 1 --stages seed --effort high`.
- **Checks:** lines 17, 18, 19
