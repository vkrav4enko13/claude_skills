# Conformance check. Simplification. Review

Read at step 5, after the last slice. Sections 6 and 7 always run at the very end, one round, when the work changed code.

## 5. Conformance check

Record "stage 5 started", "stage 5 finished" and so on for the stages that run; `stage 7 finished` is the batch's last line either way. In this form, not as free text.

**First — files outside the plan** by `references/snapshot.md`, "Files outside the plan".

**Then — the checks of the changed blocks, once.** Rerun only the checks of the blocks whose files changed after their check (the block check) (a later block, a fix, the restore of files outside the plan), each distinct command once; the other blocks keep their "Result". Red — steps 5 and 6 of section 3 of `references/slices.md` for its slice; red after two — "Decisions and bypass" there. `not checked` counts as manual-check only.

**Only when the work changed code.** Code: scripts, programs, source files; not texts, documents, cards, settings. No code changed — after the checks write `stages 5–7 skipped: no code`, then `stage 7 finished`.

**The main session checks it itself**, no subagent: read `git diff` and the new files against the slice cards by `references/conformance.md`. Bypassed and dependent slices and a bypassed one's half-made edits are not findings; name them in "Deviations from the plan". In order:

1. **"missing" and "wrong"** — an attempt for the owning slice by step 6 of section 3, by its build path; an executor gets the finding text, not the failed output. Not closed in two — report it unclosed; edits stay while the slice check is green. No stop.
2. **"beyond the plan"** — revert only the superfluous file or piece; run the affected slices' checks.
   - Passed — removed, a report line.
   - Failed — undo the revert, report it.
   - An affected slice manual-check only or `not checked` — keep it, report it.

## 6. Simplification

Always, at the very end, when the work changed code; one round. One fresh read-only subagent that has not seen the conversation gets in one message the header and both tasks of `references/simplify.md` and the task of `references/review.md`; description `Simplify and review of <topic>`. Add: findings tagged `reuse`, `redundant` or `error`; bypassed slices: `Bypassed, not to be reported: S<N> — <files>`. Check its READ line against the changed and new files: a missing one goes into "Not read by the reviewers".

Check each finding in the code yourself. Edit within "What not to touch" of `references/simplify.md`.

**Batches.** Findings of slices sharing files, also by a chain, form one batch; then its slices' checks. Red — undo the batch's edits, report the findings as untouched. A batch slice manual-check only or `not checked` — apply nothing, report the findings.

Skip, without asking, a false finding or one "What not to touch" forbids; count them in the report.

## 7. Review

The `error` findings of the same subagent, screened by `references/review.md`; batches and a red check as in section 6. Then the report anew.
