# S4. Baseline series `medium`

> The stand shows that the chain at `medium`, on the texts as they are, passes the quality gate; the baseline for every later number exists.

- **Status:** done
- **Covers:** R5, R6, R7
- **Depends on:** S1, S2, S3, S13, S14
- **Files:**
  - create: `tests/chain/raised.tsv`
- **Interfaces:**
  - takes: `series.sh … --effort` and `drive.sh … [<level>]` (S2), `gate.sh` (S3), `trace.sh` (S1)
  - gives: the series `$S/medium` with its verdicts in `$S/blind`; the run `$S/away-m/1` with the project `box/wiki-trial/clean` and the stage folder `away`; `tests/chain/raised.tsv` — tab-separated, the header row `role⇥level⇥series⇥failed`, a row per raise
- **Reuse:** the gate procedure of `plan-2.md`; `tests/chain/stand.sh <folder> <skills folder>`, `tests/chain/seed-away.sh <project>`, `tests/chain/away-check.sh <project> <stage folder>`
- **What to do:**
  - First `git status --short sbrain splan swork saway` must list only the files of S13 and S14: the baseline is taken on the texts of commit `1c4f384` with the text fixes of S13 and S14. It lists another — a discrepancy.
  - Run the series `medium` by step 1 of the gate procedure on a clean series (step 3). The gate failed — step 2.
  - Run the stage `away` once: `B="$S/away-m/1"; mkdir -p "$B"; bash tests/chain/stand.sh "$B/box" .; bash tests/chain/seed-away.sh "$B/box/wiki-trial/clean"; bash tests/chain/drive.sh "$B/box/wiki-trial/clean" away "$B/away" medium`, then `away-check.sh`. It prints `away run: fail` — reply `could not` with its failed lines; delete `$S/away-m` before a rerun.
- **Checks:** lines 12, 13, 14
