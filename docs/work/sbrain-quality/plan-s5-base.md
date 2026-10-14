# S5. The baseline series `sv-base`

> Three runs of `survey` and `grill` on the present texts give the numbers every fix is measured against.

- **Status:** done
- **Covers:** R8, R12
- **Depends on:** S4
- **Files:**
  - none in the project; the stand folder `$S/sv-base`
- **Interfaces:**
  - gives: the series `sv-base`, judged
- **Reuse:** `series.sh`, `judge.sh`, `survey-gate.sh`, `trace.sh`
- **What to do:** `git status --short sbrain` prints nothing; `bash tests/chain/series.sh sv-base . --stages "survey grill" --effort medium` with `--runs 1`, `2`, `3`; then `bash tests/chain/judge.sh sv-base`. In the reply list every `no` line and every missed seed with its run, and the end reason of every stage from `ended.txt`. `trace.sh` counts the `sbrain` sessions only: the stand-in user and the judge are not in the cost.
- **Checks:** line 11
