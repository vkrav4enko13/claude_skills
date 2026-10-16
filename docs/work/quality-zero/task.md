# Task of topic quality-zero

> What we build, for whom, and how we will know it worked.

## In brief

The four chain skills `sbrain`, `splan`, `swork`, `saway` at effort `medium` pass one whole stand series — three runs of the lanes, the `saway` stage, three `nonstop` runs and three `pair` runs — with zero judge violations and full thresholds. Before the first series the stand holes and every already known defect are fixed: the two visible violations, the deferred review findings, two `multi-agent` findings, a deletion ban for the reviewer, a trigger check of `saway` against `lfg`.

## Task

- The user runs the chain on their own projects and leaves it to work alone; every skipped plain rule costs them a check by hand or a broken record.
- Now the stand shows skipped rules that the skill texts ask for plainly: a free-text stage-7 record of `swork`, a missing progress line in the first `saway` reply (1 green of 3 runs).
- `saway` has no judge rules, so its runs are not judged at all; `nonstop` and `pair` runs stand outside the series.
- The stand itself has holes: a reviewer of a tested `swork` wiped the shared temp folder; `state.sh restore` deletes new test files; `verdict.sh` counts a malformed verdict as zero violations.
- Review findings of earlier topics were left untouched because each needed a plan fix.

## Success criteria

- The acceptance series meets R19.
- If R19 is not met after three rounds, the report names every remaining violation and its cause (R20).
- The deferred findings named in R10–R15 are fixed, each shown by its own check.
