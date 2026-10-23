# S5. swork levers

> swork runs the closing pass once and only for code, builds small slices itself, writes its records in one batch and re-checks only what changed.

- **Status:** done
- **Covers:** R7, R8, R9, R10, R11 (swork part), R3 (swork rules)
- **Depends on:** S4
- **Files:**
  - change: `swork/SKILL.md` (stages table, "Rules for all stages", traps), `swork/references/finish.md`, `swork/references/review.md`, `swork/references/simplify.md`, `swork/references/conformance.md`, `swork/references/report.md`, `swork/references/slices.md`, `swork/references/executor.md`, `swork/references/entry.md`, `swork/references/small.md`
  - change: `tests/chain/rules.md` (swork-1, 2, 3, 4, 6, 8, 11, 12, 14, 17, 19: each change names its requirement)
- **Interfaces:**
  - takes: `tests/skills-check.sh` (S3)
  - gives: the record `stage 7 finished` kept as the last line of the batch, also when stages 5–7 are skipped (`stages 5–7 skipped: no code`)
- **Reuse:** the LGS game chain wording as the model: `~/Documents/7rings/lgs-front-designer/lgs-wiki/skills/game/lgs-work/` (`references/finish.md` "one fresh read-only subagent", `references/slices.md` steps 3, 5, 8, `references/entry.md`), `swork/scripts/packet.sh`
- **What to do:**
  - R7: stages 5–7 — one fresh read-only subagent gets the conformance, simplify and review tasks in one message, one list of findings tagged by kind; only when the work changed code; second round only after a fixed serious finding.
  - R8: a slice without code or with small code (one file, up to about 20 changed lines) — the main session by the rules of the executor task; larger code — the executor with `packet.sh`.
  - R9: status and "Result" at once; "Progress log", notes, `state.md` and the wiki check script in one batch before the report and before any stop.
  - R10, R11: on resume (`entry.md`) rerun only the slices whose files changed after their check; the full rerun before stage 5 (`finish.md:18`) stays; no check before the edits except a bug reproduction or a baseline of a behaviour the slice changes.
  - Write the lever phrases of line 12 word for word in the place that holds each rule; the subagent of stages 5–7 gets the description `Conformance, simplify and review of <topic>`, its second round `Review round 2 of <topic>` (`trace.sh` `role_of` reads them).
- **Checks:** line 12
