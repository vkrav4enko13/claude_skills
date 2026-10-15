# Progress log of topic swork-nonstop, part 2

> Stages 5–7: the conformance check, the simplification, the review and what was left.

- stage 5 started — all checks anew: lines 1, 2, 3, 4, 6, 8, 9 green (`.swork/checks/R-l*.txt`); lines 5, 7, 10–14 ran after the last edit
- stage 5 finished — the conformance check: nothing missing, beyond the plan or wrong; plan gaps: `not checked: <reason>` is written by no text of `swork`, `entry.md:19` names a report target `report.md` lacks
- stage 6 finished — one finding (`nonstop-run.sh:19` redundant with `stand.sh:17`) skipped: removing it moves the error after `mktemp` and the `stand:` line, a change of behaviour
- stage 7 started
- stage 7: fixed — `slices.md` bypass restore no longer wipes files of slices `awaiting manual check` or `not checked`; an own card edit may change any field of the slice card (R3), not only a path, a command or "Files"; line 8 green
- stage 7, second round: fix of the restore rule confirmed; the widened card edit ("any field") was the fix that brought an error — "Checks", "Marks", "Depends on", "Rollback" became editable, so a slice could pass itself — reverted to the stage-7 wording
- decided myself — the revert of one of two fixes in one file; chosen: revert only that sentence, keep the confirmed restore fix; why: the rule restores the fix that brought the error, not its neighbour; otherwise: the confirmed data-loss fix would be lost too
