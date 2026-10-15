# S4. Report "Decided myself" and splan in line

> The report lists every decision with its reason; `splan` knows the new statuses and shows the irreversible slices.

- **Status:** done
- **Covers:** R6, R7, R8, R9, R11, R12
- **Depends on:** S2, S3
- **Files:**
  - change: `swork/references/report.md` (sections, lines 14, 22, 30–33)
  - change: `splan/references/plan-format.md` (lines 108, 137, 143)
  - change: `splan/references/approval.md` (step 6 item 2, step 9)
  - change: `splan/references/review.md` (line 18)
  - change: `splan/SKILL.md` (line 41)
- **Interfaces:**
  - takes: the statuses `bypassed`, `not checked`, the log line form and the marks of S3
  - gives: the report section `Decided myself`
- **Reuse:** the section list and the deviations item of `report.md`; the slice rules list of `plan-format.md`
- **What to do:**
  1. `report.md`: a section `Decided myself` right after what was done: every `decided myself` line of "Progress log" (or of the chat for a small change) as problem — choice — why — otherwise; then `Bypassed` (slice, reason, dependents not executed), `Not checked`, `On unchecked ground`, the paths of `known.txt`, the "Rollback" slices executed without consent. "Deviations from the plan" keeps only what is not a decision of this list.
  2. `plan-format.md`: status values `not started`, `done`, `awaiting manual check`, `not checked`, `bypassed`; result values add `not checked: <reason>`; the irreversible rule adds "the saving and the restore command are runnable as written: `swork` runs them without asking".
  3. `approval.md`: at the stop before writing and in the shown plan name the slices with "Rollback" and the manual checks that other slices depend on.
  4. `review.md:18`: the reviewer checks that the "Rollback" commands run as written.
  5. `splan/SKILL.md:41`: "the reason for the stop" → "the own decisions and the bypassed slices".
- **Checks:** lines 6, 9
