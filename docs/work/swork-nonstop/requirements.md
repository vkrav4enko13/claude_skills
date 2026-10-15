# Requirements of topic swork-nonstop

> How `swork` decides instead of stopping and how it reports — R1–R12; `saway`, wiki and rules — in [part 2](requirements-2.md).

## Run without stops

- R1. Once started, `swork` goes through the slices, the conformance check, the simplification and the review to the report without asking the user anything; the menu after the report is its only wait.
- R2. When `swork` meets a case that was a stop of section 4 or a question of continuing interrupted work, `swork` decides by R3–R8, writes in the chat a highlighted line `⚠ Decided myself — S<N>: problem → choice → why` in the user's language and goes on without waiting.
- R3. If the code differs from the plan not in a minor way, the check is red after two attempts, or the check is green before the edits of a slice that is not done, then `swork` edits the card of that slice and its check lines itself, at most twice per slice; it writes "was → became → why" before the edit, does not edit the goal, the shared constraints or "Not doing", and does not fit the expected value to the code.
- R4. If a slice has used its two edits of R3, then `swork` bypasses it: the slice and the slices that depend on it — through "Depends on", directly or by a chain, or by a shared file — are not executed; everything else is.
- R5. Before a slice with a "Rollback" section, `swork` carries out the saving of that section and then the slice.
- R6. If a check cannot be run because of the environment, then `swork` tries to restore the environment — wakes the machine, starts the service — and runs the check again; if it is not restored, the slice is marked "not checked" and the work goes on.
- R7. While a slice awaits a manual check, `swork` executes the slices that depend on it and marks them "on unchecked ground".
- R8. If a changed file outside the plan has nothing to restore it with, or when continuing it is unknown whose edits a file holds, then `swork` writes its path into `known.txt`, does not touch the file and names it in the report. When continuing, `swork` continues rather than starts anew, establishes by the code what ran in a slice with a "Rollback" section, and takes an unreported manual check as "not checked".
- R9. When the user writes during the run, `swork` applies the correction from its next step without stopping.

## Records and report

- R10. `swork` writes every decision of its own into "Progress log" as `S<N>: decided myself — problem; chosen; why; otherwise`.
- R11. The `swork` report has a section "Decided myself": every decision with the problem, the choice, the reason and what would have been otherwise; separately — the bypassed slices, the "not checked" ones, the ones "on unchecked ground" and the paths of `known.txt`.
- R12. `swork` keeps two attempts at a fix per slice and does not execute a plan whose phase is not `plan confirmed`.
